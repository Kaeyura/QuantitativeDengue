# dengue_ns1_fellowship

Curated, forward-carrying subset of `dengue_ns1_export/`. This folder keeps
every file that is either a final deliverable, a data file the final report
cites or that backs a released figure/table, or a structure/sequence/config
needed to reproduce a reported result. It drops draft trails, per-section
scratch notes, process logs, and raw unscored generation output (thousands
of un-triaged backbones/designs) that fed into — but are not themselves —
the reported results.

## What's here

| Folder | Contents | Why kept |
|---|---|---|
| `results/` (64 files) | All result/metric/ranking CSVs and TSVs: gate calibration, epitope-fidelity scoring, conservation, rescue campaign, switch geometry, corrections ledger, `MANIFEST.csv` | Every number in the report traces to one of these |
| `structures/` (46, incl. `archives/`) | Target structures (9W22, DENV4 dimer/hexamer), designed-binder and complex PDBs, ranked-design complexes, and the packaged benchmark/shortlist structure bundles (`ns1_benchmark.tar.gz`, `ns1_binder_benchmark_repo.tar.gz`, `rf2_1b_shortlist_pdbs.tar.gz`, `top10_binder_complexes.tar.gz`, `for_advisor_review.tar.gz`, `multi_validator_structures.tar.gz`, `rf2_shortlist_pdbs.tar.gz`, `ns1_final_benchmark_bundle.tar.gz`) | Structural ground truth + every structure a reported measurement was taken from |
| `figures/` (51) | All report and campaign figures as originally rendered | Visual record backing the report; some are superseded by the regenerated versions noted below |
| `sequences/` (12) | Target and designed-binder FASTA files | Needed to regenerate or hand off any design |
| `configs/` (42) | Run configs, harness specs, manifests, per-design JSON metrics, `.yaml` co-folding configs | Needed to reproduce any number exactly (harness settings are load-bearing per Appendix A13) |
| `code/` (16) | Analysis scripts (`epitope_contact_analysis.py`, `score_epitope_fidelity.py`, `denv_conservation_check.py`), the benchmark notebook, and all `.sh` run/deploy scripts | Reproduces every reported measurement from the deposited files |
| `docs/` (14) | Final-state project docs: theory of change, target product profile, switch construction plan, deliverables inventory, README variants | Forward-facing project state, not drafting history |
| `presentation/` (2) | Pitch deck, video deck | Fellowship deliverables |
| (root) | `Designing a Quantitative Dengue NS1 Test - FINAL.pdf` | The submitted final report |

**Total: 248 files, ~115 MB.**

## What was deliberately left out, and why

- **Report drafting trail** (11 `.docx` versions, `report.md`, `FULL_REPORT.md`, `appendix.md`, the older PDF, ~15 section-draft `.md` files, outline/rubric/review-response files, title/name-brainstorm notes) — all superseded by the final PDF kept at the root of this folder. The final report is the single source of truth for the writeup; the trail that produced it doesn't need to travel forward.
- **Process logs and status notes** (`execution_status_report.txt`, `nb3_optimization_status.txt`, `timings.txt`, `run.log`, etc.) — session-scoped working notes, not results.
- **Raw unscored generation output** (`rfdiffusion_designs.tar.gz`, `mpnn_designs.tar.gz`, `mpnn1b_designs.tar.gz`, `phase1b_backbones.tar.gz`, `pilot_designs.zip`, `pilot_msa_refold.zip` — several hundred MB of un-triaged candidate backbones and sequences) — this is generation-stage intermediate output. The *scored, ranked* subset of it is preserved in `results/` (rankings) and `structures/` (the specific complexes those rankings refer to); the raw bulk is regenerable from the pipeline (RFdiffusion → ProteinMPNN → Boltz-2) and the configs in `configs/` if ever needed again, but doesn't need to be carried as a static artifact.
- **Two unrelated files** that were mixed into the original export folder by mistake: a SHAP/judicial-models report and a separate dengue-prevalence-forecasting project write-up. Neither belongs to this project.

## Where to start

1. `Designing a Quantitative Dengue NS1 Test - FINAL.pdf` — the report.
2. `results/gate_calibration_multiseed.csv` + `results/design_shortlist_table.csv` — the two datasets behind the report's central finding.
3. `docs/theory_of_change.md` and `docs/provisional_TPP.md` — where the project goes next.
4. `code/final_benchmark_analysis.ipynb` — reproduces the scoring harness on new sequences.

## Data files behind each headline claim (quick reference)

| Claim | Data file |
|---|---|
| Gate calibration inversion (ρ = −0.888, n = 15) | `results/gate_calibration_multiseed.csv`, `results/gate_calibration_summary.csv` |
| Design-level rank shift (ρ ≈ −0.79 recomputed from this file; parent report states ρ = −0.826, not yet reconciled — see paper_draft.md §3.2) | `results/design_shortlist_table.csv` |
| 3G2 mislocation (0/16 recovery, 10/10 runs) | `results/ternary_results.csv` |
| Steric infeasibility of cropped-target designs | `results/shortlist_refeasibility.csv` |
| Monomer vs. dimer registered prediction | `results/dimer_revalidation.csv` |
| Second-arm DENV1-4 conservation (84%) | `results/second_arm_conservation.csv` |
| Switch geometry / linker requirement | `results/switch_geometry_measurements.csv` |
| Withdrawn burial safety criterion | `results/burial_decomposition.csv`, `results/direction_b_burial.csv` |
| Charge-variant series (withdrawn) | `results/charge_variant_results.csv` |
| Full corrections ledger | `results/corrections_ledger.csv` |
