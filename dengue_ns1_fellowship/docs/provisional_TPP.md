# Provisional Target Product Profile
## Quantitative point-of-care NS1 monitoring for dengue

**Status: provisional and author-proposed.** This is not an endorsed TPP. It is written to make the project's impact pathway falsifiable — to replace "would enable a better test" with numbers a reader can test the design against. Published dengue TPPs cover pre-vaccination screening (doi:10.1371/journal.pntd.0009557, PMID 34324505) and antiviral treatments (WHO, ISBN 9789240121782); a preliminary search surfaced none for quantitative NS1 monitoring. **Verify that absence against WHO, FIND and PAHO before asserting it in the report.**

### Provenance key
Every row is marked so a reader can see which numbers are evidence and which are proposals.
- **[L]** — from the literature, cited
- **[P]** — proposed by us, reasoned from the use case
- **[U]** — unknown / to be determined experimentally

---

## Intended use

**Serial quantification of circulating NS1 antigen in patients with suspected or confirmed dengue**, at or near the point of care, to track antigen kinetics over the course of illness.

**Not** a severity-prediction test. The NS1-severity literature is directionally contradictory, and the review identifies why: NS1 assays are less sensitive in secondary infection, where immune complexes mask the antigen — and secondary infection is also the higher-risk group **[L]**. The same mechanism produces both the sensitivity gap and the severity confusion, so a severity claim built on NS1 concentration would rest on a confounded measurement.

**Not** a replacement for RT-PCR as a diagnostic reference standard.

**Users:** community health workers, clinic staff, and field epidemiologists without laboratory training.
**Setting:** primary care and community settings in dengue-endemic regions, without reliable mains power or cold chain.

---

## Analytical performance

| Parameter | Minimal | Optimal | Basis |
|---|---|---|---|
| **Analyte** | DENV NS1 antigen, native conformation | same | Design constraint: a de novo binder recognises a 3D conformational surface, so any heat/acid dissociation step is closed to us **[L]** |
| **Dynamic range** | 1–1,000 ng/mL | 0.1–10,000 ng/mL | NS1 circulates roughly ng/mL–µg/mL **[L]**; commercial-grade sensors span 1–200 and 0.01–1,000 ng/mL **[L]** |
| **Limit of detection** | ≤ 1 ng/mL | ≤ 0.1 ng/mL | Existing platforms reach **22 pg/mL (0.022 ng/mL) in undiluted human serum** (DNA aptamer electrochemical, DENV1/DENV4) **[L]**; a low-cost FTO aptasensor reaches 0.21 ng/mL in PBS and 0.55 ng/mL in serum **[L]**. The bar is set by what already exists, not by what is easy |
| **Quantitative precision** | CV ≤ 25% across the range | CV ≤ 15% | **[P]** — must resolve a day-to-day change on serial sampling; a 25% CV distinguishes a roughly 2-fold change, which is the clinically meaningful unit for kinetics |
| **Clinical sensitivity** | ≥ 87% vs RT-PCR | ≥ 95% | Beat the best fielded NS1 RDT (Abbott, 87.4%) **[L]**; the fielded range is 61.0–87.4% **[L]** |
| **Clinical specificity** | ≥ 97% | ≥ 99% | Do not regress: fielded NS1 RDTs achieve 97–100% **[L]** |
| **Serotype coverage** | Detects DENV1–4 | equivalent sensitivity across all four | Verified per-position against the DENV1–4 alignment, never assumed from sequence **[P]** |
| **Flavivirus specificity** | No cross-reaction with ZIKV NS1 at clinically relevant concentrations | quantitatively discriminates ZIKV | A dual dengue/Zika aptasensor could not distinguish the two analytes **[L]** — this is a demonstrated failure mode, not a theoretical worry |
| **Cross-reactivity, other febrile illness** | Negative in enteric fever, malaria, Japanese encephalitis, leptospirosis | same | Fielded NS1 assays already achieve this **[L]** |
| **Performance in secondary infection** | Sensitivity gap vs primary infection < 10 points | no measurable gap | **[P]** — the project's central mechanistic bet (see below) |

---

## Operational performance

