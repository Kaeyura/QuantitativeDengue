# De Novo Protein Switches for Quantitative Dengue NS1 Detection

**A reproducible benchmark for computational binder design against dengue NS1,
with an honest account of what worked, what didn't, and why.**

Team: Kaeyura Puram and Rabaani Mehra (Non-Trivial Fellowship). 5-week research
phase, ~20 hrs/week each.

---

## Project goal

Design de novo protein switches that bind dengue virus NS1 and emit a signal
proportional to antigen concentration — turning yes/no dengue rapid tests into
quantitative ones. Pipeline: RFdiffusion (binder backbones) → ProteinMPNN
(sequences) → AlphaFold2-multimer / Boltz-2 (structural validation) → graft top
binders into a lucCage/LOCKR-style switch scaffold with a split reporter.

**Target:** dengue NS1 only, narrowed from an initial six-biomarker panel after
week 1 scoping ruled out the others (glycan with no protein interface, antibody-
capture-only antigens, or disordered proteins unsuitable for de novo design).

**Epitope:** Direction B (primary) — the NS1 β-ladder patch, native residues
261–305, hotspots 269/272/274/294/296 — chosen for being a rigid, conserved,
designable surface, avoiding a nearby host-mimicry region flagged as a
false-positive risk. Direction A (wing-domain loop, ~104–125) was scoped as a
stretch goal and never attempted due to time constraints.

**Locked acceptance gate** (fixed before any generation): Boltz-2 complex
pLDDT > 0.80, ipTM > 0.7, interface pAE < 5 Å, and ≥3 contacts within the native
epitope range at physically valid (1.5–4.5 Å, heavy-atom) distances.

---

## What this project delivers

1. **A validated scoring harness.** AlphaFold2-multimer ipTM — the metric this
   field defaults to — was shown to be **broken for nanobody scaffolds**: a
   crystallographic true binder (PDB 1MEL) scored *below* a non-cognate negative
   control under AF2. Boltz-2 ipTM, run with an MSA-server-backed, 3-recycle,
   `--no_kernels` protocol, correctly separated the true binder (0.96) from the
   decoy (0.42). This harness — and the discipline of testing it against a known
   positive before trusting it on de novo output — is the project's most durable
   contribution, independent of whether any single binder succeeded.

2. **A reproducible, well-characterized negative result.** Across two escalating
   campaigns (de novo generation, then partial-diffusion refinement of the one
   promising lead found), **0 designs pass the full locked gate.** The specific
   failure mode — a strong, reproducible **anti-correlation between Boltz-2 ipTM
   confidence and physical epitope fidelity** — was replicated independently four
   times and is documented in enough detail to be checked, reused, or refuted by
   others.

3. **A DENV1–4 pan-serotype conservation check**, applied both to the chosen
   hotspots and to the actual modeling target sequence (catching a real
   divergence at one hotspot position — see below).

4. **Everything needed to reproduce or extend this work**: harness scripts,
   ranked tables, structures, and this write-up.

No design reached the acceptance gate. No switch construct was built (Week 4
stretch goal, blocked on having a validated binder to graft). Both are disclosed
here rather than glossed over, per the project's own framing: a well-characterized
negative with a validated harness is a legitimate certain deliverable, not a
failure to report.

---

## Timeline of the campaign

**Week 1 — scoping and pilot.** DENV1–4 alignment built; β-ladder epitope locked
after Direction A/C alternatives were scoped and set aside. First BindCraft pilot
run crashed immediately on a file-permission bug (bundled DSSP binary not
executable); after fixing, the corrected pilot produced ipTM scores of ~0.10–0.13
across all trajectories — read at the time as early evidence of epitope
difficulty, though later work would show this metric itself was unreliable for
this scaffold class.

**Week 2 — scaled generation, RFantibody pivot.** RFdiffusion antibody-specific
generation (RFantibody) was scoped for deployability and adopted in place of
generic BindCraft. Hotspot-steered de novo nanobody generation (nb_3 lead
candidate + related designs) produced 0 of 5 validated designs passing the locked
gate — the highest-confidence design (ipTM 0.806) bound the NS1 N-terminus, not
the β-ladder. This is the **first appearance** of the ipTM/epitope-fidelity
inversion that would recur throughout the project.

