# The proposed test — a design, not a literature finding
**Part B's actual deliverable: a specific diagnostic format that carries the switch constructs.**

The literature review establishes *why* a quantitative deployable NS1 test is missing. This document specifies *what to build*. It is a design proposal at the level of detail a reader can argue with — format, reagents, readout, calibration, and the failure modes that would kill it — not a claim that it has been built or tested.

**Status of every claim here:** proposed. Nothing in this document has been fabricated or measured experimentally. Where a design choice follows from your own measurements, that is marked. Where it rests on published precedent in a different system, that is marked too.

---

## 1. The format in one paragraph

A **homogeneous, mix-and-read bioluminescent assay.** A fingerstick blood sample is added to a single tube containing lyophilised reagents: the two switch arms and the luciferase substrate. NS1 in the sample binds both arms simultaneously, bringing LgBiT and SmBiT into proximity, reconstituting an active luciferase that turns substrate into light. A smartphone camera in a light-tight adapter integrates the emitted photons for a fixed exposure. Light output scales with antigen concentration; the phone converts photon counts to ng/mL against a stored calibration.

**One tube, one sample addition, no wash steps, no second reagent, no plate reader.**

## 2. Why this format follows from the architecture

The homogeneous format is not a stylistic preference — it is the direct consequence of putting recognition and reporting in the same molecule.

| ELISA (current quantitative standard) | Proposed format |
|---|---|
| Capture antibody immobilised on a plate | No solid phase |
| Sample incubation, then **wash** | No wash |
| Detection antibody added, then **wash** | No second addition |
| Substrate added; plate reader quantifies | Substrate pre-mixed; camera quantifies |
| Multiple timed liquid-handling steps | One addition |
| Laboratory | Point of care |

**Every laboratory requirement in the left column exists to separate bound from unbound antibody.** A proximity switch does not need that separation, because unbound arms emit no light. This is the entire argument for why a designed switch can leave the lab when an ELISA cannot, and it is the sentence Part B should be built around.

**Bioluminescence rather than fluorescence is also load-bearing.** Fluorescence needs an excitation source and an emission filter, and blood autofluoresces. Bioluminescence generates its own photons from a chemical reaction, so the reader can be a bare camera sensor in a dark enclosure — no light source, no optics, no filter. This is what collapses the instrument down to a phone.

## 3. Physical form

**Consumable:** a single-use tube or cartridge containing lyophilised arm 1, arm 2, and furimazine substrate, sealed against moisture. Lyophilised protein reagents are the standard route to ambient-stable diagnostics; the substrate's stability in that form is an open question **[unresolved]**.

**Sample:** fingerstick, ≤ 50 µL, ideally through an integrated plasma-separation membrane (see failure mode 2).

**Reader:** a 3D-printable or moulded light-tight adapter that holds the tube in a fixed geometry against the phone's rear camera. Fixed geometry matters more than optical quality — quantification depends on the sample-to-sensor distance being identical between the calibration and the measurement.

**App:** fixed exposure and ISO (auto-exposure would destroy quantification), integrates pixel intensity over the tube region, subtracts a dark frame, applies the stored calibration, and reports a concentration with a confidence interval.

## 4. How quantification actually works — the hard part

This is where most bioluminescent point-of-care proposals become vague, so specify it.

Raw photon count is not a concentration. It varies with temperature (luciferase activity is strongly temperature-dependent), substrate age, reaction time, sample volume, phone camera model, and haematocrit. A single-channel intensity measurement read by an uncontrolled consumer device will not give a reliable number.

**Three options, in increasing order of robustness:**

1. **Fixed calibration curve.** A factory-determined curve stored in the app. Simplest; vulnerable to every source of variation above. Adequate for coarse binning, probably not for tracking a 2-fold change.
2. **Internal spike control.** A second reaction chamber with a known NS1 quantity, run in parallel; the ratio corrects for reagent and temperature variation. Doubles the sample volume requirement.
3. **Ratiometric dual-colour readout (recommended).** Include a spectrally distinct reference luciferase at fixed concentration in the same tube. Quantify the **ratio** of the two emission channels rather than absolute intensity. The ratio is insensitive to exposure, distance, reagent quantity, and temperature, because both channels vary together. This is the established route for camera-read bioluminescent sensors — LUMABS-class sensors quantify by colour ratio for exactly this reason **[published precedent, different analyte]**.

**Recommend option 3**, and state its cost honestly: it adds a second reporter to the construct design and requires the two emissions to be separable by an unmodified phone sensor's RGB channels.

