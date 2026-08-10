#!/bin/bash
# ============================================================================
# Boltz-2 binder:target validation harness
#
# Validated against a positive control (crystallographic nanobody:antigen
# pair, PDB 1MEL) and a non-cognate negative before being trusted on any
# de novo design in this project. Under this protocol, AF2-multimer ipTM
# was shown to be UNRELIABLE for nanobody scaffolds (a true binder scored
# below a non-cognate decoy); Boltz-2 ipTM correctly separated them
# (0.96 true binder vs 0.42 decoy). Use Boltz-2 ipTM, not AF2 ipTM, for
# nanobody-scale binder ranking.
#
# Usage:
#   1. Prepare a JSON file: {"seqs": {name: sequence, ...},
#                            "complexes": {name: [binder_seq_name, target_seq_name], ...}}
#   2. bash boltz2_validation_harness.sh <input.json> <output_dir>
#
# Requires: a Boltz-2 install (boltz_venv) and network access to the
# ColabFold MSA server (api.colabfold.com). Adjust BOLTZ_VENV/BOLTZ_CACHE
# below to your environment.
# ============================================================================
set -eo pipefail

INPUT_JSON="${1:?usage: boltz2_validation_harness.sh <input.json> <output_dir>}"
OUT_DIR="${2:?usage: boltz2_validation_harness.sh <input.json> <output_dir>}"

BOLTZ_VENV="${BOLTZ_VENV:-/workspace/boltz_venv}"
BOLTZ_CACHE="${BOLTZ_CACHE:-/workspace/boltz_cache}"

mkdir -p "$OUT_DIR" "$OUT_DIR/boltz_yamls"
LOG="$OUT_DIR/boltz_harness.log"
exec > >(tee -a "$LOG") 2>&1
echo "=== Boltz-2 validation harness start $(date) ==="

# ---------- Build one YAML per complex from the input JSON ----------
python3 << PYEOF
import json
d = json.load(open("$INPUT_JSON"))
seqs, comps = d["seqs"], d["complexes"]
for name, (b, t) in comps.items():
    y = ("version: 1\nsequences:\n"
         f"  - protein:\n      id: A\n      sequence: {seqs[b]}\n"
         f"  - protein:\n      id: B\n      sequence: {seqs[t]}\n")
    open(f"$OUT_DIR/boltz_yamls/{name}.yaml", "w").write(y)
print("built", len(comps), "complexes")
PYEOF

# ---------- Boltz-2: MSA server, 3 recycles, 1 sample, no_kernels ----------
export PATH="/workspace/uv:$PATH"
source "$BOLTZ_VENV/bin/activate"
export BOLTZ_CACHE

for y in "$OUT_DIR"/boltz_yamls/*.yaml; do
  echo "boltz: $y"
  boltz predict "$y" --out_dir "$OUT_DIR/out_boltz" --cache "$BOLTZ_CACHE" \
    --accelerator gpu --recycling_steps 3 --diffusion_samples 1 \
    --output_format pdb --use_msa_server --no_kernels --override
done

# ---------- Flatten deliverables ----------
mkdir -p "$OUT_DIR/results"
find "$OUT_DIR/out_boltz" -name "confidence_*.json" -exec cp {} "$OUT_DIR/results/" \; 2>/dev/null || true
find "$OUT_DIR/out_boltz" -name "*_model_0.pdb" -exec cp {} "$OUT_DIR/results/" \; 2>/dev/null || true

echo "=== Boltz-2 validation harness done $(date) ==="
echo "Results (confidence JSON + predicted PDB per complex) in: $OUT_DIR/results/"
