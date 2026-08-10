#!/bin/bash
# SHORTLIST RESCUE: re-predict 10 cropped-target designs against FULL-LENGTH NS1.
# Rationale: these designs were generated against an isolated 56-residue beta-ladder
# fragment. Superposing their cropped poses onto intact NS1 gives 47-874 clashing atom
# pairs (0/32 feasible). But co-folding lets each SEQUENCE find its own pose on the real
# target - the same test nb_3 passed (3/5 on-epitope). Question: does any of them hold a
# feasible on-epitope pose without the cropping artefact?
# Harness identical to gate-calibration / dimer / variant runs.
set -euo pipefail
source /workspace/boltz_venv/bin/activate
export BOLTZ_CACHE=/workspace/boltz_cache
cd "$(dirname "$0")"
for v in onepi_pd_15_dldesign_0 onepi_pd_16_dldesign_0 onepi_pd_20_dldesign_1 onepi_pd_30_dldesign_1 onepi_pd_5_dldesign_0 onepi_pd_5_dldesign_1 onepi_pd_7_dldesign_1 seed5_pd_11_dldesign_0 seed5_pd_15_dldesign_1 seed5_pd_18_dldesign_1; do
  for s in 1 2 3 4 5; do
    o=out_${v}_s${s}
    if [ -f "$o/boltz_results_${v}/predictions/${v}/confidence_${v}_model_0.json" ]; then
      echo "skip $v s$s"; continue
    fi
    echo "=== $v seed $s start $(date +%T) ==="
    boltz predict ${v}.yaml --out_dir $o --seed $s \
      --recycling_steps 3 --diffusion_samples 1 \
      --no_kernels --use_msa_server --override --write_full_pae || echo "FAIL $v s$s"
  done
done
echo "=== ALL DONE ==="
