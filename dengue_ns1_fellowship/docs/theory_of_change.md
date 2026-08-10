# Theory of Change — the results-driven pathway
**De Novo Protein Switches for Quantitative Dengue NS1 Detection**

**Committed direction: R.** Impact runs from designed binders → a validated switch → a quantitative NS1 test that works where only yes/no tests currently reach. One chain, stated once, no hedging arms.

This is the more ambitious pathway and it connects directly to the dengue framing that justified the target choice. It is defensible — **on one condition**: the gates get stated in the theory of change itself, not buried in a limitations section. A judge who sees you name the gaps first reads the rest as credible. A judge who spots a gap you skipped discounts everything.

The three things that make this version work, in order of importance:
1. **State the gate list inside the ToC.** Visible preconditions, not hidden ones.
2. **Write a provisional target product profile.** Turns arrows into pass/fail numbers.
3. **Report the partner status honestly** — "in progress, permission and mentor still being sought" is a plan; implying more is the one thing that would sink this section.

---

## The chain

**Activities** — designed and characterised binder candidates at two non-overlapping NS1 sites; measured the two-arm sandwich geometry directly from superposed structures; calibrated the scoring harness against crystallographic references so the candidate ranking means something.

**Outputs** — ranked binder candidates against a conserved, designable epitope; a **construction-ready switch specification** (linker lengths, reporter placement, oligomer context, simultaneous-binding geometry); a reproducible benchmark others can extend. **Immediately post-submission: the switch constructs themselves** — complete, orderable arm sequences plus their control set, which is what goes to a wet lab (see *The deliverable* below).

**Outcomes** — a partner lab screens the constructs (assembled switches, free arms, and controls in one experiment) → a functioning proximity switch emerges, or the screen says specifically which stage failed → it performs in serum → it is read by a consumer camera rather than a plate reader.

**Impact** — quantitative NS1 monitoring at the point of care: serial measurement of antigen kinetics in settings that today get a single yes/no strip, with no potentiostat, no wash steps, and no cold chain.

**What would falsify it** — the candidates fail to express or bind; or they bind but proximity complementation gives no usable dose–response; or the signal floor sits above circulating NS1 concentrations in whole blood.

---

## Lead with the strongest asset

**The sandwich geometry is your best card — play it first.** It is the one substantive claim in the project that is **predictor-independent**: it comes from superposing structures and measuring distances and clashes, not from a confidence score that could be miscalibrated. Concretely: the two sites don't overlap and can be occupied simultaneously (22/25 seed-pair superpositions clear the clash threshold; 10/10 among well-converged ones), the C-termini are closest at median ~30.6 Å and both solvent-exposed when bound, and same-protomer pairing is favoured — which is what puts the assay in a clean 1:1 dose–response regime.

That is a real, measured, construction-ready specification. Most computational design projects hand a wet lab a sequence and a hope; you hand them a two-arm architecture with linker lengths derived from measured termini distances. **Say that explicitly** — it is the sentence that makes stage 2 credible.

## The gate list — put this *in* the ToC

Five preconditions stand between the outputs and the impact. Stating them is what separates a plan from a wish:

1. **No wet-lab partner secured.** Everything downstream blocks here. Highest-leverage action in the project. Amritsar connection in progress — permission and mentor still being sought. Write that status plainly. **Note the bootstrapping constraint** (see below): partners expect switch results, which cannot be produced without a partner. Resolved by the constructs themselves — they *are* the switch result, with free-arm controls folding binder validation into the same experiment.
2. **No converged pose.** Neither β-ladder binder agrees with itself across seeds (best all-seed consensus: 3 residues). A partner would be testing a *region-targeting* candidate, not a defined interface. This changes what you'd ask them to measure — binding first, epitope mapping second.
3. **No calibrated acceptance threshold.** The pre-registered gate was invalidated by measurement; the replacement criterion was defined after seeing the data. There is currently no number that says "synthesise this one." The TPP below is how you fix this.
4. **No product specification for this test class.** Published TPPs cover dengue pre-vaccination screening (doi:10.1371/journal.pntd.0009557) and dengue treatments (WHO ISBN 9789240121782); a preliminary search found none for quantitative NS1 monitoring — *verify against WHO/FIND/PAHO before asserting absence.*
5. **Stages 3–6 rest on precedent-by-analogy.** Each has a published demonstration in a different disease; none in this one.

**Framing that makes gate 2 an asset rather than a wound:** you know exactly what you'd hand a partner and exactly what it can't yet tell you. That is a more useful thing to give a lab than an overconfident single structure.

## The provisional TPP — the highest-value addition

