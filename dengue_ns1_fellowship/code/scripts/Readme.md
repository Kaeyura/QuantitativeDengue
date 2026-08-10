# code/scripts/

Shell scripts written during the project to drive the RFdiffusion → ProteinMPNN → Boltz-2
pipeline on a RunPod GPU host, orchestrated from a Claude Science session (see the
project's AI Disclosure in the final report). This is a mix of **reusable harness/template
scripts** and **one-off, run-specific scripts** written for a particular stage, patch, or
seed and not intended to be re-run as-is. Neither category was cleaned up retroactively —
they're kept together here as a record of what was actually run, with a read before reuse.

If you're picking this project back up with Claude Science again, these are a starting
point, not a packaged tool: expect to point them at your own RunPod pod, paths, and
target files before running anything.

## Reusable / template (safe starting point for a similar run)

| Script | What it does |
|---|---|
| `boltz2_validation_harness.sh` | General Boltz-2 binder:target validation harness, calibrated against a positive crystallographic control and a non-cognate negative before trusting it on any design. The core pattern reused across most of the validation runs below. |
| `run_val.sh` | Same harness applied to a specific construct set (charge-variant paratopes vs. NS1 monomer, 5 seeds) — good template for "run the calibrated harness against a new candidate set." |
| `run_ternary.sh` | Ternary-complex validation pattern (two binders + target, testing simultaneous non-overlapping binding) — reusable for any two-arm switch design, not just this project's specific pair. |
| `run_rescue.sh` | Re-predicts cropped-epitope designs against the full-length target to test steric feasibility — reusable any time designs were generated against a fragment and need re-checking against the whole protein. |
| `deploy_and_pilot_bindcraft.sh` | Isolated BindCraft environment deployment + pilot run on a RunPod A40 pod — reusable for spinning up BindCraft again in a clean conda env. |
| `run_dengue_batch.sh`, `run_rfantibody_scale.sh` | Parameterized batch-generation scripts (patch/hotspot/target, or design count, passed as variables) — reusable as templates for a new generation batch, not runnable unmodified. |

## One-off / run-specific (record of what was done, not meant to be rerun)

| Script | Why it's one-off |
|---|---|
| `nb3_step2_3_setup.sh`, `nb3_step2_3_execute.sh` | Hard-coded to one specific candidate's (`nb_3`) seed-5 framework and that framework's specific residue numbering. |
| `post_pilot_score_vs_nb3.sh` | A specific apples-to-apples comparison against `nb_3` as the reference. |
| `resume_stage23.sh` | A resume/recovery script for one interrupted run, tied to that run's specific backbone directory. |
| `run_mpnn.sh` | Redesigns a fixed, specific set of 6 residue positions on one specific backbone (nb_3's dimer seed-5 pose). |

## Provenance

All scripts in this folder were written by Claude (Claude Science) at the user's
direction during the project — see the project's own AI Disclosure for the scope of
that assistance (the user decided what to run and why; the agent managed execution,
restarted failed runs, and handled shutdown of the GPU host). They are provided as-is:
useful as a reference or a starting template for a similar Claude Science-driven
pipeline, but not tested for portability to a different environment.
