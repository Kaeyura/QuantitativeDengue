
set -e
PATCH="${PATCH:?}"
RFD_DIR="${RFD_DIR:?}"     # absolute path to existing backbones on /workspace
JOBDIR="$(pwd)"
TARGET="$JOBDIR/9W22_K272_monomer.pdb"
OUT="$JOBDIR/out"
mkdir -p "$OUT/mpnn" "$OUT/af2"
echo "=== RESUME PATCH $PATCH | backbones from $RFD_DIR ==="
ls -1 "$RFD_DIR"/*.pdb | wc -l

# ---------- STAGE 2: ProteinMPNN (design chain B, fix NS1 chain A) ----------
echo "### STAGE 2: ProteinMPNN $(date)"
source /workspace/mpnn_boot.sh
cd /workspace/ProteinMPNN
python helper_scripts/parse_multiple_chains.py \
  --input_path="$RFD_DIR" --output_path="$OUT/mpnn/parsed.jsonl"
python helper_scripts/assign_fixed_chains.py \
  --input_path="$OUT/mpnn/parsed.jsonl" --output_path="$OUT/mpnn/fixed.jsonl" \
  --chain_list "B"
export CUDA_VISIBLE_DEVICES=0
python protein_mpnn_run.py \
  --jsonl_path "$OUT/mpnn/parsed.jsonl" \
  --chain_id_jsonl "$OUT/mpnn/fixed.jsonl" \
  --out_folder "$OUT/mpnn" \
  --num_seq_per_target 2 \
  --sampling_temp "0.1" \
  --batch_size 1
echo "MPNN done"; ls -1 "$OUT/mpnn/seqs" | wc -l

# ---------- STAGE 3: build binder+NS1 FASTA, ColabFold ----------
echo "### STAGE 3: ColabFold $(date)"
NS1_SEQ=$(python3 -c "
aa={'ALA':'A','ARG':'R','ASN':'N','ASP':'D','CYS':'C','GLN':'Q','GLU':'E','GLY':'G','HIS':'H','ILE':'I','LEU':'L','LYS':'K','MET':'M','PHE':'F','PRO':'P','SER':'S','THR':'T','TRP':'W','TYR':'Y','VAL':'V'}
d={}
for l in open('$TARGET'):
    if l.startswith('ATOM') and l[12:16].strip()=='CA' and l[21]=='A':
        d[int(l[22:26])]=aa.get(l[17:20].strip(),'X')
print(''.join(d[k] for k in sorted(d)))
")
echo "NS1 length: ${#NS1_SEQ}"
FASTA="$OUT/af2/complexes.fasta"
python3 << PYEOF
import glob, os
ns1 = "$NS1_SEQ"
out = "$FASTA"
n = 0
with open(out, "w") as w:
    for fa in sorted(glob.glob("$OUT/mpnn/seqs/*.fa")) + sorted(glob.glob("$OUT/mpnn/seqs/*.fasta")):
        base = os.path.basename(fa).rsplit(".",1)[0]
        recs=[]; hdr=None; seq=[]
        for line in open(fa):
            line=line.rstrip()
            if line.startswith(">"):
                if hdr is not None: recs.append((hdr,"".join(seq)))
                hdr=line[1:]; seq=[]
            else: seq.append(line)
        if hdr is not None: recs.append((hdr,"".join(seq)))
        for i,(h,s) in enumerate(recs):
            if i==0: continue  # native binder seq
            binder = s.split("/")[-1]  # designed chain B only (no slash expected)
            n += 1
            w.write(f">{base}_d{i}\n{binder}:{ns1}\n")
print(f"wrote {n} complexes to {out}")
PYEOF
wc -l "$FASTA"; echo "first record:"; head -2 "$FASTA" | cut -c1-100
# sanity: binder length should be ~75, not 346
BLEN=$(sed -n '2p' "$FASTA" | cut -d: -f1 | tr -d '\n' | wc -c)
echo "binder length in first complex: $BLEN"

source /workspace/colabfold_boot.sh
export XDG_CACHE_HOME=/workspace/colabfold_cache
export CUDA_VISIBLE_DEVICES=0
colabfold_batch "$FASTA" "$OUT/af2" \
  --msa-mode single_sequence \
  --num-recycle 3 \
  --num-models 1
echo "### DONE $(date)"