Write it. It converts the chain from arrows into a falsifiable specification, and it directly repairs gate 3 by supplying the missing "good enough" numbers.

| Parameter | Provisional target | Basis |
|---|---|---|
| Dynamic range | Spans circulating NS1, ~ng/mL–µg/mL | Reported NS1 concentrations in acute infection |
| Limit of detection | ≤ low ng/mL | Must sit below the bottom of the clinical range to be useful early |
| Precision | Sufficient to resolve day-to-day change on serial sampling | The monitoring use case, not severity classification |
| Time to result | Minutes | Homogeneous format — add sample, read light |
| Equipment ceiling | Consumer camera; no potentiostat, no plate reader, no wash steps | The deployability gap identified in Part B |
| Specificity | No cross-reaction with ZIKV NS1 at clinically relevant concentrations | The dual dengue/Zika aptasensor that failed to discriminate |
| Serotype coverage | Detects DENV1–4 | Verified per-position against the alignment, never assumed |
| Stability | No cold chain | Field deployment |

Two payoffs: every downstream stage gets a pass/fail number instead of an arrow, and — **if** the absence check in gate 4 holds — the TPP is a contribution in its own right, since no equivalent exists for this product class.

## Named next steps — specificity is what makes this read as a plan

- **Michael Diamond (WashU)** — co-authored the lucCage-derived serum sensor work with the Baker lab. The flavivirus × protein-switch intersection is rare and directly on-target.
- **Institute for Protein Design / Baker lab** — origin of LOCKR, lucCage, and RFdiffusion; the people who built every tool in your pipeline.
- **Clinical cohort groups** — OUCRU Vietnam, ICDDR,B Bangladesh, ICMR-NIV Pune: the sources of the NS1 performance data you already cite, and the natural evaluation partners.
- **LSHTM International Diagnostics Centre** — developed the dengue pre-vaccination screening TPP; the right people to ask what a quantitative NS1 TPP would need.
- **Amritsar connection** — furthest along. State the real status.

## The methodological work still appears — as *evidence*, not as a rival pathway

Do not delete it; re-cast it. Under direction R, the three findings (confidence–fidelity inversion, cropped-target artefact, predictor mislocation) stop being a competing impact story and become **the reason to trust your candidate ranking**:

> Our candidates were selected using a harness we validated against a crystallographic reference and a non-cognate decoy — and that validation overturned the ranking we would otherwise have used. The designs we are proposing for synthesis are not the ones a naive confidence filter would have picked.

That is a stronger argument for the shortlist than "our designs scored well," and it turns the methods work into direct support for direction R. Put it in Methods and Discussion; reference it in one line in the ToC.

**One consequence to carry honestly:** the same finding that validates your ranking also means the assembled switch has no trustworthy predicted structure — which is exactly why the deliverable is a measured geometry specification and why stage 3 is a wet-lab question rather than a modelling one.

## The deliverable: designed switch constructs

**The project's deliverable is the switches themselves.** After submission, switch design work continues to produce a set of complete, orderable switch constructs — binder arms fused through linkers to split-reporter fragments — and that construct set is what goes to a wet lab for validation. This is the thing the project promised from the start: de novo protein switches that bind NS1 and emit a signal proportional to antigen concentration.

That deliverable resolves the bootstrapping problem directly. Partners expect switch results; **the constructs are the switch result** — not a claim that they work, but a designed, buildable, testable set. Binder validation folds in as one tier of the same experiment rather than a separate prior ask.

### What "a construct" concretely is

Each construct is a pair of expressible protein sequences, fully specified end to end:

**Arm 1:** β-ladder binder — linker — SmBiT
**Arm 2:** wing/domain-I binder — linker — LgBiT

Every element is already determined by work that is finished: the binder sequences from the design campaigns, C-terminal fusion on both arms and 8–10-residue linkers from the measured termini geometry, and the NanoBiT pairing from its low intrinsic affinity (K_D ≈ 190 µM), which is what makes complementation proximity-driven. **Assembling them is string concatenation from the specification** — no prediction, no GPU, and nothing that inherits the predictor failure documented in the results.

### The construct set

Not a single design — a small matrix, because the choices that remain open are genuinely uncertain and cheap to enumerate:

**arm-1 candidate × arm-2 candidate × linker length × reporter orientation**

With 2–3 β-ladder arms, 1–2 wing/domain-I arms, two linker lengths, and two reporter orientations that is **8–24 constructs** (2×1×2×2 = 8 at the low end, 3×2×2×2 = 24 at the high end). The whole matrix is small enough to build outright, so a first screen need not trim much — take the most promising 10–12, or simply build all of them if synthesis budget allows. Ordering them for screening is a practical matter, and worth doing, but **the ordering is not the deliverable and should not be presented as one.**

