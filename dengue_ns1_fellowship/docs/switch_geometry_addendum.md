# Switch construction — geometry addendum (CPU, no GPU)

Amends `switch_construction_plan.md` (2026-07-22). All numbers computed this session from
9W22 (DENV2 NS1 **dimer**, chains A and a) and the seed-5 nb_3 model. 4.5 A heavy-atom
contact cutoff; FreeSASA for exposure.

## 1. The second epitope survives dimerisation — plan CONFIRMED

The NS1 dimer interface on chain A comprises **41 residues**:
`1-7, 10, 12, 14, 16-23, 32, 158, 182, 184-192, 194, 210, 227-234, 254`
(complete enumerated list, recomputed from the saved `ns1_dimer.pdb` at 4.5 A).
Checked against each epitope:

| epitope | residues in dimer interface |
|---|---|
| second epitope, primary (74/77/113/115/118/119/122/123) | **0 of 8 — clear** |
| second epitope, fallback (73/74/77/118/119/122/123/126) | **0 of 8 — clear** |
| nb_3 seed-5 footprint (269/281/299/303-306) | **0 of 7 — clear** |

Both epitopes are fully available on the physiological dimer. The plan's second-epitope
choice holds under the dimer test it had not yet been given.

## 2. Sandwich geometry — hetero-sandwich confirmed, homo ruled out

| pairing | centroid separation | verdict |
|---|---|---|
| seed-5 <-> EP2, **same protomer** | **50.2 A** (closest CA-CA **32.4 A**, 269<->74) | **workable** |
| seed-5 <-> EP2, cross-protomer | 70.4 A | too far |
| seed-5 <-> seed-5 (homo, across dimer) | 78.8 A | ruled out |
| EP2 <-> EP2 (homo, across dimer) | 88.2 A | ruled out |

This **independently reproduces the plan's 32.4 A** closest-approach figure and confirms
its homo-sandwich exclusion — the plan cited 77 A, measured here as 78.8 A on 9W22.

Usable band for NanoBiT: reporter halves need to come within ~10-30 A after linkers; a VHH
is ~40 A end-to-end, so a 30-60 A epitope separation is workable. **Only the same-protomer
hetero pairing sits in that band.**

## 3. CORRECTION to the plan: the proximal terminus is the N-terminus

The plan's table lists `C-term -> CDR-H3 apex, 10.6 A` and concludes the C-terminus sits
under the antigen-facing tip. Measured on the full 118-residue seed-5 model:

| | -> paratope centroid | -> CDR-H3 centroid |
|---|---|---|
| **N-terminus** | **14.5 A** | **14.6 A** |
| C-terminus | 33.9 A | 34.8 A |

N-to-C separation is 36.9 A — the termini are on opposite poles, as expected for a
canonical VHH. **The N-terminus is the proximal one.** The plan's 10.6 A figure was
measured on a model resolving only Ca 1-107 (its own header notes this), i.e. a truncated
FR4; the rebuilt full-length C-terminus is distal.

**Consequence for the single-VHH Switchbody path:** fuse **HiBiT at the N-terminus**, not
the C-terminus. The Switchbody mechanism needs the reporter peptide able to occlude the
paratope in the apo state; from 14.5 A a short linker does this, whereas from 33.9 A the
required linker is long enough to make the trapped state entropically unlikely.

| fusion point | distance to paratope | linker for reach (3.3 A/res extended) | assessment |
|---|---|---|---|
| **N-terminus** | 14.5 A | **5-8 res** (16-26 A) | **preferred — short, entropically favourable trap** |
| C-terminus | 33.9 A | >=11 res (36 A) | long linker; weak trap, high apo background |

Recommended linker menu, N-terminal HiBiT: **GS, GSGS, (GS)3, (GS)4, GGSGGS** (2-12 res),
screening for apo-state occlusion of the paratope. For the two-VHH sandwich, linkers are
not trap-critical: use (GGGGS)2-3 on each arm and let the 50.2 A epitope separation set
the reporter spacing.

## 4. Bonus finding: the decoy site is a dimerisation artefact

The non-cognate negative control (cAb-Lys3) in the gate calibration bound NS1 at residues
1-20, 184-190, 228-231. **20 of those 21 residues are in the dimer interface.** The decoy
site is only exposed on the artificial monomer used for prediction; it does not exist on
the physiological dimer.

Two consequences:
- **The N-terminal decoy problem is partly an artefact of monomer-based prediction.** The
  seed-3 off-epitope pose (ipTM 0.778) that beat the on-epitope pose targets NS1 residues
  1-15 — also in the dimer interface. Predicting against the **dimer** rather than the
  monomer should suppress these decoys without any change to the binder.
- **Validation runs should use the dimer.** This is a cheap, high-value correction to the
  harness: same binder, same settings, physiologically correct target.

## 5. What this does not establish

- Trap/release thermodynamics for a Switchbody remain **not predictable** with current
  tools, exactly as the plan states. Geometry can rule a fusion point *out*; it cannot rule
  one *in*.
- All distances are from single static models (one crystal structure, one predicted binder).
  No ensemble, no linker conformational sampling. Treat +/- 3 A as noise.
- The 9W22 assembly is annotated **dimeric**. Hexamer-specific accessibility (the secreted
  form) is not tested here and would need a hexamer model.
- NS1 residues 1-32 being at the dimer interface is a property of this crystal form; a
  different assembly could differ.