| Parameter | Minimal | Optimal | Basis |
|---|---|---|---|
| **Sample type** | Fingerstick whole blood or plasma | whole blood, no separation | **[P]**; LUMABS-class sensors work directly in blood plasma **[L]** |
| **Sample volume** | ≤ 50 µL | ≤ 10 µL | **[P]** — fingerstick-compatible |
| **Assay format** | Homogeneous — mix and read | same | Architectural consequence: the split reporter needs no capture surface, no wash steps, no secondary antibody |
| **Time to result** | ≤ 30 min | ≤ 10 min | **[P]** — single-visit result |
| **Equipment** | Consumer smartphone camera, no potentiostat, no plate reader, no fabricated electrodes | smartphone only | **[P]**; camera readout of bioluminescence is established for antibodies and small molecules, **not yet for a viral antigen in whole blood [U]** |
| **Power** | Battery or none | none | **[P]** |
| **Operator training** | ≤ 1 day | none beyond pictorial instructions | **[P]** |
| **Reagent storage** | Ambient to 30 °C, no cold chain | ambient to 40 °C | **[P]** |
| **Shelf life** | ≥ 12 months at ambient | ≥ 24 months | **[P]** |
| **Cost per test** | Comparable to an NS1 RDT | below | **[P]** — a cost the product must meet; not yet estimated. A BOTEC belongs here before this row is asserted **[U]** |

---

## Why these numbers, in three sentences

The **sensitivity floor is set by the best fielded rapid test** (87.4%), because a quantitative test that misses more cases than the binary strip it replaces is not an improvement. The **specificity floor is set by the current fielded range** (97–100%), because that is the one thing NS1 rapid tests already do well and regressing on it would be a net harm. The **limit of detection is set by existing benchtop biosensors**, the best of which reaches 22 pg/mL in undiluted serum, because quantification well below the proposed floor already exists — the contribution claimed here is deployability, not sensitivity. Note the proposed minimal LoD (≤ 1 ng/mL) is ~45× *less* sensitive than the published best; that is deliberate, since the design constraint is a camera-read homogeneous format, not maximal analytical sensitivity.

---

## The central mechanistic bet, stated as a falsifiable row

The "performance in secondary infection" row is the one parameter where this architecture could beat existing tests for a structural reason rather than an incremental one.

**The argument:** antibody-based NS1 tests lose sensitivity in secondary infection because circulating anti-DENV IgG forms immune complexes that mask NS1 at immunodominant epitopes **[L]**. A computationally designed binder is not constrained to immunodominant regions and can be aimed at a surface the immune response largely ignores — where patient antibodies are not already sitting **[L, as argued in the review]**.

**Three reasons it might not hold, all stated in the review:**
1. Immune complexes are also **cleared faster** from circulation, so less antigen is present regardless of which epitope you target.
2. A bound IgG could **sterically shadow** a nearby non-immunodominant site.
3. **It is not yet verified** that residues 261–305 are genuinely non-immunodominant — this requires checking against epitope-mapping literature and is an open item.

**This is the row that makes the TPP falsifiable.** If the secondary-infection gap is not closed, the product is an incremental improvement in format rather than a structural one — still useful, but a different claim. Testing it requires paired primary/secondary cohort samples, which is a stage-3 experiment, not a computational one.

---

## What this TPP does not specify

- **Reader format** — whether readout is a bare smartphone camera, a phone plus a light-tight adapter, or a dedicated low-cost luminometer. Untested for a viral antigen in whole blood **[U]**.
- **Cost** — no BOTEC has been run. The cost row is a requirement, not an estimate.
- **Regulatory pathway** — out of scope for this project.
- **Manufacturing route** — out of scope.

---

## How to use this in the report

**§7.3 Future Work (~150 words):** state the intended use, the four or five load-bearing numbers (LoD ≤ 1 ng/mL, sensitivity ≥ 87%, specificity ≥ 97%, ≤ 30 min, camera-only), and the framing — this converts the impact pathway from arrows into pass/fail criteria. Note explicitly that it is provisional and author-proposed.

**Appendix:** the full tables, the provenance key, and the mechanistic-bet section.

**Cross-reference:** §6 (*The proposed test*) is where the assay format that must meet these targets is specified — see `proposed_test_design.md` §8 for the requirement-by-requirement mapping.

**Do not** present this as an endorsed or validated TPP, and do not assert that no equivalent exists until the WHO/FIND/PAHO check is done.