**Week 3 — the harness confound, and its resolution.** A multi-validator
comparison (BindCraft designs, nb_3, and a non-cognate control, scored under both
AF2 and Boltz-2) found all designs floored near the non-binding baseline — but
the comparison had no *positive* control, so it could not distinguish "the
epitope is hard" from "the scoring pipeline is broken." A dedicated
positive-control experiment (a true crystallographic nanobody:antigen pair vs. a
non-cognate negative) resolved this: **AF2-multimer ipTM is invalid for
nanobodies; Boltz-2 ipTM is valid.** Within the same nb_3 dataset, a 5-seed and
then 6-seed Boltz-2 ensemble found one reproducible on-epitope pose ("seed 5")
that had been missed because the highest-*confidence* seeds in the same ensemble
were consistently off-epitope — the inversion's second independent appearance.

**Week 4–5 (compressed, this session) — seed-5 refinement campaign.** Seed 5 was
Chothia-renumbered, scaffolded, and refined via two rounds of RFdiffusion partial
diffusion (32 designs total) toward the locked hotspots, each followed by
ProteinMPNN sequence design, RF2 pre-filtering, and full Boltz-2 validation
against full-length NS1. Result: 0 of 32 designs pass the full locked gate; the
inversion replicated a third and fourth time, including in a round specifically
re-seeded from the one on-epitope pose. See
[`seed5_refinement_methods.md`]({{artifact:d928405a-382b-43b1-871c-fabbbc617e95})
for full methodological detail, including two disclosed data-integrity
corrections made during this phase (a fabricated-scaffold incident caught before
downstream use, and a hydrogen-atom contact-counting bug), and a DENV1–4 check
that found one designed hotspot (272) is a conservative but non-identical
substitution relative to all four reference serotypes in the sequence actually
used as the modeling target.

Switch construction (Week 4 stretch goal — grafting a validated binder into a
lucCage-style scaffold and benchmarking closed↔open state prediction) was never
reached, since it depends on having a validated binder as input.

---

## Repository layout

```
README.md                          — this file
seed5_refinement_methods.md        — detailed methods for the seed-5 campaign
harness/
  boltz2_validation_harness.sh     — the validated Boltz-2 scoring protocol
  epitope_contact_analysis.py      — heavy-atom, clash-floor-corrected contact scoring
  denv_conservation_check.py       — pan-serotype conservation check
notebooks/
  final_benchmark_analysis.ipynb   — runnable walkthrough: harness -> ranked table -> figures
data/
  ns1_serotypes.fasta, ns1_aln.fasta          — DENV1-4 reference sequences + alignment
  seed5_HLT.pdb, seed5_chothia.pdb            — the seed-5 scaffold (Chothia-numbered)
  onepitope_seed_hlt.pdb                      — the on-epitope re-seed backbone (Phase 1b)
results/
  final_ranked_binder_table.csv    — all 32 Boltz-2-validated designs, contact-first ranked
  campaign_master_summary.png      — the key figure: ipTM vs epitope fidelity, both rounds
  denv1-4_conservation.png / .csv  — corrected pan-serotype conservation
  boltz_shortlist_results.csv, boltz_1b_results.csv  — per-round detailed metrics
```

(See the artifact links inline in `seed5_refinement_methods.md` for every
intermediate structure and score file referenced above; the full project history,
including the earlier BindCraft and de novo RFantibody campaigns, is preserved in
the project's artifact store.)

---

## Honest assessment against the original 5-week plan

| Deliverable | Status |
|---|---|
| Working pipeline (RFdiffusion → ProteinMPNN → AF2/Boltz-2) | **Done**, and hardened: partial diffusion required bypassing the RFantibody CLI wrapper (documented), and the Boltz-2 harness required a validated positive control before it could be trusted. |
| Ranked, validated binders | **Not achieved.** 0/32 refined designs (and 0/5 from the earlier de novo round) pass the locked acceptance gate. |
| Reproducible benchmark | **Done.** Harness, ranking rule, and full result tables are packaged and runnable. |
| Methods write-up (incl. negative results) | **Done** — this document and the linked methods file. |
| Switch constructs (stretch) | **Not attempted** — blocked on a validated binder. |
| Direction A / wing-loop (stretch) | **Not attempted** — deprioritized under time pressure per the project's own risk framing (disordered region, flavivirus cross-reactivity risk). |

The central scientific finding — a reproducible anti-correlation between a
widely-used confidence metric and physical epitope fidelity, on a specific
nanobody-scaffold/epitope combination, replicated four independent times — is, in
the team's assessment, a more useful contribution to share than a single
unvalidated "success" would have been.
