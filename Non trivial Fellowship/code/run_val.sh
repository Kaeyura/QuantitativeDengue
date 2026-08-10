#!/bin/bash
# Boltz-2 validation of charge-variant paratopes vs NS1 MONOMER, seeds 1-5.
# Harness identical to the gate-calibration and dimer runs: recycling 3, 1 sample,
# --no_kernels --use_msa_server --override. Monomer per plan v2 (dimer opens
# cross-protomer decoys that are stoichiometry artefacts).
set -euo pipefail
source /workspace/boltz_venv/bin/activate
export BOLTZ_CACHE=/workspace/boltz_cache
cd "$(dirname "$0")"
for v in v_q1 v_q2 v_q3 v_q5; do
  for s in 1 2 3 4 5; do
    o=out_${v}_s${s}
    if [ -f "$o/boltz_results_${v}/predictions/${v}/confidence_${v}_model_0.json" ]; then
      echo "skip $v s$s"; continue
    fi
    echo "=== $v seed $s start $(date +%T) ==="
    boltz predict ${v}.yaml --out_dir $o --seed $s \
      --recycling_steps 3 --diffusion_samples 1 \
      --no_kernels --use_msa_server --override --write_full_pae || echo "FAIL $v s$s"
    echo "=== $v seed $s exit $? $(date +%T) ==="
  done
done
echo "=== ALL DONE ==="
