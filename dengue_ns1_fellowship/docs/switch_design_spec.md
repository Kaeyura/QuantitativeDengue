# Switch design specification — measured geometry

All numbers here are measured from coordinates. Nothing depends on a predicted structure of the
assembled switch, which this project has shown it cannot validate (see `ternary_finding.md`).

## Architecture

Two-VHH sandwich with a split-luciferase reporter. Both arms bind NS1 at non-overlapping
sites; antigen binding brings the reporter halves into proximity, giving signal proportional
to antigen concentration. This is proximity-driven complementation, **not** a conformational
switch — no closed/open state is modelled or claimed.

| | arm 1 | arm 2 |
|---|---|---|
| design | `onepi_pd_5_dldesign_1` | `seed5_pd_15_dldesign_1` |
| site | beta-ladder 261-305 | wing/domain-I (EP2 region) |
| on-site seeds | 5/5 | 5/5 |
| consensus footprint | 3 residues | **19 residues** |
| DENV1-4 conservation | 9/12 contacted | **16/19 = 84%** |
| Zika-discriminating positions | - | 35, 113, 122, 166 |
| length | 118 aa | 118 aa |

## 1. Simultaneous binding — the architectural prerequisite

Both arms were superposed onto a common NS1 frame via the target chain and tested for
inter-binder clash across all 25 seed-pair combinations.

- **22 of 25 pairs are sterically compatible** (zero heavy-atom pairs < 2.0 A).
- The 3 clashing pairs all had poor NS1 superposition (RMSD 2.9-3.6 A), i.e. the two predicted
  target conformations disagreed; the clash is conformational disagreement, not site overlap.
- Restricting to well-converged superpositions (NS1 CA RMSD < 2.2 A): **10 of 10 have zero
  atom pairs < 2.0 A**, with inter-binder separations of 2.4-15.9 A. One of these ten
  (arm1 seed 3 / arm2 seed 5, NS1 RMSD 1.94 A) is a near-contact rather than a clean
  separation: minimum distance 2.42 A with 14 atom pairs under 3.0 A. It clears the 2.0 A
  clash threshold but the two binders touch. The other nine are separated by 7.5-15.9 A with
  no atom pair under 3.0 A.

The two sites do not overlap and can be occupied at the same time. This is the one sandwich
claim that is predictor-independent.

## 2. Terminus selection — C-to-C

Measured across the 9 converged, non-clashing pairs (one orientation outlier excluded):

| termini pair | distance (A) |
|---|---|
| **C(arm1) - C(arm2)** | **21.9-42.6, median 30.6** (all 10 pairs: median 33.6) |
| N(arm1) - C(arm2) | 44.9-64.7 |
| C(arm1) - N(arm2) | 47.1-59.3 |
| N(arm1) - N(arm2) | 63.9-77.9 |

**Fuse the reporter to the C-terminus of both arms.** C-C is the closest pair by a factor of
~1.7, and the ordering is consistent across every pair measured.

Both C-termini are fully solvent-exposed in the bound state (SASA unchanged on complex
formation: arm1 113 A2, arm2 77 A2), so neither fusion point is occluded by the antigen.
Arm1's C-terminus sits 8.4 A from the NS1 surface and arm2's 21.4 A, so a short rigid segment
before the flexible linker is advisable on arm1 to avoid steric crowding against the target.

## 3. Linker length

Upper-bound geometric estimate at 3.5 A per residue for a fully extended Gly/Ser backbone:

| C-C gap | minimum total linker | with 2x slack |
|---|---|---|
| 21.9 A (closest) | 6 residues | 13 residues |
| 30.6 A (median) | 9 residues | 17 residues |
| 42.6 A (widest) | 12 residues | 24 residues |

**Recommended: 8-10 residues per arm (16-20 total), e.g. (GGGGS)x2.** This covers the widest
observed gap with slack. The minimum figures are hard lower bounds — a fully extended linker
has near-zero conformational entropy and will not form; real linkers need 2-3x the extended
minimum to retain flexibility. Erring long costs sensitivity (higher background from
antigen-independent complementation); erring short prevents complementation entirely, which is
the worse failure, so the slack is deliberate.

## 4. Reporter placement

NanoBiT (LgBiT 18 kDa + SmBiT 11 aa, KD ~= 190 uM) is the appropriate split reporter: the
fragments have low intrinsic affinity, so complementation is proximity-driven rather than
spontaneous. Suggested assignment: **SmBiT on arm 1** (its C-terminus is closer to the antigen
surface, and the 11-residue peptide is far less likely to clash than an 18 kDa domain),
**LgBiT on arm 2** (C-terminus 21.4 A clear of the target).

## 5. Dimer and oligomer context

NS1 circulates as a dimer and a hexamer, so site multiplicity matters for assay design.
Measured centroid separations in the crystal dimer (chains a/A of PDB 9W22, the same structure used as the monomer target):

| pair | distance (A) |
|---|---|
| beta-ladder <-> EP2, same protomer | 45.9 |
| beta-ladder(A) <-> EP2(B), cross-protomer | 51.5 |
| beta-ladder(A) <-> beta-ladder(B) | 59.5 |
| EP2(A) <-> EP2(B) | 66.2 |

The intended same-protomer pairing is the closest arrangement, so it is geometrically
favoured over cross-protomer bridging. Both sites remain accessible in the dimer: the EP2 site
has only 1 of 19 residues within 5 A of the partner protomer, and the beta-ladder was
previously confirmed accessible. A dimeric antigen with two copies of each site permits
intramolecular (single-antigen) and intermolecular (antigen-bridging) complementation; the
45.9 A same-protomer distance and 30.6 A C-C span favour the former, which is the desired
1:1 dose-response regime.

## 6. What this specification does NOT establish

- **No predicted structure of the assembled switch.** Boltz-2 mislocated antibody 3G2 on this
  target in 10 of 10 runs (0/16 epitope recovery) and inverted the confidence ranking for 2B7,
  so a predicted ternary or switch-state model would not be trustworthy. This is why the
  specification is built from pairwise geometry instead.
- **Neither arm converges on a single pose.** Arm 1's all-seed consensus is 3 residues; arm 2's
  is 19 but its pose is predicted by the same tool. Distances above are therefore reported as
  ranges, and the linker recommendation is sized for the full range rather than a point value.
- **No hotspot is engaged reproducibly** by either arm (best: 269 in 3/5 seeds).
- **Zika cross-reactivity is a live risk** at the EP2 site (68% ZIKV identity). Discrimination
  requires deliberately engaging 35/113/122/166; it is available, not automatic.
- **Nothing is experimental.** No affinity, expression, or luminescence data. Validating the
  switch requires SEC/SPR and a functional assay — out of this project's scope.

## Recommended next step (not attempted here)

Put AF2-multimer through the same published-antibody control that Boltz-2 failed (2B7 and 3G2,
10 predictions, ~3-4 h on one A40; ColabFold is installed). AF2-multimer was this project's
originally planned validator and has never been tested on this control. If it places both
antibodies correctly, a trustworthy ternary model becomes obtainable and this specification can
be upgraded to a structural model. If it fails too, the conclusion is that no available tool
gives a trustworthy predicted structure of this complex — a clean, reportable methods result.
