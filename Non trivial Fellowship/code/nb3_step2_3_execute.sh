#!/bin/bash
set -e

# =============================================================================
# STEP 2+3 MERGED: Hotspot-Steered RFdiffusion + ProteinMPNN + Boltz-2 Validation
# =============================================================================
# Input:  seed 5 binder framework (118 aa, on-epitope, ipTM 0.752)
#         NS1 target PDB
#         Hotspots: {269, 272, 274} on NS1 (B-chain)
# Output: 12 RFdiffusion designs → 48 ProteinMPNN sequences → Boltz-2 scores on top 8
# =============================================================================

WORKSPACE=/workspace
SCRATCH=$WORKSPACE/cs_scratch
OUTPUT_DIR=$SCRATCH/nb3_step2_3
WORK_DIR=$OUTPUT_DIR/work

echo "Step 2+3: Hotspot-Steered Refinement (from Seed 5)"
echo "============================================================"
echo "Output: $OUTPUT_DIR"

mkdir -p "$WORK_DIR" "$OUTPUT_DIR/designs" "$OUTPUT_DIR/boltz_results"
cd "$WORK_DIR"

# Activate RFantibody environment
echo "[Setup] Activating RFantibody environment..."
source /workspace/rfantibody_boot.sh > /dev/null 2>&1 || {
    echo "WARNING: rfantibody_boot.sh failed; assuming already active"
}

# ============================================================================
# STEP 2a: RFdiffusion Hotspot-Steered Design
# ============================================================================
echo ""
echo "[2a] Running RFdiffusion with hotspot steering..."
echo "   Framework: seed5_binder_framework.pdb (118 aa)"
echo "   Target:    ns1_target.pdb (346 aa)"
echo "   Hotspots:  B269, B272, B274"
echo "   N designs: 12"

cd "$WORK_DIR"

uv run rfdiffusion \
    --target ns1_target.pdb \
    --framework seed5_binder_framework.pdb \
    --output-quiver designs.qv \
    --num-designs 12 \
    --design-loops "H1:7,H2:6,H3:5-13" \
    --hotspots "B269,B272,B274" \
    --diffuser-t 50 \
    --deterministic

echo "   ✓ RFdiffusion complete: 12 designs in designs.qv"

# ============================================================================
# STEP 2b: ProteinMPNN Sequence Design
# ============================================================================
echo ""
echo "[2b] Running ProteinMPNN (4 sequences per design)..."

uv run proteinmpnn \
    --input-quiver designs.qv \
    --output-quiver designs_seqs.qv \
    --seqs-per-struct 4 \
    --temperature 0.2

echo "   ✓ ProteinMPNN complete: 48 sequences (12 designs × 4)"

# ============================================================================
# STEP 2c: Extract All Designs to PDB
# ============================================================================
echo ""
echo "[2c] Extracting all designs to PDB format..."

mkdir -p "$OUTPUT_DIR/designs_pdb"

uv run qvextract designs_seqs.qv "$OUTPUT_DIR/designs_pdb"

N_PDB=$(find "$OUTPUT_DIR/designs_pdb" -name "*.pdb" | wc -l)
echo "   ✓ Extracted $N_PDB PDB files"

# ============================================================================
# STEP 3: Boltz-2 Validation (MSA-backed, Top 8)
# ============================================================================
echo ""
echo "[3] Running Boltz-2 validation on top 8 designs..."
echo "   Mode:   MSA-backed full-length"
echo "   Recycles: 3"

# Activate Boltz environment
source /workspace/boltz_venv/bin/activate

# Generate input YAMLs for all 48 designs
python3 << 'PYTHON_PREP'
import os
import json
import glob
from pathlib import Path

# NS1 sequence (target)
ns1_seq = "DSGCVVSWKNKELKCGSGIFITDNVHTWTEQYKFQPESPSKLASAIQKAHEEGICGIRSVTRLENLMWKQITPELNHILTENEVKLTIMTGDIKGIMQAGKRSLRPQPTELKYSWKAWGKAKMLSTELHNHTFLIDGPETAECPNTNRAWNSLEVEDYGFGVFTTNIWLKLKERQDVFCDSKLMSAAIKDNRAVHADMGYWIESALNDTWKIEKASFIEVKSCHWPKSHTLWSNGVLESEMIIPKNFAGPVSQHNYRPGYHTQTAGPWHLGRLEMDFDFCEGTTVVVTEDCGNRGPSLRTTTASGKLITEWCCRSCTLPPLRYRGEDGCWYGMEIRPLKEKEENLV"

