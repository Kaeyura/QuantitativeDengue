# Instrument-Free Diagnostics for Diseases the Laboratory Never Reaches

## The problem we keep coming back to

A diagnostic test that only says yes or no is a test that has already given up
on the patient's trajectory. Across neglected tropical diseases, the pattern
repeats: a circulating biomarker exists, it rises and falls in a way that would
tell a clinician which direction the patient is heading, and the only assay
that can read it quantitatively needs a plate reader, cold-chain reagents, and
a trained operator — three things a district clinic, let alone a home, rarely
has all at once. The dengue NS1 test that motivated this work is one instance
of that pattern, not the whole of it.

## The long-term goal

We want to build molecules that do the separating step an ELISA needs a
laboratory for, inside the molecule itself. A designed protein switch that
recognizes its target and reports its concentration as light in one tube, one
drop of sample, no wash steps, read by a phone camera, is not a new idea; it
has been demonstrated for SARS-CoV-2, HER2, and a handful of other analytes.
What is missing is the extension of that idea to the diseases that need it
most: the ones whose defining problem is that the laboratory is absent
altogether, not that the analyte is hard to detect once you have one.

That is the direction this work commits to: pick a biomarker for a
laboratory-scarce disease, design binders against it de novo, validate that
the binders occupy the sites a split-reporter format needs, and specify a
homogeneous, camera-read assay built on top of that. Repeat for the next
target.

## What we think we owe every campaign, regardless of target

The dengue NS1 project taught us something that turned out to matter more than
whether that particular switch gets built: the confidence metrics used to rank
computationally designed binder:target complexes can be actively
anti-correlated with whether the design binds the intended site. A shortlist
built by trusting the score can be worse than a shortlist built by ignoring
it. We only found this because we ran a control most campaigns skip — scoring
a known crystallographic binder and a decoy with no reason to bind — before
ranking anything.

Going forward, that control is not optional. Every campaign under this program
runs its scoring pipeline against a positive and negative construct with known
structural ground truth before it is trusted to rank anything else. Where a
solved structure for the target exists, the calibration is cheap. Where it
does not, the absence of a calibration is stated as a limitation, not omitted.

## What "done" looks like, target by target

For each biomarker we take on, the deliverables are the same, in this order:

1. A characterized binder (or pair of binders) against a defined, conserved
   epitope, with the ranking metric validated against ground truth.
2. Measured, not merely predicted, geometric compatibility with whatever
   reporter architecture the assay needs.
3. A construction-ready specification: exact fusion points, linker lengths,
   and reporter placement, so building it is a text operation on measured
   geometry, not a fresh design problem.
4. An honest theory of change: the preconditions between "characterized
   binder" and "deployed test," the evidence that exists for each today, and
   the cheapest experiment that would resolve the next one. Stated gaps, not
   implied ones.
5. An openly released benchmark artifact: the scoring harness, the
   calibration data, and the corrections made along the way. This is the
   piece that outlives any single target, because a method for judging
   whether a design pipeline can be trusted is reusable even when a specific
   binder is not.

## What we are not building

We are not building a severity-prediction tool, a replacement for RT-PCR or
laboratory ELISA where those are already accessible, or a claim of novel
sensing chemistry. The architecture — protein switch, split reporter,
camera-read bioluminescence — is drawn from existing precedent. The
contribution is extending it to targets and settings that precedent has not
reached, and being disciplined about what a computational pipeline can and
cannot tell you about a design before it is tested at a bench.

## Where this goes next

Phase one of the current target (dengue NS1) — design and characterization —
is complete. Phase two, wet-lab validation and assembly, is specified and
deliberately not started until the cheapest falsifying experiment (a binding
assay on the free arms) has run. The next biomarker after NS1 inherits the
calibration discipline this one forced on us, whether or not the NS1 switch
itself is ultimately built.

---
*This document describes the standing goals of this research program,
independent of any single fellowship or funding cycle. Project-specific
status, data, and reproduction instructions live in that project's own
README.*

