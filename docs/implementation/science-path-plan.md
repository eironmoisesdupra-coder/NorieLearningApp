# Complete the existing Science path

Approved scope: preserve Grade 1's five approved lessons; replace the 60 starter lessons from Grade 2 through College. This is a curated five-lesson-per-grade path, not a claim of comprehensive coverage of each school curriculum or university course.

Authority: `docs/ideas/science-curriculum-completion-pipeline.txt` and the user's instruction to complete the existing 65-lesson path. Existing IDs, titles, lesson ordering, rewards and prerequisites stay stable. Unrelated dirty files in the main checkout are excluded; work is isolated on `feat/complete-science-path` from current develop.

## Implementation sequence

1. Add small content assembly helpers and accessible local diagram primitives, alongside reusable curriculum validation. Extend the existing lesson models, never replace them. Restrict Grade 2's mode picker to MC; ensure Science identification only accepts eligible single-word answers and practice respects difficulty tiers.
2. Complete Grade 2: Life Cycles; Habitats; States of Matter; Light & Sound; Earth & Sky.
3. Complete Grade 3: Plant Parts; Animal Adaptations; Matter & Changes; Force & Motion; Weather Patterns.
4. Complete Grade 4: Ecosystems; Human Body Systems; Energy; Rocks & Minerals; Earth, Moon & Sun.
5. Complete Grade 5: Cells Introduction; Food Webs; Properties of Matter; Simple Machines; Water Cycle.
6. Complete Grade 6: Organisms & Classification; Mixtures & Solutions; Electricity; Plate Tectonics; Solar System.
7. Complete Grade 7: Scientific Investigation; Cells & Microscopy; Matter & Particles; Force & Motion; Earth Systems.
8. Complete Grade 8: Genetics Basics; Chemical Reactions; Work & Energy; Waves; Weather & Climate.
9. Complete Grade 9: Biology Foundations; Atomic Structure; Chemical Bonding; Motion & Forces; Plate Tectonics.
10. Complete Grade 10: Evolution; Periodic Table; Acids & Bases; Electricity & Magnetism; Ecosystems.
11. Complete Grade 11: Cell Biology; Stoichiometry; Mechanics; Earth Materials; Scientific Data Analysis.
12. Complete Grade 12: Genetics & Molecular Biology; Chemical Equilibrium; Electric Fields; Geologic Processes; Ecology.
13. Complete College: General Biology; General Chemistry; University Physics; Earth Science; Scientific Research.
14. Full factual/code review, analysis/tests, web and Android/Windows build validation, PR into develop, CI and web preview, platform download links.

## Per-lesson acceptance

Individually authored grade-appropriate content: 3–5 measurable objectives, time estimate, hook, substantive core explanations, vocabulary in context, meaningful local diagrams, worked and guided examples, practical observation/activity, misconception corrections, quick check with reveal, recap and key concept. At least 20 practice questions (exactly 7 foundation, 7 intermediate, 6 application) and 3 independent mastery questions; only concepts explicitly taught; four plausible options, exactly one answer and useful feedback. Grade 2 is MC only. Higher grades may offer identification only for academically appropriate one-word answers. Do not generate shallow noun-swapped templates.

Author and validate lessons individually. Independently review each grade's science and its progression before acceptance. Tests check identifiers, completeness, visual resolution, answer validity, duplicates, grade/mode policy and small-screen rendering; semantic review remains necessary beyond counts. Use reliable scientific sources when a claim needs verification. Sources and authored diagrams remain local/offline at runtime.

## Architecture contract

Each grade lives in `lib/features/content/data/science/grade_<n>_science.dart` (college uses `grade_college_science.dart`) exporting `List<NorieTopicContent> gradeNScienceTopics` and `Map<String, ScienceFigure> gradeNScienceFigures` (college prefix `gradeCollege`). Shared assembly uses `science_lesson_builder.dart`, shared diagram data uses `science_figure.dart`, and a registry routes grades/figures. Grade files import those helpers and existing content models. No backend or AI generation dependency.

From Grade 9 onward, a grade may import an independently authored lesson module to allow content and diagram work to proceed without editing the same files. The grade entry point still exports the complete five-topic sequence and figure map. Independent review and grade acceptance cover every imported lesson before the next grade is accepted.

## Review focus

Stable IDs/prerequisites and Grade 1 fixture preservation; ambiguous MC options or untaught facts; numerical units/keys; repeated generic paragraphs; false simplification at younger grades; misleading diagram arrows/scales; small-phone overflow; typed multiword answers; repeat XP; accidental inclusion of unrelated local changes.

## Checkpoints

One focused commit per accepted grade pack, with its content/visual tests. Full suite and relevant builds at release; targeted checks after each pack. No requirement to ask again between grades.
