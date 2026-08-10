# Project deliverables inventory — full scan
**274 artifacts** across all sessions in `proj_e6d9dc23700a`. Complete filename → version_id list in `artifact_inventory.tsv`. This document covers what matters for the report.

## Headline: a full report draft already exists

**`report.md`** (`cdc226ca-a1d3-4628-b944-dd65489c82cc`, 20 kB, **3,014 words** (whitespace tokens; 2,603 excluding tables and figure embeds)) — a complete, well-written draft covering the methods findings, binder results, switch specification, deliverables table, and future work. It is **methods-first**, titled *"a benchmark, and four ways a design pipeline can lie to you."*

This changes the task: the report is not being written from scratch — it needs **restructuring into Part A / Part B, plus the rubric sections it lacks**.

**What `report.md` already has, well-drafted:** all five methods findings with controls and effect sizes; the binder table with honest characterisation; the "what must not be claimed" list; the switch specification table; the deliverables status table; future work; a strong closing note on negative results as deliverables.

**What it lacks (all rubric-scored):** Theory of Change · problem-importance / ITN framing · literature integration (Part B) · plain-language accessibility for non-experts · AI-usage disclosure · author contributions · references. It also opens with an unresolved editorial note to the authors, which must be removed before submission.

**Note it is methods-first, and you have committed to direction R (results-driven).** The draft's own header flags this as an open authors' decision and recommends methods-first; that recommendation is now superseded. §3 (binders) and §4 (switch) move ahead of §2 (methods findings), and the methods findings become *evidence that the ranking is trustworthy* rather than the headline. The prose survives the reordering nearly intact — this is a restructure, not a rewrite.

---

## ⚠️ Two conflicts found in the scan

### 1. `switch_geometry_addendum.md` says N-terminus; the current spec says C-terminus. **The spec is right.**
- `switch_geometry_addendum.md` (`8a4063c4-98a4-4094-b8b4-65014173c2de`) measures a **single VHH** (nb_3 seed-5) and finds its N-terminus proximal to the paratope (14.5 Å vs 33.9 Å). Its recommendation — *fuse HiBiT at the N-terminus* — is for the **single-VHH Switchbody** architecture, which was abandoned.
- `switch_design_spec.md` (`7fd92688-7a3f-43c0-83b9-5bdab003c57b`) measures **termini distances between the two arms** and finds C–C closest (median 30.6 Å vs 44.9–77.9 Å for other pairings) → fuse at both C-termini.
- **Not a contradiction — different questions.** The addendum asks "which terminus is near its own paratope" (matters for a trap-based switch); the spec asks "which termini of the two arms are near each other" (matters for proximity complementation). For the two-arm sandwich, C–C is correct. **The addendum even says so itself:** *"For the two-VHH sandwich, linkers are not trap-critical: use (GGGGS)2-3 on each arm."*
- **Action:** do not cite the addendum's N-terminus recommendation in the report. If the addendum is cited at all, cite only its dimer-interface findings (§1, §4).

### 2. The addendum's dimer recommendation was tested and refuted
It recommends switching validation runs to the NS1 dimer, predicting this would suppress decoys. **`dimer_revalidation.md` tested exactly that and found the opposite** — on-epitope fidelity got *worse* (1/5 dimer vs 3/5 monomer). The addendum's §4 recommendation is **superseded**; the refutation is the reportable result (a registered prediction that failed). `report.md` already handles this correctly in §3.2.

### 3. ⚠️ Numeric error inside `report.md` §2.4 — fix before submission
`report.md` states the 3G2 arm control ran at **"ipTM 0.41–0.63"**; `ternary_finding.md` states **0.48–0.63**. Recomputed from the source table `ternary_results.csv` (`48af06be-f6d9-40fc-a744-6259ea7273d3`):

| quantity | measured | note |
|---|---|---|
| `ctrl_3g2` ipTM (5 seeds) | **0.413–0.634** | report.md's 0.41–0.63 is **correct** |
| `ctrl_3g2` pLDDT (5 seeds) | **0.905–0.918** | report.md's "0.88–0.91" is **wrong** — understates the floor |
| all 10 runs incl. ternary | 0.367–0.634 | neither figure |

