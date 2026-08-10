# Designing a Quantitative Dengue NS1 Test

*Kaeyura Puram and Rabaani Mehra — Non-Trivial Fellowship*

## What this project is

Dengue rapid tests answer one question: is NS1 antigen present. They cannot
say how much, so they cannot tell a clinician whether a patient is improving
or deteriorating. This project set out to design a de novo protein switch —
two engineered binders gripping non-overlapping sites on dengue NS1, each
carrying half of a split luciferase reporter — so that antigen concentration
is reported as light in a single tube, with no wash steps and no plate
reader.

**Phase one — designing and characterizing the two binder arms — is
complete and is what this project's report covers.** Phase two — assembling
the binders into the switch and testing it — is fully specified but
deliberately not started, on the evidence phase one produced (see below).

## The central finding

Before ranking any design, the project ran a control most binder-design
campaigns skip: scoring a real, solved-structure antibody (2B7) and a
non-cognate decoy (cAb-Lys3) through the same acceptance gate used to judge
designed binders. The gate ran backwards — model confidence (Boltz-2 ipTM)
was *anti-correlated* with whether a design actually contacted the intended
epitope (Spearman ρ = −0.888, p = 9.7×10⁻⁶, n = 15). The known antibody
failed the gate on every seed; the decoy with no reason to bind passed three
of five. A published antibody predicted against its own cryo-EM epitope
recovered none of its known contact residues in ten independent runs, at
unchanged confidence.

This is the project's most load-bearing result: **a predictor that cannot
locate a published epitope cannot be trusted to adjudicate a designed one.**
Everything downstream — binder ranking, the decision not to build the switch
yet — follows from taking that finding seriously rather than working around
it.

## What the project delivers

- **A calibrated scoring harness** for de novo binder design, benchmarked
  against crystallographic ground truth and released openly. This is the
  most transferable output: any campaign with a solved reference structure
  for its target can run the same control.
- **Two characterized binder arms** at non-overlapping NS1 sites: one at the
  conserved β-ladder patch (residues 261–305), one at the wing / domain-I
  face, whose 19-residue contact footprint is 84% conserved across all four
  dengue serotypes (16 of 19 positions).
- **Measured, not predicted, geometric compatibility** between the two arms:
  termini distances from superposed structures, not from a confidence score,
  showing they can occupy NS1 simultaneously in a geometry consistent with
  split-reporter complementation.
- **A construction-ready switch specification**, defining a space of 8–24
  candidate constructs across arm pairing, linker length, and reporter
  orientation.
- **A corrections ledger**, disclosing every claim retracted during the
  project and the measurement that retracted it (see Appendix A12 of the
  report).

## What the project does not deliver, and why

Neither binder has been tested experimentally — they are characterized, not
validated. The switch itself has not been assembled. This is a deliberate
stopping point, not a delay: modeling the switch first would have meant
ranking it on the same predictor just shown to place a known antibody on the
wrong face of this target in ten runs out of ten. Building on an inverted
metric would have produced confident, unfalsifiable designs, so the scoring
was fixed before anything was built on top of it.

## Next steps (from the report's Future Work, in order)

1. Build the switch constructs from the measured geometry (text operation,
   no new compute).
2. Add the control set — free arms, a non-complementing same-epitope pair,
   reporter-only background, a linker-length series.
3. Re-run the calibration controls (2B7, decoy) on a second predictor
   (AF2-multimer) to localize whether the failure is one tool or the metric
   class.
4. Wet-lab screen (partner-dependent): binding on the free arms by BLI/SPR,
   complementation on assembled constructs by luminescence.
5. A dedicated second-arm campaign targeting the wing/domain-I site,
   deliberately engaging the residues that differ between dengue and Zika.

Steps 1–3 need no wet-lab partner and no new compute, which is why they come
first. The cheapest experiment that could falsify this work — a binding
assay on the two free arms against recombinant NS1 — is the immediate ask of
any partner.

## Repository contents

This folder is a flat export of the project's working files (structures,
sequence files, scoring results, run scripts, and report drafts). Files
fall into a few natural categories:

| Category | Examples | What's in it |
|---|---|---|
| Structures | `*.pdb`, `*.cif` | Target NS1 structures (9W22, DENV4 dimer/hexamer), designed binder complexes |
| Sequences | `*.fasta` | Target NS1, designed binder sequences, serotype references |
| Results | `*.csv`, `*.json` | Gate calibration, epitope-contact scoring, rescue-campaign results, conservation checks, switch geometry measurements |
| Code | `*.py`, `*.ipynb`, `*.sh` | Contact-analysis and conservation-check modules, the campaign notebook, run/deploy scripts |
| Report & writing | `*.md`, `*.docx`, `*.pdf`, `*.pptx` | Report drafts, section drafts, the pitch deck, video-deck notes |
| Figures | `*.png` | Report figures (gate calibration, epitope-fidelity scatter, conservation, switch geometry) |
| Archives | `*.tar.gz`, `*.zip` | Bundled design sets and structure collections |

*A prior working session organized this export into role-based subfolders
(`structures/`, `results/`, `code/`, `sequences/`, `configs/`, `plans/`,
`notes/`, `logs/`, `archives/`) for easier navigation; that structure is not
reflected in the current copy of this folder. Ask if you'd like it
reapplied.*

## Key files to start with

- `report.md` / the final report PDF — full write-up: methods, findings,
  binder table, switch specification, limitations, future work.
- `final_ranked_binder_table.csv` — the 32 Boltz-2-validated designs across
  both refinement rounds, ranked by epitope contact.
- `gate_calibration_multiseed.csv` — the 15-prediction calibration dataset
  behind the central finding (ρ = −0.888).
- `switch_geometry_measurements.csv` — termini-distance measurements behind
  the switch construction spec.
- `final_benchmark_analysis.ipynb` — walks through re-running the scoring
  harness on new sequences.

## Reproducing the report figures

The report's figures are regenerable from the CSV/JSON files above using
standard plotting code (matplotlib); none require re-running the design
pipeline. See the project's figure-regeneration script if starting from a
prior data export, or ask for the mapping of each figure to its source file.

## Attribution

Kaeyura: computational pipeline, impact-chain formulation, methodology,
results, discussion. Rabaani: literature review, proposed diagnostic test,
theory of change, conclusion. Pivots and decisions throughout: joint.

## AI usage

Claude (Anthropic), the Claude Science agent platform, and Gemini (Google)
were used for: orchestrating GPU compute runs on RunPod (restart-on-failure,
sequential launch, shutdown), debugging analysis code, generating and
debugging figure-plotting code, and polishing already-written prose. All
study design, analysis, findings, conclusions, and report structure are the
authors' own. See the report's AI Disclosure section for the full statement.
