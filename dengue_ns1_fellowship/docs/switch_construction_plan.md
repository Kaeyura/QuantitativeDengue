# Dengue NS1 Bioluminescent Switch — Computational Construction Plan

> **VERSION 3 (reconciled).** This replaces v2 (2026-07-30), which was written before the
> shortlist-rescue campaign, the charge-variant run, and the ternary arm-control. Five v2
> claims are now overturned; the architecture is unchanged in *kind* (a two-arm proximity
> sandwich with a split reporter) but the arms, the reporter-fusion terminus, and the
> minimum-viable deliverable have all changed. Every correction is logged in
> `corrections_ledger.csv`. The load-bearing changes:
>
> 1. **The switch deliverable is a specification, not a predicted model.** The v2
>    minimum-viable deliverable was a modelled two-VHH:NS1 ternary complex with per-arm
>    metrics. That is **withdrawn**: the co-folding predictor mislocates a reference antibody
>    (3G2) on this target — 0/16 of its own cryo-EM epitope recovered in 10/10 runs, with
>    unremarkable confidence — so a predicted ternary or switch-state model is not
>    trustworthy here. The switch is specified from **predictor-independent pairwise
>    geometry** instead (see `switch_design_spec.md`).
> 2. **Reporter fuses at the C-terminus of both arms, not the N-terminus.** The v2 N-terminus
>    recommendation was for a single-VHH Switchbody, an architecture no longer pursued
>    (see §1). For the two-arm sandwich, the measured C(arm1)–C(arm2) span is the closest
>    terminus pairing (median 30.6 Å, ~1.7× closer than any other), and both C-termini are
>    solvent-exposed when bound.
> 3. **The ~370 Å² epitope-burial ceiling is retracted.** Re-derived on 15 full-length
>    on-epitope poses: epitope burial ranges 119–413 Å² (one pose exceeds the claimed
>    ceiling). There is no hard limit; the honest statement is that the *median* achievable
>    epitope burial (238 Å²) sits below 2B7's crystallographic 320 Å².
> 4. **"The five nominated hotspots cannot be engaged by one paratope" is withdrawn.** Three
>    cropped-target designs contacted all five; on full-length NS1 hotspots are reachable but
>    not *reproducibly* (best: 269 in 3/5 seeds). The acceptance criterion is epitope fidelity
>    (methods §7.2), not a hotspot count.
> 5. **The two arms are the two rescue-campaign leads, not nb_3 + a published partner.**
>    Arm 1 = `onepi_pd_5_dldesign_1` (β-ladder, 5/5 on-epitope); arm 2 =
>    `seed5_pd_15_dldesign_1` (wing/domain-I, 19-residue consensus across 5/5 seeds, 84%
>    DENV1–4-conserved). The published antibody 3G2/4B8 is a **methods-development arm only**
>    (31% DENV1–4-conserved → serotype-biased). LOCKR/lucCage remains rejected (§1).

**Session type:** computational planning + in-silico geometry only. No GPU design runs, no
new binder generation, no wet lab.
**Target:** dengue NS1, 9W22 chain A (1–346), β-ladder epitope 261–305; tip 311–352 is a
*risk-carried* zone, not an absolute avoid-zone (banner-adjacent, see §5).
**Deliverable framing:** a fellowship benchmark — a *design specification* and its in-silico
plausibility envelope, not a validated sensor.

---

## 1. Architecture — decided

**Build a two-arm proximity sandwich with a split NanoBiT reporter.** Two binders engage two
non-overlapping NS1 sites; antigen binding brings the reporter halves into proximity,
reconstituting luminescence proportional to antigen concentration. This is
**proximity-driven complementation, not a conformational switch** — no closed/open state is
modelled or claimed.

Why this and not the alternatives:

- **Single-VHH Switchbody (conformational trap)** — *dropped.* It needs a genuine
  trap→release thermodynamic switch whose apo occupancy and antigen-induced release are
  quantities the predictor cannot compute; and this project has shown the predictor is not
  even reliable for the *static* ternary geometry here. A sandwich tolerates a
  partially-reproducible individual binder (avidity from two arms compensates) where a
  Switchbody needs one excellent binder — and no binder here converges on a pose.
- **LOCKR / lucCage caging** — *rejected, do not reintroduce.* It requires a de-novo cage
  designed against this specific binder (weeks of work), and switch-state prediction is
  untrustworthy per project epistemics and now doubly so on this target.

The make-or-break questions for the sandwich are geometric — do the two arms fit
simultaneously, and are the reporter termini close enough to reconstitute — and those are
answered from coordinates without trusting a predicted assembly.

---

## 2. The two arms