**Both documents have an error, in different places.** `ternary_finding.md`'s 0.48 low end excludes seed 3 (0.4128) and seed 5 (0.4495); its "pLDDT 0.91" is a rounded single value, not a range. `report.md`'s ipTM range is right but its pLDDT range is wrong.

**Correct figures to use in the report: ipTM 0.41–0.63, pLDDT 0.90–0.92, across 5 arm-control seeds.** The finding is unaffected — the point is that confident-looking scores accompany a completely mislocated epitope, and a 0.90 pLDDT floor makes that point slightly *more* forcefully. Add to the corrections ledger.

### 4. Stale documents confirmed — do not cite
- `report_outline.md` — **two versions**, both stale (still headline "0/32 designs pass the gate")
- `binder_status.md`, `next_steps.md`, `switch_construction_plan.md`, `corrections_ledger.csv` — flagged stale in the handoff
- `fig8_switch_geometry.png` — superseded single-binder geometry; **use `fig13`**
- `AF3class_revalidation_report.md`, `bindcraft_*`, `multi_validator_report.md`, `nb3_optimization_*`, `option2_Eprotein_contingency.md` — historical decision records from earlier phases; useful for the methods narrative (why RFantibody over BindCraft; why Boltz-2 over AF2) but not results

---

## The deliverable-bearing set, by role

### Source of truth
| file | version_id | role |
|---|---|---|
| `report_handoff_prompt.md` | `cf91252c-5da9-4171-b9d1-01842d718d1b` | Authoritative status, claim guardrails, stale-doc list |
| `report.md` | `cdc226ca-a1d3-4628-b944-dd65489c82cc` | **Existing full draft — restructure this** |
| `methods.md` | `d111bc3a-4bf6-480e-acb5-bc47c3e7bfba` | Unified methods prose |
| `README.md` (v2) | `7671d416-8403-475e-8f8c-be5bc718f7c4` | Benchmark repo README — includes a "traps that already caused errors" section |

### Findings documents (one per result)
| file | version_id | maps to |
|---|---|---|
| `gate_calibration_finding.md` | `32ff1047-cdbf-4871-96f5-6070c6bc2323` | Gate inversion (ρ = −0.888) |
| `reranking_finding.md` | `034f499b-f175-41a8-b1a6-c9321e2affe0` | Cropped-target artefact (0/32) |
| `rescue_finding.md` | `4e3c26a2-d1e1-4aeb-a31c-f33d0ad01224` | Sequence recovery; campaign effect |
| `ternary_finding.md` | `222d748e-f9ff-4c8a-9312-0d329f3fe85f` | Predictor mislocation (0/16 in 10/10) |
| `direction_b_tractability.md` | `6a727f26-10de-48f1-b0af-8a01b0206b65` | Tip criterion refuted |
| `dimer_revalidation.md` | `2b1eece6-959c-4d5a-aabe-3f766f30aa86` | Registered prediction that failed |
| `second_arm_finding.md` | `ae4f4ce4-27db-4814-91c2-4637a42da6d3` | Second-arm lead; conservation |
| `sandwich_partner_finding.md` | `27190a75-aa78-41d0-899f-9a86cd8fdc35` | Published-antibody survey; 3G2 disqualified on conservation |
| `mimicry_analysis.md` | `8d26d280-c7b2-4da3-ae04-3846806a9190` | Mimicry window; v1 no-go retracted |

### Switch specification
| file | version_id | note |
|---|---|---|
| `switch_design_spec.md` | `7fd92688-7a3f-43c0-83b9-5bdab003c57b` | **Current — C-to-C, (GGGGS)×2, NanoBiT** |
| `switch_construction_plan.md` | `09abd844-3b3c-4984-ac34-0e79db5a7704` | Superseded in parts; check against spec |
| `switch_geometry_addendum.md` | `8a4063c4-98a4-4094-b8b4-65014173c2de` | ⚠️ N-terminus finding is for the abandoned single-VHH architecture |

### Benchmark bundle & analysis
`final_benchmark_analysis.ipynb` (`66dc6dc4-90fd-4048-b8f6-2fc0174df1cb`) · `ns1_final_benchmark_bundle.tar.gz` (`f61f8176-9ed7-4872-96d1-6ea832338dc7`) · `ns1_benchmark.tar.gz` (`fda0c2c1-18bd-42d6-a435-d9c9b2ea9a81`) · `ns1_binder_benchmark_repo.tar.gz` (`436b17a1-fab7-4787-8a1d-26e5aa51d035`)

