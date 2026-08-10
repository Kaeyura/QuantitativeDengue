# Structures shared for external advisor review

## 1. Target protein
- `target_NS1_monomer_9W22.pdb` — dengue NS1 monomer, chain A extracted from PDB 9W22 (real crystallographic structure, not designed).
- `target_NS1_betaladder_epitope_crop.pdb` — the same target cropped to the primary epitope used for design/scoring, native residues ~255-310 (the beta-ladder patch, hotspots 269/272/274/294/296).

## 2. Top designed binders (binder:NS1 complexes)
Three complexes from the highest-ranked designs in `final_ranked_binder_table.csv` (contact-first ranking over 32 Boltz-2-validated designs across two refinement rounds):

- `rank1_onepi_pd_30_dldesign_1_RF2_complex_NOTGATEPASS.pdb` — overall rank 1 (8 epitope contacts, hotspot 272 engaged), Boltz-2 ipTM 0.447
- `rank4_onepi_pd_28_dldesign_0_RF2_complex_NOTGATEPASS.pdb` — overall rank 4 (4 epitope contacts), Boltz-2 ipTM 0.475
- `rank9_seed5_pd_2_dldesign_0_RF2_complex_NOTGATEPASS.pdb` — a high-ipTM (0.818) design that is completely OFF the epitope (0 contacts) — included deliberately to illustrate the core finding below.

**Important caveat on these three files:** the coordinates are RF2 (RoseTTAFold2) pre-filter structures, not the Boltz-2-predicted structures that actually generated the ipTM/pLDDT/contact numbers used for ranking and gating. RF2 was used only as a coarse triage step and is documented in our report as producing severe interface clashes in the majority of its own "best" structures (independent of sequence identity) — so treat backbone/side-chain geometry in these PDBs as approximate, not as the validated prediction. The Boltz-2 complex coordinates for the final 32 designs were not persisted as separate structure files in this campaign (only their metrics were saved); we can regenerate them on request if useful for your review.

**None of the 32 designs across two refinement rounds pass our locked acceptance gate** (Boltz-2 complex pLDDT > 0.80, ipTM > 0.7, interface pAE < 5 A, >=3 epitope contacts, simultaneously). The best on-epitope design (rank 1 above) has weak confidence (ipTM 0.447); the best-confidence designs (ipTM up to 0.851) all bind completely off the target epitope. This anti-correlation between Boltz-2 confidence and physical epitope fidelity replicated four independent times and is the project's main finding so far — see `campaign_master_summary.png`.

## 3. Switch / fluorescent reporter complex
**There is no switch or GFP/luciferase-reporter complex to share yet.** Grafting a binder into the lucCage/NanoBiT-style switch scaffold (Week 4 stretch goal) is explicitly gated on having a validated binder first, and none has passed the gate. What exists instead is a computational design plan (`switch_binder_geometry.png` + full text in the project's `switch_construction_plan.md`) that works out reporter architecture (LgBiT/SmBiT sandwich vs. HiBiT/LgBiT single-VHH Switchbody), a candidate second epitope for a two-VHH sandwich format, and linker/fusion-point choices for whenever a validated binder becomes available.

## Supporting figures
- `campaign_master_summary.png` — ipTM vs. epitope-fidelity across both refinement rounds (the key negative-result figure).
- `denv1-4_conservation.png` — pan-serotype conservation check at the five designed hotspots (4 of 5 conserved; one, residue 272, is a non-identical R/K substitution vs. all four DENV1-4 references).