## 5. Controls that ship with each test

A quantitative test that cannot tell a true zero from a failed reaction is not deployable.

- **Positive/reaction control** — the reference luciferase in option 3 doubles as proof the reaction ran and the substrate was active. A dark tube means invalid, not negative.
- **Background** — established from the reporter-only condition (intrinsic NanoBiT affinity, K_D ≈ 190 µM) during development; sets the lower detection bound.
- **Sample adequacy** — insufficient volume or a clotted sample must fail visibly rather than silently reading low.

## 6. Failure modes that could kill this — state them in the report

These are the design's real risks. Naming them is what makes the proposal credible rather than promotional.

### 6.1 The hook effect (high-dose prozone) — the most serious
In any sandwich assay, at high antigen concentration each arm binds a *separate* antigen molecule instead of both binding the same one. Cross-linking collapses and **signal falls as concentration rises** — a high sample reads as low. NS1 spans roughly ng/mL–µg/mL, a range of three orders of magnitude or more, so this is not a hypothetical.

**Mitigations:** run each sample at two dilutions and flag disagreement; or design the dynamic range so the clinically relevant window sits below the hook; or use the ratio of two dilutions as the quantity reported. **This must be characterised experimentally before any clinical claim** — it is a stage-3 experiment.

### 6.2 Blood absorbs blue light
NanoLuc emits in the blue (~460 nm), and haemoglobin absorbs strongly in that region. A whole-blood sample will attenuate the signal, and the attenuation will vary with haematocrit — which is exactly the kind of patient-to-patient variation that destroys quantification.

**Mitigations:** integrate a plasma-separation membrane (adds a step but removes the problem), or use a red-shifted luciferase variant where haemoglobin absorption is lower. Red-shifted NanoLuc-family variants exist; whether one is compatible with split-reporter complementation at the required sensitivity is **unresolved**. Note that a ratiometric readout (§4, option 3) partially corrects for this if both channels are attenuated similarly — but they will not be attenuated equally if they are spectrally distinct, so this interacts with the calibration choice and needs to be worked out rather than assumed.

### 6.3 NS1 circulates as a hexamer — and this cuts both ways
NS1 is secreted as a hexamer of three dimers, so each particle carries multiple copies of both epitopes. **Favourable:** two arms can bridge epitopes on one particle, and multivalency should increase apparent affinity. **Unfavourable:** the measured geometry that underpins the construct design was derived on the *dimer*, with same-protomer pairing favoured for a clean 1:1 regime. On a hexamer, additional bridging modes exist that were never modelled, and the dose–response may not be the simple 1:1 curve the specification assumes. **This is a genuine gap between the structural work and the assay proposal, and the report should say so rather than glossing it.**

### 6.4 Background complementation
NanoBiT's low intrinsic affinity is what makes complementation proximity-driven, but at high arm concentration some spontaneous association occurs, setting a signal floor. Raising arm concentration to improve sensitivity also raises background — there is an optimum, and it must be found empirically.

### 6.5 Cold chain and substrate stability
The no-cold-chain requirement is a hard constraint for field deployment, and lyophilised furimazine stability at ambient temperature is the least-characterised part of the reagent stack **[unresolved]**.

## 7. What this design does not settle

Signal magnitude, dynamic range, limit of detection, dose–response linearity, and background are **thermodynamic and kinetic quantities**. No computational method establishes any of them. They come from the wet-lab screen, which is why the switch constructs plus their control set are the deliverable and this format is the thing they are built *for*.

The cost per test has not been estimated. A back-of-envelope calculation belongs in the appendix before any affordability claim is made.

## 8. How this maps to the provisional TPP

| TPP requirement | How this design meets it |
|---|---|
| Homogeneous, ≤ 30 min | One addition, no washes; luminescence develops in minutes |
| Camera-only, no potentiostat | Bioluminescence needs no excitation source or filter |
| ≤ 50 µL fingerstick | Single-tube format |
| No cold chain | Lyophilised reagents — **stability unresolved** |
| Quantitative precision (CV ≤ 25%) | Ratiometric dual-colour readout; **the hook effect is the main threat** |
| DENV1–4 coverage, ZIKV discrimination | Property of the binders, not the format — verified per-position against the alignment |

**The honest summary sentence for the report:** the format follows directly from the architecture and requires no component that does not already exist; what it requires is that the switch constructs work, which is exactly what has not yet been tested.
