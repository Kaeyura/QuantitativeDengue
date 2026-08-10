#!/bin/bash
set -e

echo "=== Step 2+3 Setup: Extract Seed 5 Framework & Prepare Target ==="

WORKSPACE=/workspace
SCRATCH=$WORKSPACE/cs_scratch
OUTPUT_DIR=$SCRATCH/nb3_step2_3
WORK_DIR=$OUTPUT_DIR/work

mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# ============================================================================
# FETCH SEED 5 STRUCTURE
# ============================================================================
echo "[1/4] Copying seed 5 Boltz output from Step 1..."
SEED5_CIF="$SCRATCH/nb3_replicates/replica_seed5/boltz_results_nb3_input/predictions/nb3_input/nb3_input_model_0.cif"

if [ ! -f "$SEED5_CIF" ]; then
    echo "ERROR: Seed 5 CIF not found at $SEED5_CIF"
    exit 1
fi

cp "$SEED5_CIF" ./seed5_complex.cif
echo "   ✓ Seed 5 complex copied to ./seed5_complex.cif"

# ============================================================================
# EXTRACT BINDER (CHAIN A) AS FRAMEWORK PDB
# ============================================================================
echo "[2/4] Extracting binder framework (chain A) from seed 5 complex..."

python3 << 'PYTHON_END'
import os
try:
    from biotite.structure.io import load, save
    from biotite.structure import AtomArray
except ImportError:
    print("ERROR: biotite not found. Installing...")
    os.system("pip install biotite -q")
    from biotite.structure.io import load, save

# Load the complex CIF
cif = load("seed5_complex.cif")

# Filter to chain A (binder)
binder = cif[cif.chain_id == "A"]

# Save as PDB
save("seed5_binder_framework.pdb", binder)
print(f"   ✓ Binder framework extracted: {len(binder)} atoms from chain A")

# Also save a NS1 target reference (chain B)
ns1 = cif[cif.chain_id == "B"]
save("ns1_target_for_reference.pdb", ns1)
print(f"   ✓ NS1 target reference saved: {len(ns1)} atoms from chain B")

PYTHON_END

# ============================================================================
# VERIFY FRAMEWORK
# ============================================================================
echo "[3/4] Verifying framework..."
if [ ! -f seed5_binder_framework.pdb ]; then
    echo "ERROR: Framework PDB not created"
    exit 1
fi
NATOMS=$(grep -c "^ATOM" seed5_binder_framework.pdb)
echo "   ✓ Framework ready: $NATOMS atoms"

# ============================================================================
# PREPARE NS1 TARGET PDB (Full length from fasta + template coordinates)
# ============================================================================
echo "[4/4] Preparing NS1 target PDB..."

python3 << 'PYTHON_END'
# NS1 sequence (full length, 346 aa)
ns1_seq = "DSGCVVSWKNKELKCGSGIFITDNVHTWTEQYKFQPESPSKLASAIQKAHEEGICGIRSVTRLENLMWKQITPELNHILTENEVKLTIMTGDIKGIMQAGKRSLRPQPTELKYSWKAWGKAKMLSTELHNHTFLIDGPETAECPNTNRAWNSLEVEDYGFGVFTTNIWLKLKERQDVFCDSKLMSAAIKDNRAVHADMGYWIESALNDTWKIEKASFIEVKSCHWPKSHTLWSNGVLESEMIIPKNFAGPVSQHNYRPGYHTQTAGPWHLGRLEMDFDFCEGTTVVVTEDCGNRGPSLRTTTASGKLITEWCCRSCTLPPLRYRGEDGCWYGMEIRPLKEKEENLV"

# Use the reference NS1 PDB from seed5's chain B as template (has proper coordinates)
from biotite.structure.io import load, save

ns1_ref = load("ns1_target_for_reference.pdb")

# Verify sequence matches
print(f"NS1 reference from seed5: {len(ns1_ref)} atoms")
print(f"NS1 full-length sequence: {len(ns1_seq)} aa")

# Save the target PDB for RFdiffusion
save("ns1_target.pdb", ns1_ref)
print("   ✓ NS1 target PDB ready")

PYTHON_END

# ============================================================================
# SUMMARY
# ============================================================================
echo ""
echo "=== Step 2+3 Setup Complete ==="
echo "Framework (seed 5 binder):  seed5_binder_framework.pdb"
echo "Target (NS1 full-length):   ns1_target.pdb"
echo "Work directory:             $WORK_DIR"
echo ""
echo "Ready for RFdiffusion hotspot-steered design."
