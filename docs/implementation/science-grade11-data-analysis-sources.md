# Grade 11 Scientific Data Analysis: verification and original models

Checked 2026-10-04. The lesson and vectors are original; all example datasets are invented for instruction. No remote source is needed at runtime.

- [NIST, Measurement uncertainty](https://www.nist.gov/glossary-term/39291): uncertainty may include systematic-effect contributions as well as dispersion from repeated readings. A numerical uncertainty needs its interpretation stated.
- [NIST TN 1297, Appendix D1: Terminology](https://www.nist.gov/pml/nist-technical-note-1297/nist-tn-1297-appendix-d1-terminology): precision/repeatability differs from accuracy; averaging repeat measurements does not establish absence of systematic error. Avoid treating every standard deviation or range as the complete uncertainty of a measurement.
- [NIST TN 1297, Appendix D4: measurement methods and calibration](https://www.nist.gov/pml/nist-technical-note-1297/nist-tn-1297-appendix-d4-measurand-defined-measurement-method): calibration and method implementation contribute alongside repeatability. The classroom half-range convention is explicitly a limited descriptive summary, not a NIST uncertainty budget or confidence interval.
- [NIST Engineering Statistics Handbook, Initial Linear Fit](https://www.itl.nist.gov/div898/handbook/pmd/section6/pmd623.htm): inspecting residual structure helps evaluate a fitted line; a fit alone is insufficient model validation.

Scope: Grade 11 builds on earlier graph reading with instrument resolution versus accuracy, independent samples versus repeat readings, relative uncertainty, a nonzero intercept, dimensional slope, residuals, prediction limits and confounding. Standard deviation, standard error, confidence intervals and significance tests are named only to distinguish them from the supplied summaries, not calculated or inferred from range overlap.

Numerical/visual audit:

- A = [9,10,11] s and B = [6,10,14] s: both mean 10 s, ranges 2 and 8 s. Dots share a 0–16 s scale. Amber diamonds mark means without hiding observations.
- P = [9,10,11] s and Q = [10,11,12] s: means 10 and 11 s; drawn min–max intervals [9,11] and [10,12] s overlap on [10,11] s. Bars explicitly are observed ranges, not confidence intervals.
- Position model x = 2 + 2t: displayed pairs (0,2),(1,4),(2,6),(3,8), axes 0–3 s and 0–10 m. Triangle run 3 s and rise 6 m give 2 m/s. Observation 6.3 m at 2 s has residual +0.3 m.
- Half-range exercise [18,20,22] cm gives mean 20 cm, range 4 cm, half-range 2 cm and relative uncertainty 10%. Mastery [28,30,32] s gives 30 ± 2 s under the named convention. Mastery slope (17−5)/(4−1) = 4 m/s.

Companion figures: membrane arrows distinguish channel-mediated passive transport from an ATP-driven pump; atom-count reaction conserves four H and two O; mechanics arrows use one force scale for 10 N right and 4 N left; rock textures show interlocking, cemented and aligned grains rather than decorative rock icons. The four companion lessons document their scientific sources in the grade source record. These are conceptual original vectors, not measured micrographs or molecular mechanisms. Tests generate seven separate 260px PNGs and check 244px labels at text scale 1.3 with semantic descriptions.