**One caution if you do order them.** The ordering cannot come from predicted switch behaviour — the arm control (3G2: 0/16 epitope residues recovered in 10/10 runs, at ipTM 0.41–0.63 and pLDDT 0.90–0.92) rules that out, and a reviewer who has read the results section will check. Order on things that are measured or computed instead: arm-level on-epitope rate and consensus, DENV1–4 conservation of contacted positions, measured termini separation and steric compatibility, linker slack against measured distance, and sequence-level developability (pI, free cysteines, glycosylation sequons, aggregation-prone stretches). If an ordering appears in the report, state its basis in the same sentence.

### The controls that make a null result interpretable — do not omit these

This is the most important design point in the whole deliverable, and the easiest to lose.

**If the constructs go out alone and nothing lights up, nobody learns anything.** You cannot distinguish: the arms don't bind · they bind but the geometry is wrong · the linkers are wrong · the reporter orientation is wrong · expression failed. Five hypotheses, one uninformative result, and a partner lab that has spent its time for nothing.

Ship the constructs with:
- **Free arms, unfused** — binding measured directly by BLI/SPR. Separates "doesn't bind" from "binds but doesn't report."
- **A deliberately non-complementing pair** — both arms on the *same* epitope, so simultaneous binding is impossible. Negative control for background complementation.
- **Reporter-only control** — LgBiT + SmBiT with no arms, establishing background from intrinsic affinity.
- **A linker-length series on the most promising pair** — turns "it didn't work" into "the geometry needs N more residues."

**These controls are what make it a designed experiment rather than a wish list**, and they are the strongest thing you can say to a prospective partner: *every outcome of this screen is interpretable, including a negative one.*

### What to say in the report

The construct set is **future work with a fully defined method**, not a delivered result. The honest statement: the arm characterisation and geometry specification are complete; construct assembly is the immediate next stage and is scoped, with every input already determined; the wet-lab screen follows. The report template explicitly sanctions this shape — *"if the project didn't reach its full original goal, frame this as the path to impact once the remaining stages are completed."*

Never let "switch constructs" imply predicted function. They are designed and buildable; whether they switch is exactly what the screen is for.

## The wet-lab ask — make it pay out either way

Within stage 1, the strongest framing is one where the experiment is informative under both outcomes: test candidates the harness ranked highly *alongside* ones a naive confidence filter would have chosen. If the harness-ranked designs bind and the others don't, the pipeline is validated end-to-end. If neither binds, the calibration finding is confirmed and consequential, and the campaign still returns a publishable result.

Labs say yes to experiments that can't waste their time. Design the ask that way.

---

## Report section (~650 words)

1. **Commit in the first sentence** — impact runs from designed binders through a validated switch to a quantitative point-of-care NS1 test. No alternative arms. `[YOU WRITE]`
2. **The chain (~200 words)** — Activities → Outputs → Outcomes → Impact as above. Lead the Outputs with the sandwich geometry and the phrase *construction-ready specification*.
3. **The gate list (~200 words)** — all five, visible, with the partner status stated plainly. This is the section that earns integrity credit; it is not a confession.
4. **The provisional TPP (~150 words)** — table or compressed prose; frame as converting the pathway into something falsifiable.
5. **Named next steps + the construct hand-off (~150 words)** — specific organisations; the deliverable is **the switch constructs themselves**, complete and orderable, shipped with their control set (free arms, a non-complementing pair, reporter-only background, a linker series) so every outcome is interpretable. State why a *predicted* switch result is not available and not appropriate — no conformational state to model, and a predicted assembly would inherit a demonstrated predictor failure.

**Sequencing note:** gates *after* the chain, not before — the reader should see the ambition first and then watch you account for it honestly. Leading with caveats reads as apology; leading with the chain and following with clear-eyed gates reads as command of the problem.

---

## Two failure modes to avoid in the writing

**Overclaiming the binders.** The guardrails still apply in full: never "a validated binder" — use *"characterised against a crystallographic reference on the same predictor."* No hotspot is engaged reproducibly. Neither β-ladder binder converges on a pose. Nothing is experimental. Direction R makes it *more* tempting to soften these, and more damaging if you do — the whole section rests on the reader believing your self-assessment.

**Letting the impact claim outrun the gates.** "Would enable," "if validated," "the pathway requires" — the conditional framing is not weakness here, it is the thing that makes an ambitious chain survive a hostile reading.