design_dir = "$OUTPUT_DIR/designs_pdb"
yaml_dir = "$OUTPUT_DIR/boltz_yamls"
os.makedirs(yaml_dir, exist_ok=True)

pdb_files = sorted(glob.glob(f"{design_dir}/*.pdb"))
print(f"Found {len(pdb_files)} PDB files")

for i, pdb_path in enumerate(pdb_files):
    pdb_name = Path(pdb_path).stem
    
    yaml_content = {
        "ligand_file": os.path.abspath(pdb_path),
        "protein_A_sequence": ns1_seq,
        "protein_B_sequence": None,  # Will be read from PDB
    }
    
    yaml_path = os.path.join(yaml_dir, f"{pdb_name}.yaml")
    with open(yaml_path, "w") as f:
        f.write("ligand_file: " + yaml_content["ligand_file"] + "\n")
        f.write("protein_A_sequence: " + ns1_seq + "\n")
    
    if (i + 1) % 10 == 0:
        print(f"  Generated YAML for {i+1} designs")

print(f"Generated {len(pdb_files)} YAML files in {yaml_dir}")

PYTHON_PREP

# Score top 8 (first 8 in quiver order; typically best per diffusion)
echo ""
echo "Scoring designs 0–7 with Boltz-2..."

cd "$OUTPUT_DIR/boltz_yamls"

for i in {0..7}; do
    # Find YAML for design i
    YAML_FILE=$(ls | sort | sed -n "$((i+1))p")
    
    if [ -z "$YAML_FILE" ]; then
        break
    fi
    
    DESIGN_NAME="${YAML_FILE%.yaml}"
    BOLTZ_OUT="$OUTPUT_DIR/boltz_results/boltz_${DESIGN_NAME}"
    
    mkdir -p "$BOLTZ_OUT"
    
    echo "  [$((i+1))/8] Scoring $YAML_FILE..."
    
    boltz predict \
        --use_msa_server \
        --output_dir "$BOLTZ_OUT" \
        --cache_dir /workspace/boltz_cache \
        "$YAML_FILE" 2>/dev/null
done

echo "   ✓ Boltz-2 validation complete"

# ============================================================================
# STEP 4: Extract Metrics
# ============================================================================
echo ""
echo "[4] Extracting metrics from Boltz results..."

python3 << 'PYTHON_METRICS'
import json
import glob
from pathlib import Path

boltz_dir = "$OUTPUT_DIR/boltz_results"
results = []

for conf_dir in sorted(glob.glob(f"{boltz_dir}/boltz_*")):
    design_name = Path(conf_dir).name.replace("boltz_", "")
    
    conf_json = glob.glob(f"{conf_dir}/predictions/*/*/confidence_*.json")
    
    if not conf_json:
        print(f"   WARNING: No confidence JSON found in {conf_dir}")
        continue
    
    with open(conf_json[0]) as f:
        conf = json.load(f)
    
    results.append({
        "design": design_name,
        "ipTM": conf.get("ipTM", -1),
        "plddt": conf.get("plddt", -1),
        "pae_min_interface": conf.get("pae", []).min() if isinstance(conf.get("pae", []), list) else -1,
    })

# Sort by ipTM
results.sort(key=lambda x: x["ipTM"], reverse=True)

# Save metrics
metrics_path = "$OUTPUT_DIR/step2_3_metrics.json"
with open(metrics_path, "w") as f:
    json.dump(results, f, indent=2)

print(f"Saved metrics to {metrics_path}")
print("")
print("Top designs by ipTM:")
for r in results[:5]:
    print(f"  {r['design']:30s} ipTM={r['ipTM']:.4f} plddt={r['plddt']:.4f}")

PYTHON_METRICS

# ============================================================================
# FINAL SUMMARY
# ============================================================================
echo ""
echo "=========================================================="
echo "Step 2+3 Complete"
echo "=========================================================="
echo "Outputs:"
echo "  RFdiffusion designs:  $OUTPUT_DIR/designs_pdb/ (48 PDBs)"
echo "  Boltz-2 validation:   $OUTPUT_DIR/boltz_results/ (8 scored)"
echo "  Metrics:              $OUTPUT_DIR/step2_3_metrics.json"
echo ""
echo "Next: Review top designs, apply gate criteria, proceed to Step 4 if warranted"
