# ns1_benchmark — de novo binder design against dengue NS1

A reproducible benchmark from a computational campaign to design de novo binders against
dengue virus NS1 and specify a two-arm bioluminescent sandwich sensor. It ships the ranked
designs, the data behind every claim, the scoring harness, and — importantly — the
**negative results**, which are the most transferable part of the work.

**Team:** Kaeyura Puram and Rabaani Mehra (Non-Trivial Fellowship).
**Scope boundary:** entirely computational. No wet-lab synthesis, assays, affinity
measurement, device fabrication, or clinical work. Nothing here is experimentally validated.

---

## What this benchmark is for

Two audiences:

1. **Binder-design practitioners** — a worked, fully-measured example of an epitope-focused
   de novo campaign against a flat β-sheet epitope on an oligomeric antigen, including the
   three ways it went wrong and how each was caught.
2. **Method developers** — four falsifiable methods results that generalise beyond dengue
   (below). Each has a control, and each is reproducible from the data in `data/`.

## The four transferable methods results

| # | Result | Evidence | Where |
|---|---|---|---|
| 1 | **Gate inversion.** A co-folding predictor's interface confidence is *anti-correlated* with binding the intended epitope on this target. | ρ = −0.888, p = 9.7×10⁻⁶, n = 15. A protective antibody with a crystal structure (2B7) fails the locked gate 5/5 while on-epitope 5/5; a non-cognate decoy passes 3/5 while entirely off-epitope. | `data/gate_calibration_multiseed.csv`, `figures/fig10_multiseed_calibration.png` |
| 2 | **Cropped-target artefact.** Designs generated against an isolated epitope fragment score well on every metric and are sterically impossible on the intact target. | 32 designs, **0/32** feasible on full-length NS1 (47–874 atom pairs < 2.0 Å). No confidence metric flags it — only an explicit clash test. ~2 in 10 *sequences* nonetheless recover on-epitope when re-predicted against the full target. | `data/shortlist_refeasibility.csv`, `data/rescue_results.csv`, `figures/fig14_rescue_campaign.png` |
| 3 | **Predictor mislocation.** The predictor places a published antibody on the wrong epitope, reproducibly, with unremarkable confidence. | Antibody 3G2 recovers **0 of 16** residues of its own cryo-EM epitope (8JKF) in **10/10** runs, landing on the β-ladder instead; pLDDT stays 0.88–0.91. Two alternative explanations tested and ruled out by measurement. | `data/ternary_results.csv`, `figures/fig12` (project artifacts) |
| 4 | **A safety criterion refuted by geometry.** The design epitope and the host-mimicry avoid-window are interdigitated strands of one β-sheet, so they cannot be decoupled. | 15 independent on-epitope poses: 6/15 meet epitope burial ≥ 300 Å², **0/15** meet tip burial ≤ 40 Å², **0/15** both; min tip burial 91 Å² (2.3× the limit); r = 0.706, p = 0.0033. The protective antibody 2B7 fails it too (320/250 Å²). | `data/direction_b_burial.csv`, `figures/fig15_directionB_rederivation.png` |

Result 1 is why this benchmark **does not rank on ipTM/pAE**. See `harness/`.

---

## Repository layout

