#!/bin/bash
# nb_3 paratope charge redesign — fixed-backbone ProteinMPNN
# Designs ONLY the 6 contact-free, solvent-exposed, target-proximal CDR positions.
# All 10 target-contacting CDR residues are held fixed, so the on-epitope pose is
# preserved by construction. Backbone is the dimer seed-5 pose (best on record).
set -euo pipefail
source /workspace/mpnn_boot.sh
MP=/workspace/ProteinMPNN
cd "$(dirname "$0")"
mkdir -p pdbs out && cp nb3_ns1_AB.pdb pdbs/

python $MP/helper_scripts/parse_multiple_chains.py \
  --input_path=pdbs --output_path=parsed.jsonl
python $MP/helper_scripts/assign_fixed_chains.py \
  --input_path=parsed.jsonl --output_path=assigned.jsonl --chain_list "A"
python $MP/helper_scripts/make_fixed_positions_dict.py \
  --input_path=parsed.jsonl --output_path=fixed.jsonl \
  --chain_list "A" --position_list "30 31 53 55 103 105" --specify_non_fixed

python $MP/protein_mpnn_run.py \
  --jsonl_path parsed.jsonl \
  --chain_id_jsonl assigned.jsonl \
  --fixed_positions_jsonl fixed.jsonl \
  --out_folder out \
  --num_seq_per_target 96 \
  --sampling_temp "0.25" \
  --omit_AAs "CX" \
  --batch_size 8 \
  --seed 37
echo "=== done ==="; ls -R out | tail -20
