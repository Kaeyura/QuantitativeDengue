#!/bin/bash
# ============================================================================
# BindCraft — isolated deploy + NS1 β-ladder pilot  (RunPod A40, /workspace)
# Run ONLY when the pod is reachable. Each stage checked for exit 0 explicitly.
# ISOLATION: creates a dedicated conda env "BindCraft" (python 3.10) under
# /workspace/miniforge3/envs/ — it shares ZERO packages with rfd1/proteinmpnn/
# colabfold/dlbinder envs, so the prior numpy/cuDNN/biopython/haiku conflicts
# cannot recur. Nothing installs into an existing env.
# ============================================================================
set -euo pipefail
ROOT=/workspace/BindCraft
PILOT=/workspace/cs_scratch/bindcraft_ns1_pilot
source /workspace/miniforge3/etc/profile.d/conda.sh

# ---- Stage 0: clone (skip if present) -------------------------------------
if [ ! -d "$ROOT" ]; then
  cd /workspace
  git clone https://github.com/martinpacesa/BindCraft.git
fi
cd "$ROOT"

# ---- Stage 1: install (idempotent; official installer, cuda 12.4) ---------
if ! conda env list | grep -qw BindCraft; then
  bash install_bindcraft.sh --cuda '12.4' --pkg_manager 'conda'
fi

# ---- Stage 1b: HARD GUARD against the prior crash -------------------------
# prior /tmp run died: PermissionError on functions/dssp (exec bit missing)
chmod +x "$ROOT/functions/dssp" "$ROOT/functions/DAlphaBall.gcc"
conda activate BindCraft
python - <<'PY'
import os, stat, subprocess, sys
for f in ("functions/dssp","functions/DAlphaBall.gcc"):
    ok = os.access(f, os.X_OK); print(f, "executable:", ok)
    assert ok, f"{f} not executable — abort before pilot"
import colabdesign, jax; print("colabdesign OK; jax", jax.__version__, "devices:", jax.devices())
assert any(d.platform=="gpu" for d in jax.devices()), "JAX sees no GPU — abort"
print("PREFLIGHT PASS")
PY

# ---- Stage 2: stage inputs ------------------------------------------------
mkdir -p "$PILOT"
cp -n /workspace/cs_scratch/NS1_directionB_epitope_target.pdb "$PILOT"/ 2>/dev/null || true
cp "$ROOT"/../ns1_betaladder_target.json "$PILOT"/ 2>/dev/null || true

# ---- Stage 3: PILOT run (β-sheet protocol; NEGATIVE helicity = -2.0) -------
# advanced = betasheet_4stage_multimer.json  (weights_helicity: -2.0 -> biases
#            binder toward β-sheet fold, appropriate for a β-ladder surface)
# filters  = no_filters.json  -> we accept EVERY completed design and apply the
#            project's OWN locked thresholds downstream (NOT BindCraft defaults)
cd "$ROOT"
python -u ./bindcraft.py \
  --settings  "$PILOT/ns1_betaladder_target.json" \
  --filters   "./settings_filters/no_filters.json" \
  --advanced  "./settings_advanced/betasheet_4stage_multimer.json" \
  2>&1 | tee "$PILOT/bindcraft_pilot.log"

echo "PILOT_EXIT=${PIPESTATUS[0]}"
ls -la "$PILOT"/*.csv 2>/dev/null || echo "no csv outputs"