### Figures — 42 total; the nine the report needs
`fig7_gate_calibration.png` `a2684ba5-80ab-4b3a-b786-682dd7214d32` · `fig10_multiseed_calibration.png` `927d020c-e55d-4d50-9d46-0a6d8f44b520` · `fig14_rescue_campaign.png` `b21de07e-ff07-44eb-8c7f-e01435dc642d` · `fig12_ternary_validation.png` `09942e79-5dba-4142-825a-ce20bf9dace5` · `fig15_directionB_rederivation.png` `ac4d3c45-ecd5-4e91-aded-a17b2d40cc34` · `fig16_second_arm.png` `c2b5dbb2-a46a-4c80-a0ff-3c54e94774dc` · `fig6_specificity_annotated.png` `3486ef06-67d3-4e23-865b-27d5a13f0fd4` · `fig13_switch_geometry.png` `642acadf-a508-462c-a538-3e49d23dad5b` · `fig9_published_antibodies.png` `9ae0fa45-a5f2-4c48-8982-22128626bb00`

> ⚠️ `report.md` embeds `{{artifact:2830751d-...}}` for switch geometry and `{{artifact:ac4d3c45-...}}` for Direction B — **verify every embedded ID resolves to the current version** before submission; at least one figure family has a stale twin (fig8 vs fig13).

### Sequences & structures (needed for the partner-lab package)
`binders.fasta` `b3e213e2-4459-4483-95f3-d2ac87090be8` · `top10_binder_sequences.fasta` `01f806c5-1080-4fec-b076-546b625281ae` · `target_9W22_chainA.pdb` `d3b39f9d-6dc0-4b97-bb98-af2a9356a2cd` · `ns1_dimer.pdb` `a98f4c16-2471-42a7-8848-b83f3283dc5e` · `nb3_ns1_AB.pdb` `8702fbe3-a704-4364-97f2-0e372cb65904` · `ns1_aln.fasta` `2ec2eb5c-0b1c-46f1-b6c0-c177622f55da` — 12 FASTA and 36 PDB artifacts total

### Data tables (59 CSVs) — the ones the report cites
`rescue_results.csv` `e75bdb3d-b5ea-47a0-8278-1127cd308abb` · `gate_calibration_multiseed.csv` `9918c3c2-9bf9-42fa-a03f-bcb542ba2beb` · `shortlist_refeasibility.csv` `feda6617-6561-4b5e-b98e-9e323d799224` · `charge_variant_results.csv` `72fb22df-2979-4877-b838-f0697fc9a602` · `ternary_results.csv` `48af06be-f6d9-40fc-a744-6259ea7273d3` · `direction_b_burial.csv` `5f6d21f2-3123-4451-903d-77c0756fff92` · `second_arm_conservation.csv` `ac010d6c-c2a6-442a-9769-8a973f16c9ef` · `binder_status_scorecard.csv` · `corrections_ledger.csv` `9fb9850b-804c-4170-a56e-efad3774f80a`

---

## What is genuinely missing for the report

1. **Part B in any form** — no diagnostics-landscape writing exists in the artifacts. The Google Doc research notes are the only source, and they are outside the artifact store.
2. **Theory of Change section** — now specified in `theory_of_change.md`, not yet drafted as prose.
3. **Assembled construct sequences** — binder + linker + reporter written out as orderable protein sequences. Nothing in the 12 FASTA artifacts contains a fusion construct. This is the concrete piece for the partner-lab ask.
4. **Provisional TPP** — specified in `theory_of_change.md`, not written.
5. **AI-usage disclosure, author contributions, references** — none exist in any artifact.
6. **Plain-language framing** — `report.md` is written for a structural-biology reader; the rubric audience is a smart non-expert.

## Revised sense of the remaining work
The drafting task is materially smaller than it looked. `report.md` covers most of Part A at publication quality. The remaining work is: **reorder for direction R** → **write Part B (~2,400 words) from the research notes** → **add Theory of Change, importance framing, disclosure, references** → **plain-language pass** → **verify figure IDs and word count**.