| | arm 1 | arm 2 |
|---|---|---|
| design | `onepi_pd_5_dldesign_1` | `seed5_pd_15_dldesign_1` |
| site | β-ladder 261–305 | wing/domain-I (EP2 region) |
| on-epitope seeds | 5/5 | 5/5 at its own site (0/5 β-ladder) |
| consensus footprint | 3 residues | **19 residues** |
| DENV1–4 conservation | 9/12 contacted | **16/19 = 84%** |
| ZIKV-discriminating positions | — | 35, 113, 122, 166 |
| length | 118 aa | 118 aa |

Arm 2 is the strongest second-arm candidate the project has: highest pose reproducibility
observed anywhere, higher serotype conservation than the primary epitope, dimer-accessible,
and it cost no dedicated campaign (see `second_arm_finding.md`). **Its Zika cross-reactivity
is a live risk** — 68% ZIKV identity, higher than the primary epitope's 62% — and
discrimination requires a binder deliberately engaging 35/113/122/166, not one that merely
lands on the site. That is a design constraint carried forward, not a resolved item.

**Published partner (methods-development only).** 3G2 (PDB 8JKF) / 4B8 (8JKH) bind a
non-overlapping wing/connector site and are sterically ideal with a β-ladder binder (18.3 Å
clearance, 0 clashes). But at **31% DENV1–4 conservation** they would give a serotype-biased
assay, so they are **not** the primary second arm. Their value is as a pipeline
demonstration on real coordinates — with the caveat that the predicted ternary itself is
untrustworthy here (§1, §6).

---

## 3. Simultaneous binding — the architectural prerequisite (predictor-independent)

Both arms were superposed onto a common NS1 frame via the target chain and clash-tested
across all 25 seed-pair combinations:

- **22 of 25 pairs are sterically compatible** (zero heavy-atom pairs < 2.0 Å).
- The 3 clashing pairs all had poor NS1 superposition (RMSD 2.9–3.6 Å) — the clash is
  conformational disagreement between two predicted target copies, not site overlap.
- Restricting to well-converged superpositions (NS1 Cα RMSD < 2.2 Å): **10 of 10 compatible.**

The two sites do not overlap and can be occupied simultaneously. This is the one sandwich
claim that does not depend on trusting a predicted assembly.

A **homo-sandwich is ruled out**: the two β-ladder epitopes are ~78 Å apart in the dimer,
far outside the reporter reconstitution window. A genuinely different second site on the
same protomer is required — which is what arm 2 provides.

---

## 4. Reporter fusion, linker, and terminus — C-to-C

Measured across the 9 converged, non-clashing pairs (one orientation outlier excluded):

| termini pair | distance (Å) |
|---|---|
| **C(arm1) – C(arm2)** | **21.9–42.6, median 30.6** |
| N(arm1) – C(arm2) | 44.9–64.7 |
| C(arm1) – N(arm2) | 47.1–59.3 |
| N(arm1) – N(arm2) | 63.9–77.9 |

**Fuse the reporter to the C-terminus of both arms** — the closest pairing by ~1.7×, and the
ordering is consistent across every pair. Both C-termini are solvent-exposed when bound
(SASA essentially unchanged on complex formation), so neither fusion point is occluded.
Arm 1's C-terminus sits 8.4 Å from the NS1 surface (arm 2's 21.4 Å), so a short rigid
segment before the flexible linker is advisable on arm 1.

**Linker:** 8–10 residues per arm (16–20 total), e.g. (GGGGS)×2. This covers the widest
observed C–C gap (42.6 Å) with slack; a fully-extended linker has near-zero conformational
entropy and will not form, so 2–3× the extended minimum is deliberate. Erring long costs
sensitivity (antigen-independent background); erring short prevents complementation entirely
— the worse failure.

**Reporter pair:** NanoBiT **LgBiT + SmBiT** (KD ≈ 190 µM), *not* HiBiT/LgBiT. In a sandwich
the two binders supply the avidity, so the reporter halves must be too weak to self-assemble
or the assay lights up antigen-independently. Suggested assignment: **SmBiT on arm 1** (its
C-terminus is closer to the antigen surface and the 11-residue peptide is less likely to
clash), **LgBiT on arm 2**.

---

## 5. Oligomer context and the tip

NS1 circulates as a dimer and a hexamer. Same-protomer centroid separations
(8WBB-derived model): β-ladder ↔ EP2 same-protomer **45.9 Å** (favoured) vs cross-protomer
51.5 Å. Both sites are accessible in the dimer (EP2: 1/19 residues within 5 Å of the partner
protomer; β-ladder confirmed accessible). The 45.9 Å same-protomer distance with the 30.6 Å
C–C span favours **intramolecular (single-antigen) complementation** — the desired 1:1
dose-response regime — over antigen-bridging.

