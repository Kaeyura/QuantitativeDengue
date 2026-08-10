
set -e
PATCH="${PATCH:?}"
HOTSPOT="${HOTSPOT:?}"
JOBDIR="$(pwd)"
TARGET="$JOBDIR/9W22_K272_monomer.pdb"
OUT="$JOBDIR/out"
mkdir -p "$OUT/rfd" "$OUT/mpnn" "$OUT/af2"
echo "=== PATCH $PATCH | hotspot $HOTSPOT | target $TARGET ==="
ls -l "$TARGET"

# ---------- STAGE 1: RFdiffusion (100 backbones) ----------
echo "### STAGE 1: RFdiffusion $(date)"
source /workspace/rfd1_boot.sh
cd /workspace/RFdiffusion
python scripts/run_inference.py \
  inference.output_prefix="$OUT/rfd/${PATCH}" \
  inference.input_pdb="$TARGET" \
  'contigmap.contigs=[A1-346/0 75-75]' \
  "ppi.hotspot_res=[$HOTSPOT]" \
  inference.num_designs=100 \
  denoiser.noise_scale_ca=0 denoiser.noise_scale_frame=0
NB=$(ls -1 "$OUT/rfd/"*.pdb 2>/dev/null | wc -l)
echo "RFd backbones: $NB"

# ---------- STAGE 2: ProteinMPNN (2 seq/backbone, chain A fixed) ----------
echo "### STAGE 2: ProteinMPNN $(date)"
source /workspace/mpnn_boot.sh
cd /workspace/ProteinMPNN
python helper_scripts/parse_multiple_chains.py \
  --input_path="$OUT/rfd" --output_path="$OUT/mpnn/parsed.jsonl"
# NOTE: assign_fixed_chains --chain_list = chains to DESIGN. We design the
# binder (chain B) and hold the NS1 target (chain A) fixed.
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
echo "MPNN done; seqs dir:"
ls -l "$OUT/mpnn/seqs" | head

# ---------- STAGE 3: build binder+NS1 multimer FASTA, ColabFold ----------
echo "### STAGE 3: ColabFold $(date)"
# NS1 sequence = chain A of target
NS1_SEQ=$(python3 -c "
aa={'ALA':'A','ARG':'R','ASN':'N','ASP':'D','CYS':'C','GLN':'Q','GLU':'E','GLY':'G','HIS':'H','ILE':'I','LEU':'L','LYS':'K','MET':'M','PHE':'F','PRO':'P','SER':'S','THR':'T','TRP':'W','TYR':'Y','VAL':'V'}
d={}
for l in open('$TARGET'):
    if l.startswith('ATOM') and l[12:16].strip()=='CA' and l[21]=='A':
        d[int(l[22:26])]=aa.get(l[17:20].strip(),'X')
print(''.join(d[k] for k in sorted(d)))
")
echo "NS1 length: ${#NS1_SEQ}"

# ProteinMPNN writes one FASTA per backbone in $OUT/mpnn/seqs/, each with
# the original (seq 0) + designed sequences. Extract designed binder seqs.
FASTA="$OUT/af2/complexes.fasta"
> "$FASTA"
python3 << PYEOF
import glob, os
ns1 = "$NS1_SEQ"
out = "$FASTA"
n = 0
with open(out, "w") as w:
    for fa in sorted(glob.glob("$OUT/mpnn/seqs/*.fa")) + sorted(glob.glob("$OUT/mpnn/seqs/*.fasta")):
        base = os.path.basename(fa).rsplit(".",1)[0]
        # parse fasta records
        recs=[]; hdr=None; seq=[]
        for line in open(fa):
            line=line.rstrip()
            if line.startswith(">"):
                if hdr is not None: recs.append((hdr,"".join(seq)))
                hdr=line[1:]; seq=[]
            else:
                seq.append(line)
        if hdr is not None: recs.append((hdr,"".join(seq)))
        # record 0 is the native/input seq; designed seqs are the rest.
        # each seq may contain the target too (chain-concatenated by '/'); binder is the designed chain.
        for i,(h,s) in enumerate(recs):
            if i==0:
                continue  # skip the native backbone sequence
            # split on chain break '/'; binder is chain B (the diffused one, 75 aa)
            parts = s.split("/")
            binder = parts[-1] if len(parts)>1 else s
            n += 1
            w.write(f">{base}_d{i}\n{binder}:{ns1}\n")
print(f"wrote {n} complexes to {out}")
PYEOF

wc -l "$FASTA"
source /workspace/colabfold_boot.sh
export XDG_CACHE_HOME=/workspace/colabfold_cache
export CUDA_VISIBLE_DEVICES=0
colabfold_batch "$FASTA" "$OUT/af2" \
  --msa-mode single_sequence \
  --num-recycle 3 \
  --num-models 1
echo "### DONE $(date)"
ls -l "$OUT/af2" | head
