#!/bin/bash
# TERNARY SANDWICH VALIDATION - the plan's named minimum-viable deliverable.
# Q1: do nb_3 and 3G2 co-bind NS1 simultaneously, each on its own epitope?
# Q2: does 3G2 alone recover its 8JKF cryoEM epitope under this harness? (arm control)
# This is a TERNARY-COMPLEX prediction (trustworthy per project epistemics), NOT a
# switch-state prediction. lucCage/LOCKR caging was rejected in plan v3 section 1a(C).
set -euo pipefail
source /workspace/boltz_venv/bin/activate
export BOLTZ_CACHE=/workspace/boltz_cache
export CUDA_VISIBLE_DEVICES=1   # pinned: shortlist rescue occupies GPU 0
cd "$(dirname "$0")"
for v in tern_full ctrl_3g2; do
  for s in 1 2 3 4 5; do
    o=out_${v}_s${s}
    if [ -f "$o/boltz_results_${v}/predictions/${v}/confidence_${v}_model_0.json" ]; then
      echo "skip $v s$s"; continue; fi
    echo "=== $v seed $s start $(date +%T) ==="
    boltz predict ${v}.yaml --out_dir $o --seed $s \
      --recycling_steps 3 --diffusion_samples 1 \
      --no_kernels --use_msa_server --override --write_full_pae || echo "FAIL $v s$s"
  done
done
echo "=== ALL DONE ==="
