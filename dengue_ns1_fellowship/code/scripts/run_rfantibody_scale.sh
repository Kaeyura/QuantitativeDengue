#!/bin/bash
# Scale up: RFantibody nanobody design on DENV-2 NS1 Direction C patch
# Target: 150+ designs (vs prior 8-design pilot)
set -e

HOTSPOT="${HOTSPOT:-61,62,63,154,180,183,198,218}"
N_DESIGNS="${N_DESIGNS:-150}"
TARGET="${TARGET:-/workspace/ns1_directionC_T.pdb}"  # use prior target file
JOBDIR="$(pwd)"
OUT="$JOBDIR/out_rfd"
mkdir -p "$OUT/rfd" "$OUT/mpnn" "$OUT/af2"

echo "=== RFantibody Direction C scale-up run ==="
echo "Hotspot: $HOTSPOT"
echo "N designs: $N_DESIGNS"
echo "Target: $TARGET"
ls -lh "$TARGET"

# Activate RFantibody environment (uv-isolated, not conda)
source /workspace/rfantibody_boot.sh
cd /workspace/RFantibody

# STAGE 1: RFdiffusion nanobody backbones (VHH/camelid single-domain antibody)
echo "### STAGE 1: RFantibody RFdiffusion $(date)"
python scripts/rfdiffusion_inference.py \
  --input_pdb "$TARGET" \
  --output_dir "$OUT/rfd" \
  --hotspots "$HOTSPOT" \
  --num_designs "$N_DESIGNS" \
  --length 100 \
  --num_recycles 0

N_BACKBONES=$(ls -1 "$OUT/rfd"/*.pdb 2>/dev/null | wc -l)
echo "RFantibody backbones: $N_BACKBONES"
if [ "$N_BACKBONES" -lt "$((N_DESIGNS / 2))" ]; then
    echo "WARNING: only $N_BACKBONES / $N_DESIGNS designs completed (RFd stage may have failed)"
fi

# STAGE 2: ProteinMPNN sequence design on the backbones
echo "### STAGE 2: ProteinMPNN $(date)"
source /workspace/mpnn_boot.sh
cd /workspace/ProteinMPNN
python helper_scripts/parse_multiple_chains.py \
  --input_path="$OUT/rfd" --output_path="$OUT/mpnn/parsed.jsonl"
python helper_scripts/assign_fixed_chains.py \
  --input_path="$OUT/mpnn/parsed.jsonl" --output_path="$OUT/mpnn/fixed.jsonl" \
  --chain_list "B"  # Design chain B (VHH), fix chain A (NS1 target)

export CUDA_VISIBLE_DEVICES=0
python protein_mpnn_run.py \
  --jsonl_path "$OUT/mpnn/parsed.jsonl" \
  --chain_id_jsonl "$OUT/mpnn/fixed.jsonl" \
  --out_folder "$OUT/mpnn" \
  --num_seq_per_target 2 \
  --sampling_temp "0.1" \
  --batch_size 1

N_SEQS=$(ls -1 "$OUT/mpnn/seqs"/*.fa* 2>/dev/null | wc -l)
echo "MPNN sequence sets: $N_SEQS"

# STAGE 3: AF2-multimer validation (dl_binder_design af2_initial_guess)
echo "### STAGE 3: AF2-initial-guess validation $(date)"
source /workspace/dlbinder_boot.sh
python "$DLBINDER/af2_initial_guess/predict.py" \
  -pdbdir "$OUT/rfd" \
  -outpdbdir "$OUT/af2" \
  -scorefilename "$OUT/af2/scores.sc"

echo "### AF2 validation complete"
ls -lh "$OUT/af2/scores.sc"

# Parse the score file and report pass rate
echo "### Parsing AF2 scores"
python3 << 'PYEOF'
import pandas as pd
import sys
try:
    sc = pd.read_csv("out_rfd/af2/scores.sc", sep=r'\s+')
    if 'pae_interaction' not in sc.columns:
        print("ERROR: score file missing expected columns")
        sys.exit(1)
    pass_strict = ((sc.pae_interaction < 5.0) & (sc.plddt_binder > 80.0)).sum()
    pass_relaxed = (sc.pae_interaction < 10.0).sum()
    print(f"\nPASS RATE SUMMARY:")
    print(f"  Strict (pAE<5, plddt_binder>80):  {pass_strict}/{len(sc)} = {100*pass_strict/len(sc):.1f}%")
    print(f"  Relaxed (pAE<10):                  {pass_relaxed}/{len(sc)} = {100*pass_relaxed/len(sc):.1f}%")
    print(f"\nBest interaction_pAE: {sc.pae_interaction.min():.2f} Å")
    print(f"Best binder pLDDT:    {sc.plddt_binder.max():.1f}")
    print(f"Mean interaction_pAE: {sc.pae_interaction.mean():.2f} Å")
    sc.to_csv("out_rfd/af2/parsed_scores.csv", index=False)
    print(f"\nScores saved to: out_rfd/af2/parsed_scores.csv")
except Exception as e:
    print(f"ERROR parsing scores: {e}", file=sys.stderr)
    sys.exit(1)
PYEOF

echo "### DONE $(date)"
echo "Output structure: $OUT/"
du -sh "$OUT"/*