```
ns1_benchmark/
├── README.md                     this file
├── ranked_binders.csv            THE ranked table: design -> sequence -> structure -> scores
├── data/                         every table behind a claim
│   ├── binders.fasta                 10 designed sequences (118 aa each)
│   ├── ns1_aln.fasta                 DENV1-4 whole-NS1 alignment (use for ANY site)
│   ├── rescue_results.csv            50 predictions (10 designs x 5 seeds), full-length NS1
│   ├── rescue_summary.csv            per-design aggregate + per-seed hotspot frequency
│   ├── gate_calibration_multiseed.csv   15 predictions: design / crystal ref / negative control
│   ├── shortlist_refeasibility.csv   clash test, 42 designs
│   ├── charge_variant_results.csv    20 predictions, paratope charge hypothesis
│   ├── ternary_results.csv           10 predictions, 3G2 arm control + ternary
│   ├── direction_b_burial.csv        epitope vs tip burial, 15 poses + 2B7 reference
│   ├── second_arm_conservation.csv   19-residue second-arm site, DENV1-4 + ZIKV
│   ├── switch_geometry_measurements.csv  25 arm-pair combinations
│   ├── denv1-4_betaladder_conservation.csv   (261-305 ONLY — see trap below)
│   └── denv_zika_specificity.csv             (261-305 ONLY — see trap below)
├── structures/
│   ├── target_9W22_chainA.pdb    DENV2 NS1 monomer, residues 1-346 (the design target)
│   ├── nb3_ns1_AB.pdb            prior-reference binder in complex (chain A binder, chain B NS1)
│   ├── pred_2b7.pdb              2B7 crystallographic reference, same predictor
│   └── pred_dimer_s5.pdb         best single pose on record (dimer seed 5)
├── harness/
│   └── score_epitope_fidelity.py the scoring criterion this benchmark ranks on
└── figures/                      the five figures needed to read the results
```

---

## The ranked binder table

`ranked_binders.csv` ties **design ID → sequence → structure → scores** in one place.
Ranking is by **on-epitope rate then mean epitope contacts** — deliberately *not* by ipTM
(result 1). Columns: `rank, design_id, class, target_site, on_epitope_rate,
mean_epitope_contacts, per_seed_hotspot_freq, hotspots_in_3plus_seeds, consensus_size,
consensus_contacts, conserved_of_contacted, max_2B7_overlap_of_20, sequence_source,
structure, sequence, note`.

The three rows that matter:

| rank | design | site | on-epitope | consensus | what it is |
|---|---|---|---|---|---|
| 1 | `onepi_pd_5_dldesign_1` | β-ladder 261–305 | **5/5** | 3 residues | most reliable region targeting; **pose does not converge** |
| 3 | `nb_3` | β-ladder 261–305 | 3/5 | **7 residues** | prior reference; consensus is a strict 7/7 subset of 2B7's crystal epitope |
| 11 | `seed5_pd_15_dldesign_1` | wing/domain-I | 0/5 *at the β-ladder* | **19 residues** | **second-arm lead** — binds its own site identically in 5/5 seeds, 84% DENV1–4-conserved |

Rank 11 is not a failure — it is ranked last on the β-ladder criterion because it binds a
*different* site, reproducibly. It is the best second-arm candidate the project produced.

## Reading the scores honestly

- **"On-epitope 5/5" does not mean the pose converged.** It means every seed put ≥ 4
  contacts in 261–305. The best design's all-seed consensus is 3 residues (mean pairwise
  Jaccard 0.33). The honest description is *reliable region targeting, unreliable pose*.
- **No design engages any hotspot reproducibly.** Best: 269 in 3/5 seeds. Hotspot 272 (the
  DENV/ZIKV-discriminating position) appears in at most 1/5 for any design. **Hotspots are
  reported as per-seed frequencies, never as a union across seeds** — the union overstates it.
- **No binder here is "validated."** The defensible phrasing is *characterised against a
  crystallographic reference on the same predictor*. There is no experimental validation.
- Every pose is predicted by a tool that mislocated two published antibodies on this target
  (results 1 and 3). Every number inherits that uncertainty.

---

## Scoring harness

`harness/score_epitope_fidelity.py` implements the criterion that replaced the locked gate.

```bash
# one prediction
python harness/score_epitope_fidelity.py structures/nb3_ns1_AB.pdb \
       --binder-chain A --ns1-chain B

# all seeds of one design -> aggregate on-epitope rate + per-seed hotspot frequency
python harness/score_epitope_fidelity.py "preds/design_x_seed*.pdb" \
       --binder-chain B --ns1-chain A --json
```

Reproduces the documented best pose on record:
`epitope_contacts=9  on_epitope=True  hotspots=[269, 296]  fidelity_pass=True`