**Tip 311–352 is a risk-carried zone, not an absolute avoid-zone.** The protective antibody
2B7 buries 250 Å² (42% of its interface) in the tip, so an absolute tip-avoidance criterion
excludes the one antibody known to work on this epitope. Restrict tip contact to 2B7's own
validated set (326–328, 330, 343–347) rather than forbidding all tip contact. **The
host-mimicry risk is not resolved and cannot be resolved computationally** — it requires
binding assays against candidate human targets (out of scope). Carry it as an open risk on
the design; **mentor sign-off** before relying on any tip contact.

---

## 6. The honest boundary — what this specification does and does not establish

**Establishes (from coordinates, predictor-independent or trustworthy geometry):**
- Two arms can occupy their NS1 sites simultaneously without clashing.
- The reporter-proximal termini (C–C) fall within a NanoBiT-plausible distance window.
- Interface residues' DENV1–4 conservation and (for arm 2) the quantified ZIKV risk.

**Does NOT establish (state plainly in the deliverable):**
- **No predicted structure of the assembled switch.** The predictor mislocated 3G2 (0/16
  epitope recovery, 10/10 runs) and inverted the confidence ranking for 2B7, so a predicted
  ternary or switch-state model is untrustworthy on this target. This is why the switch is a
  **specification, not a model.**
- **That the switch switches.** Signal magnitude, dynamic range, dose–response linearity,
  LOD, and background are thermodynamic/kinetic quantities requiring wet-lab measurement.
- **Pose convergence.** Neither arm converges: arm 1's all-seed consensus is 3 residues; arm
  2's is 19 but at its own site and predicted by the same tool. Distances are reported as
  ranges and the linker is sized for the full range.
- **Reproducible hotspot engagement** (best: 269 in 3/5 seeds).
- **Affinity, expression, stability, or aggregation** of the fusion constructs.

**Fellowship framing:**
> "We deliver a computational *design specification* for a bioluminescent two-arm sandwich
> against dengue NS1, with simultaneous binding and reporter geometry shown to be consistent
> with NanoLuc reconstitution from predictor-independent coordinate measurements. We do
> **not** claim a working sensor, nor a predicted structure of the assembled complex —
> signal, dynamic range, and LOD are wet-lab quantities, and the co-folding predictor is not
> trustworthy for the assembled geometry on this target. The reusable contributions are the
> architecture specification, the de-novo design + validation method, and a reproducible
> benchmark — the novelty is the design method and framing, not being first to detect NS1."

## 7. Recommended next step (future work, not attempted here)

Put **AF2-multimer** through the same published-antibody control Boltz-2 failed (2B7 + 3G2,
10 predictions, ~3–4 h on one A40; ColabFold is installed). It was the originally planned
validator and has never been tested on this control. If it places both antibodies correctly,
a trustworthy ternary model becomes obtainable and this specification can be upgraded to a
structural model; if it fails too, the clean methods result is that no available tool gives a
trustworthy predicted structure of this complex.

---

## 8. Evidence index

| claim | authoritative artifact |
|---|---|
| Gate inverted (ρ = −0.888, n = 15) | `gate_calibration_finding.md`, `gate_calibration_multiseed.csv`, fig10 |
| Two rescue leads beat nb_3; campaign effect | `rescue_finding.md`, `rescue_results.csv`, `rescue_summary.csv`, fig14 |
| Second-arm lead, DENV1–4 84%, ZIKV risk | `second_arm_finding.md`, `second_arm_conservation.csv`, fig16 |
| Direction B: burial ceiling retracted, tip criterion refuted | `direction_b_tractability.md`, `direction_b_burial.csv`, fig15 |
| Switch geometry (C–C, 22/25 compatible, same-protomer) | `switch_design_spec.md`, `switch_geometry_measurements.csv`, fig13 |
| Cropped-target artefact (0/32 feasible) | `reranking_finding.md`, `shortlist_refeasibility.csv` |
| Ternary invalidated (3G2 0/16) | `ternary_finding.md`, `ternary_results.csv`, fig12 |
| Charge hypothesis refuted (−0.137, p = 0.564) | `charge_variant_results.csv` |
| Published partner 3G2/4B8: 31% conserved | `sandwich_partner_finding.md` |
| Dimer re-validation refuted | `dimer_revalidation.md` |
| All corrections with evidence | `corrections_ledger.csv` |

> **Naming note:** `fig8_switch_geometry.png` is the OLD single-binder geometry from a
> truncated model and its distances are superseded. Use `fig13_switch_geometry.png` (current
> two-arm figure) for all switch geometry.
>
> **Methodological caveat to disclose:** the replacement epitope-fidelity criteria were
> defined *after* seeing the calibration data, so they describe the observed binders rather
> than independently testing them.
