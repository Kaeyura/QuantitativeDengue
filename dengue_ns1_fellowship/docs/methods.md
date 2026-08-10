# Methods

De novo design and computational characterisation of nanobody-format binders against
dengue virus NS1, and the geometric specification of a two-arm bioluminescent switch.
This single document replaces the per-finding methods paragraphs; every downstream
finding uses the conventions defined here unless it states otherwise.

Target throughout: DENV2 NS1, PDB **9W22 chain A**, residues 1–346 (the ordered
head-to-tip monomer). The design epitope is the β-ladder patch **261–305** (Direction B);
the host-mimicry avoid-window is the tip **311–352**. Nominated hotspots are
**269, 272, 274** (cluster A) and **294, 296** (cluster B).

---

## 1. Pipeline and software environments

The pipeline is three stages, each in its own version-pinned conda environment on a
single NVIDIA A40 (CUDA 12.4) pod. The environments are kept separate because their
dependency stacks conflict; the right one is activated per stage.

| Stage | Tool | Environment | Role |
|---|---|---|---|
| Backbone generation | RFdiffusion | `rfd1_boot.sh` → `RFdiffusion/scripts/run_inference.py` | binder backbones against the epitope hotspot set |
| Sequence design | ProteinMPNN | `mpnn_boot.sh` (`envs/proteinmpnn`, `ProteinMPNN` repo) | sequences for each backbone |
| Validation (co-folding) | **Boltz-2 2.2.1** | run on the pod (A40) | binder–NS1 complex prediction and scoring |