**The criterion (methods.md §7.2):**

> **Primary — epitope fidelity:** ≥ 4 heavy-atom contacts within 261–305 **AND** ≥ 2 of the
> five nominated hotspots (269/272/274/294/296) with **≥ 1 from cluster A {269,272,274}**,
> assessed per seed and reported as a rate over five seeds.
> **Secondary — relative confidence:** ipTM and interface pAE reported *relative to the 2B7
> reference on the same predictor* (2B7 ≈ 0.455 / 6.48 Å), never against absolute cutoffs.
> **Fold guard:** pLDDT > 0.8.

**Disclosed caveat:** the epitope-fidelity criterion was defined *after* seeing the
calibration data. It describes the observed binders rather than independently testing them;
a held-out validation would require new designs scored blind.

Only `numpy` is required. Contacts are heavy-atom pairs within 4.5 Å throughout.

---

## Traps that already caused errors here — do not repeat

1. **Three different burial numbers.** *Target-side* (NS1 area occluded), *binder-side*, and
   *BSA per side* (two-sided mean) are distinct. Mixing them once made an epitope subtotal
   appear to exceed a total. Epitope burial must additionally be **filtered to 261–305**.
   Every burial figure in `data/` is **target-side and BL-filtered** — state the convention
   whenever you quote one.
2. **Conservation lookups outside 261–305.** `denv1-4_betaladder_conservation.csv` and
   `denv_zika_specificity.csv` span **only 261–305**; querying them for a residue outside
   that window silently returns "not conserved". This produced a false 0/19 for the
   second-arm site, whose correct value is **16/19**. Use `ns1_aln.fasta` for any site
   outside the β-ladder.
3. **Cropped targets cannot be scored against criteria referencing absent residues.** The
   prior reference's seed-5 complex has a target cropped to 255–310, so its tip (311–352)
   burial is 0 for trivial reasons — it is **untestable** against the tip criterion, not
   passing it.
4. **A tied rank correlation is not a reproduction.** The ρ = −0.527 in the re-ranking
   analysis has 14 of 16 designs tied at zero epitope contacts, so it rests on two rows.
   Do not cite it as independent confirmation of the ρ = −0.888 calibration result; the
   defensible claim from that table is the *ordering*.
5. **ZIKV residues are strain-dependent.** 2 of 45 β-ladder positions disagree between the
   stored table and the NCBI isolate used (AMC13911.1). Neither is in the second-arm site.

## Reproducing the predictions

All structural validation used **Boltz-2 2.2.1** with an identical harness for every run
including controls: `recycling_steps 3`, `diffusion_samples 1`, `--use_msa_server`,
`--no_kernels`, seeds 1–5, on one NVIDIA A40. Design used RFdiffusion (backbones) →
ProteinMPNN (sequences), in separate version-pinned conda environments. ipTM is not
comparable across different recycling/diffusion settings. Full detail in `methods.md`.

Design/validation prediction uses the **NS1 monomer**; the dimer is used only for
epitope-accessibility questions (predicting binders against the dimer makes epitope fidelity
*worse*, 1/5 vs 3/5, by opening cross-protomer poses that are stoichiometry artefacts).

## What is deliberately not here

- Any wet-lab result, affinity, expression, or luminescence measurement.
- A predicted structure of the assembled switch. Two published antibodies fail this predictor
  on this target in different ways, so the switch deliverable is a **geometric specification**
  (`switch_construction_plan.md`), not a model.
- Any claim of pan-serotype coverage inferred from sequence alone — coverage is verified
  against the DENV1–4 alignment in every case.
- Resolution of the host-mimicry risk. It cannot be resolved computationally; it requires
  binding assays against candidate human targets and is carried as an open risk.

## Companion documents

`methods.md` (unified pipeline methods), `report.md` (the assembled report),
`binder_status.md`, `next_steps.md`, `switch_construction_plan.md` (specification),
`corrections_ledger.csv` (15 superseded claims with evidence and replacements), and the
per-finding documents cited throughout.
