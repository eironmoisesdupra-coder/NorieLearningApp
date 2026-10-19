# Three existing lesson enrichment pilots

Scope: three enriched canonical lessons; zero new catalog lessons. This record is an authoring and calculation audit, not qualified subject-expert approval. Human editorial review, review of screenshots and release verification remain acceptance work for the integration owner.

| Canonical lesson | Intended learner | Enrichment |
| --- | --- | --- |
| `science.g1.living-nonliving-things` | Grade 1 | Short observation, independent plant/toy explanation, separately revealed answer, two-clue rubric and next-day retrieval. Approved existing sentences, four interactive visuals and all 23 assessment items remain intact. |
| `mathematics.g7.proportions` | Grade 7 | Prerequisites, labeled rate table, explanation of why a proportion applies, legal equation steps, units, guided hints, transfer to a fixed fee and retrieval. Eight practice and three mastery item IDs remain stable. |
| `science.g11.mechanics` | Grade 11 | Explicit knowns/unknowns and assumptions, equation transformations, dimensional check, reasonableness, guided hints, independent loaded-cart comparison with reveal, error diagnosis and retrieval. Twenty practice and three mastery item IDs remain stable. |

The same existing lesson, single-select assessment, reveal-section and offline diagram renderers consume the content. No numeric-entry, ordering, matching or other unsupported authoring type is introduced. Text and existing local visual descriptions provide the instructional representations. No network connection, external picture or new package is required to learn or practice.

## Instructional review and answer audit

Grade 1 additions use familiar plant/toy comparisons and short sentences. Children may point, speak or draw their evidence. A complete response classifies both examples and gives two signs of life for the plant; movement alone is insufficient. The existing picture guide remains the visual reference. Neither color nor stillness is evidence by itself. The additive sections preserve the approved lesson rather than replacing it.

Grade 7 assumes fraction equivalence and multiplication/division. With a hypothetical fixed price and no fee, 5 notebooks cost 80 credits: `k = 80/5 = 16 credits/notebook`. Eight cost `16 × 8 = 128 credits`, between the five-notebook total 80 and ten-notebook total 160. An equivalent proportion is `80/5 = C/8`; multiplying both sides by 8 gives `C = 128`. Correct reasoning keeps credits/notebook in the same order on both sides. With an additional fixed 20-credit order fee, eight cost `20 + 16 × 8 = 148 credits`. Total cost is not directly proportional because zero notebooks still give a 20-credit charge in this model. The last mastery item now assesses this transfer instead of another bare fraction scaling item; its ID and mathematical objective remain unchanged. For written work, equivalent simplified fractions/decimals with the same value and correct units are accepted; the current in-app question asks the learner to select one supplied complete answer.

Grade 11 assumes signed vectors, algebra and SI units. The existing hypothetical cart has net force `(+10 − 4) N = +6 N`; `a = Fnet/m = +6 N/3 kg = +2 m/s²`. Under constant force and constant mass, `v = u + at = +8 m/s` and `s = ut + ½at² = +15 m` after 3 s from +2 m/s. `N/kg = m/s²`; each displacement term is in metres. Average velocity is +5 m/s, between +2 and +8; `5 × 3 = 15 m` independently checks displacement. Work also agrees: `6 N × 15 m = 90 J = ½ × 3 kg × (8² − 2²) m²/s²`.

The independent comparison uses another stated hypothetical scenario, not measured data: a total mass of 6 kg under the same +6 N net horizontal force, initially at +2 m/s, for 3 s. Acceleration is +1 m/s², final velocity +5 m/s, displacement +10.5 m. Doubling the constant mass halves acceleration; it does not halve final velocity because the initial velocity is nonzero. This is a comparison of separate constant-mass trials, not an object gaining mass during motion. Numerical values are exact teaching inputs; real measurements would require uncertainty and justified significant figures. Equivalent signed direction descriptions and units are acceptable in written work; no automatic free-text equivalence grader is claimed.

The first existing mechanics mastery problem retains its correct answer: for 2 kg, +7 N and −3 N, acceleration is +2 m/s² and velocity from rest after 4 s is +8 m/s. Its explanation adds a dimensional check and an independent average-velocity/displacement check. Other answer keys and all three lessons' completion XP, prerequisite links and assessment reward policies remain unchanged.

## Primary sources checked 2026-10-19

All added explanations and examples are original. These references support concepts; the learner does not need to open them, and no source image or quoted textbook passage is redistributed.

- [OpenStax Biology 2e, Themes and Concepts of Biology](https://openstax.org/books/biology-2e/pages/1-2-themes-and-concepts-of-biology): combined properties of life, growth and response. Adult reference language is simplified for Grade 1.
- [OpenStax Prealgebra 2e, Solve Proportions and their Applications](https://openstax.org/books/prealgebra-2e/pages/6-5-solve-proportions-and-their-applications): equivalent ratios, nonzero denominators, consistent unit order and operations on both sides.
- [OpenStax Physics, Newton's Second Law of Motion](https://openstax.org/books/physics/pages/4-3-newtons-second-law-of-motion): acceleration depends on net force and mass; SI force units.
- [OpenStax Physics, Representing Acceleration with Equations and Graphs](https://openstax.org/books/physics/pages/3-2-representing-acceleration-with-equations-and-graphs): constant-acceleration assumptions, known/unknown strategy and numerical checks.

Existing companion sources remain in [science-grade11-sources.md](science-grade11-sources.md). Existing original diagrams, attributions and licenses remain unchanged.

## Validation handoff

`test/four_priority_lesson_pilots_test.dart` is written before content changes. It checks stable progression/rewards and serialization, hand-derived applied answer keys and the new independent transfer. Its Grade 1 widget cases render the real lesson content at 320 × 640, at normal text size and at 160% text with reduced motion. They check that the reasoning appears only after requesting the reveal. The test explicitly settles layout, brings the interactive reveal tile into view and verifies it is hit-testable before tapping; merely building a tile beyond the viewport does not make it tappable. Existing `test/norie_grade1_science_test.dart` checks every approved sentence and four offline visual references.

The initial enrichment RED run had the expected three missing-content assertion failures and one passing preservation test. In the first combined GREEN attempt, all three data tests passed; the Grade 1 widget tap missed because its target center was below the viewport. This identified a test interaction problem, not evidence of a product reveal failure. The revised widget cases above require a real reachable tap; their rerun results remain the integration owner's responsibility.

SDK commands, full-suite checks, formatting, screenshots, builds and CI are owned by the integrating agent. Record actual results in the integration handoff; this document does not claim unrun checks passed. No publication authorization, content-expert certification, screenshot review or release promotion is implied by these automated checks.
