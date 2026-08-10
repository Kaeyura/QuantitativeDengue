# Project summary (329 words)

**The problem.** Dengue infects hundreds of millions of people a year, and point-of-care tests give a yes/no answer. Measuring *how much* NS1 antigen is in a patient's blood — the quantity that tracks infection over time — still requires a laboratory. Quantitative NS1 sensors exist, but they need fabricated electrodes and benchtop instruments, so the gap is deployability, not detection.

**What we set out to build.** A protein switch: two de novo binders gripping opposite faces of NS1, each carrying half of a split luciferase, so antigen brings the halves together and the sample glows in proportion to how much is there. One tube, no wash steps, readable by a phone camera.

**What re-baselined it.** Before ranking any design, we ran a control most campaigns skip: a protective antibody with a solved crystal structure, and a decoy that binds nothing, put through our own acceptance filter. The antibody failed every seed; the decoy passed three of five. Across fifteen predictions, model confidence was *anti-correlated* with binding the intended site (ρ = −0.888), and re-ranking on measured contact yields a shortlist sharing no molecules with the naive one. Three further controls each exposed a distinct failure mode invisible to standard metrics. Building switches on an inverted metric would have produced confident, unfalsifiable designs — so we fixed the scoring first.

**What the project delivers.** A calibrated scoring harness for de novo binder design, benchmarked against crystallographic ground truth and released openly — the contribution most transferable beyond dengue. Two characterised binders at distinct NS1 sites, one 84% conserved across all four serotypes. A construction-ready switch specification from measured geometry, defining a space of 8–24 constructs. And a proposed assay format to carry them.

**What comes next is specified, not speculative.** Assembling and modelling those constructs is phase two — planned, beginning immediately, and now judgeable by a metric we have reason to trust. We know what our filter does, which is more than most design campaigns can say about theirs.

---

## Notes on what this claims, and what it deliberately does not

- **Framing: re-baselined, not delayed.** "Delayed" invites the reader to score you against an unfinished plan. "Re-baselined" says the scope was revised on evidence and *met*. The project has a complete deliverable — a calibrated harness, two binders, a switch specification — and a specified phase two. Both halves must be present or the note reads as excuse-making.
- **The re-baselining is justified, not asserted.** The reason appears before the consequence: building switches on an inverted selection metric would have produced confident, unfalsifiable designs. That sentence is what converts a delay into a decision.
- **Order matters.** Deliverables come *before* next steps. Ending on "what comes next" is fine; leading with it is not.
- **"characterised" not "validated."** Two binders were assessed against a crystallographic reference on the same predictor. Neither has been tested experimentally.
- **The 84% figure** is the arm-2 realised footprint: 16 of 19 contact positions conserved across DENV1–4, verified per-position. (The *planned* EP2 window was 6 of 8, 75% — different residue set, do not conflate.)
- **ρ = −0.888** is seed-level (n = 15); the design-level replication is ρ = −0.826 (n = 10), which is the "shortlist sharing no molecules" sentence.
- **"Three further controls"** = the cropped-target artefact (0 of 32 designs sterically possible on intact NS1), the predictor mislocation (a published antibody placed on the wrong face in 10 of 10 runs), and the refuted charge hypothesis.
- **8–24 constructs** = (2–3 arm-1 candidates) × (1–2 arm-2 candidates) × 2 linker lengths × 2 reporter orientations. Low end 2×1×2×2 = 8; high end 3×2×2×2 = 24.
- **No switch behaviour is claimed anywhere.** The specification is geometric — measured termini distances and steric compatibility — not a predicted signal. The architecture is a proximity sandwich; there is no conformational state to model.
- **The closing line is a claim about method, not about being clever.** "We know what our filter does, which is more than most design campaigns can say about theirs" is defensible because §5.1 measured it. Do not upgrade it to a claim about the field's reliability in general — that is n = 1.

## Shorter cuts

**~130 words** — keep paragraphs 1, 2 and 5; compress 3 and 4 to: *"Before ranking anything we checked our acceptance filter against a known antibody and a known decoy. It ranked them backwards, so we rebuilt it before building switches on top of it. The project delivers a calibrated scoring harness, two characterised binders, and a construction-ready switch specification."*

**~55 words (verbal, for the talk):** We set out to build a protein switch that makes dengue tests quantitative. Before trusting the filter that picks our binders, we checked it against an antibody known to work — it failed, and a decoy that binds nothing passed. So we rebuilt the filter first. That's what we're handing over, and the switches are next.