ColabFold / AF2-multimer is installed (`colabfold_boot.sh`) but was **not** used as the
production validator; it is reserved for the recommended published-antibody control
experiment (see the report's Future Work). All structural validation and every metric in
this project comes from **Boltz-2 2.2.1**.

**Boltz-2 harness (identical for every run, controls included):** `recycling_steps 3`,
`diffusion_samples 1`, `--use_msa_server`, `--no_kernels`, seeds 1–5. Reproducing a metric
requires this exact harness; ipTM in particular is not comparable across different
diffusion-sample or recycling settings.

CPU-only steps — sequence alignment, PDB parsing, contact/burial computation, clash
testing, geometry — were run outside the GPU environments and depend on no pinned tool
version.

---

## 2. Contact definition (used everywhere)

A residue–residue contact is a **heavy-atom pair within 4.5 Å**. Every binding site,
epitope-contact count, hotspot engagement, inter-binder clash, and dimer-interface
assignment in this project is computed at this cutoff from coordinates — **never assumed
from the design intent**. "Binding site MEASURED" columns in the data tables are the
per-prediction contact sets computed this way.

A separate, stricter cutoff is used only for the **steric-clash / feasibility test**
(§6): heavy-atom pairs closer than **2.0 Å** are counted as severe clashes.

---

## 3. Five-seed protocol

Every construct is co-folded under five independent seeds (1–5) with the harness in §1.
For each of the five predictions the binding site is computed from coordinates at 4.5 Å,
and the construct is scored **per seed**. Reported per-construct quantities are therefore
distributions over seeds, not single values:

- **on-epitope rate** — the number of seeds (out of 5) placing ≥ 4 contacts in 261–305;
- **per-seed hotspot frequency** — e.g. "269 in 3/5, 272 in 1/5". Hotspot engagement is
  **always reported as a per-seed frequency, never as a union across seeds** — the union
  overstates reproducibility and was corrected out of an earlier analysis;
- **consensus footprint** — the set of contacts shared across a construct's on-epitope
  seeds (a measure of pose convergence, distinct from on-epitope rate).

Design/validation prediction uses the **NS1 monomer**. The dimer is used only for
epitope-accessibility questions; predicting binders against the dimer degrades epitope
fidelity (a single binder against two protomers opens cross-protomer decoy poses that are
artefacts of the 1:1 stoichiometry) and is not the production reference (see
`dimer_revalidation.md`).

---

## 4. Burial convention (three distinct numbers — state which)

Buried surface area is reported three different ways and they must not be mixed; conflating
them once made an epitope subtotal appear to exceed a total.

1. **Target-side burial** — NS1 surface area occluded by the binder, summed over NS1
   residues. This is the convention for every epitope-coverage question and **every burial
   figure in the project artifacts is target-side.**
2. **Binder-side burial** — the reciprocal area on the binder.
3. **BSA per side** — the two-sided mean of (1) and (2).

**Epitope burial is additionally filtered to residues 261–305** ("BL-filtered"). The
unfiltered sum over a wider crop is a different, larger number. Worked example on nb_3's
seed-5 pose: BL-filtered (261–305) target-side burial **356 Å²**; unfiltered target-side
over the whole cropped 255–310 fragment **375 Å²** (the extra 19 Å² falls on 255–260 and
306–310, outside the epitope); unfiltered binder-side **333 Å²**; the "BSA per side"
two-sided mean is taken over the unfiltered surfaces, **(375 + 333)/2 = 354 Å²** — note it
is *not* the mean of the BL-filtered 356 and 333, which is a fourth, different number
(344.5 Å²). This is exactly why the convention (target-side, BL-filtered) must be stated
wherever a burial figure is quoted.

Constructs whose target chain is cropped **cannot** be scored against a criterion that
references residues outside the crop. nb_3's seed-5 complex has a target cropped to
255–310, so its tip (311–352) burial is 0 for trivial reasons — it is recorded as
**untestable against the tip criterion, not as passing it.**

---

## 5. Conservation and specificity lookups

DENV1–4 conservation and DENV/ZIKV specificity are computed at 4.5 Å-defined interface
positions against alignments, with the alignment numbering validated before use.

- **Whole-NS1 questions** (any residue, including sites outside 261–305) use
  `ns1_aln.fasta`, a 4-serotype DENV1–4 NS1 alignment (352 ungapped columns). Numbering
  was validated against 9W22 chain A (best offset 0; 335/346 = 96.8% identity), and all
  45/45 positions in 261–305 reproduce the trusted β-ladder table exactly.
- **The two narrow tables** `denv1-4_betaladder_conservation.csv` and
  `denv_zika_specificity.csv` span **only 261–305**. Querying them for a residue outside
  that window silently returns "not conserved" — this produced a spurious 0/19 for the
  wing/domain-I second-arm site, whose correct value from the whole-NS1 alignment is 16/19.
  **Any site outside 261–305 must be scored against `ns1_aln.fasta`, not these tables.**
- ZIKV residues are strain-dependent: 2 of 45 β-ladder positions (264, 286) disagree
  between the stored specificity table and the NCBI isolate used (AMC13911.1). ZIKV
  absolute-residue claims inherit this isolate dependence.

---

## 6. Steric-feasibility (clash) test — a mandatory filter

Designs generated against an isolated, cropped epitope fragment can score well on every
confidence metric yet be **sterically impossible on the intact target**. Each cropped-target
complex is superposed back onto full-length NS1 via its own target fragment (Cα RMSD
0.95–1.00 Å, so the placement is well determined) and the binder is tested against the rest
of NS1 for heavy-atom pairs < 2.0 Å. **No confidence metric in the pipeline flags this
failure** — not ipTM, pAE, pLDDT, or hotspot count; only the explicit clash test detects it.
Any epitope-focused protocol that crops its target for tractability must run this test as a
mandatory filter (see `reranking_finding.md`).

---

## 7. Acceptance criteria

### 7.1 The original locked gate — and why it was abandoned

The project locked, before generation, an absolute acceptance gate adopted from globular
protein–protein binder design:

> **pLDDT > 0.8 AND ipTM > 0.7 AND interface pAE < 5 Å.**

A five-seed benchmark against a crystallographic reference **inverted** this gate on this
target. Three constructs were run under the identical harness (§1): nb_3 (design), **2B7**
(a protective human antibody with a deposited DENV2 NS1 crystal structure, PDB 6WER), and
**cAb-Lys3** (an anti-lysozyme VHH, non-cognate negative control). Binding sites were
measured per seed (n = 15).

- **ipTM is anti-correlated with binding the intended epitope:** Spearman ρ(ipTM,
  β-ladder contact count) = **−0.888, p = 9.7 × 10⁻⁶, n = 15.**
- **Every one of the 4 gate-passing predictions has zero epitope contact; the 11
  gate-failing predictions average 6.3 β-ladder contacts.**
- The protective antibody 2B7 is on-epitope 5/5 (recovering 18–19 of its 20
  crystallographic contacts every seed) yet **fails the gate on all five seeds**
  (ipTM ≈ 0.46). The non-cognate decoy cAb-Lys3 binds entirely off-epitope yet
  **passes the gate 3/5** (ipTM ≈ 0.80).

Ranking on the locked gate would therefore systematically discard correct poses and
promote decoys. The `ipTM > 0.7` and `interface pAE < 5 Å` thresholds are reported as
**invalid absolute cutoffs for this target** (see `gate_calibration_finding.md`). pLDDT > 0.8
is retained only as a fold-sanity guard — all three constructs clear it, so it is not
discriminating either.

### 7.2 The replacement — epitope fidelity

The criterion that actually separates the negative control from both real binders is
**where** the binder lands, not its confidence score:

> **Primary (epitope fidelity):** ≥ 4 heavy-atom contacts within 261–305 **AND** ≥ 2 of the
> five nominated hotspots (269/272/274/294/296) with **≥ 1 from cluster A {269, 272, 274}**,
> assessed per seed and reported as a rate over the five seeds.
>
> **Secondary (relative confidence):** ipTM and interface pAE reported **relative to the
> 2B7 reference on the same predictor** (2B7 ≈ 0.455 / 6.48 Å), never against absolute
> cutoffs.
>
> **Fold guard:** pLDDT > 0.8.

**Methodological caveat, disclosed:** the epitope-fidelity criterion was defined *after*
seeing the calibration data. It describes the observed binders rather than independently
testing them; a held-out validation would require new designs scored blind. This is stated
wherever the criterion is applied.

Two earlier acceptance numbers are **retracted** and must not be used: a "≥ 600 Å² buried
surface floor" (would have selected for designs burying the forbidden tip) and a
"≥ 3 of 5 hotspots" requirement (geometrically unsatisfiable by one paratope). See the
corrections ledger.
