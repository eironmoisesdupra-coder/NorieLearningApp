# NorieLearning Proper Lesson Blueprint

This blueprint defines the standard structure for production lessons across Mathematics, Science, and English from Grade 1 through College.

## 1. Lesson identity

Every lesson should include:
- clear lesson title;
- grade or level;
- subject;
- short subtitle describing the skill or concept;
- recommended prerequisite;
- estimated lesson time;
- 3–5 measurable learning objectives.

## 2. Opening explanation

Start with a readable introduction that answers:
- What is this idea?
- Why does it matter?
- Where will the learner use it?

The language should match the learner's grade level. Avoid filler text and generic study advice.

## 3. Concept teaching sections

A proper lesson should normally contain at least five instructional sections:

1. **Core idea** — introduce the concept in simple language.
2. **Visual model** — diagram, image, number model, process chart, labeled figure, or other relevant visual.
3. **Worked example** — show a full solution or process from start to finish.
4. **Guided strategy** — explain a second way to think about or check the idea.
5. **Common mistakes** — show likely misconceptions and how to correct them.

Longer or more advanced lessons may add vocabulary, proofs, derivations, real-world applications, or extension sections.

## 4. Step-by-step worked examples

Worked examples should:
- use numbered steps;
- explain why each step is performed;
- show the intermediate state, not only the final answer;
- include a check or verification when appropriate;
- use grade-appropriate notation.

For Mathematics, show the representation before the calculation whenever possible.
For Science, show the system/process before asking for interpretation.
For English, show the sentence/text before analyzing the language feature.

## 5. Visuals and diagrams

Every lesson must have at least one meaningful visual. Important lessons should have multiple visuals placed near the section they support.

Preferred order:
1. programmatic/offline Flutter diagrams for simple instructional visuals;
2. bundled local illustrations for richer artwork;
3. remote images only when they add educational value that cannot be reproduced locally.

Visuals must:
- teach something specific;
- have a clear caption;
- use large readable labels;
- remain understandable on a phone screen;
- avoid decorative-only images in the quiz;
- be available offline whenever practical.

## 6. Readability

Lessons should use:
- short paragraphs;
- one main idea per paragraph;
- clear headings;
- examples immediately after explanations;
- bold or visual emphasis only for key ideas;
- age-appropriate vocabulary.

Grade 1–3 lessons should rely heavily on concrete examples and visual models.
Higher grades can progressively introduce abstraction, formal notation, and longer explanations.

## 7. Key concept recap

End the tutorial with:
- one short title expressing the main rule or idea;
- one concise paragraph summarizing what the learner must remember.

This should be useful as a rapid-review card later.

## 8. Practice system

Each production lesson should include **20 lesson-specific practice items**.

Recommended distribution:
- 1–7: foundation recall and direct application;
- 8–14: mixed or intermediate application;
- 15–20: deeper reasoning, word problems, or transfer.

Questions must:
- test the actual lesson content;
- have a valid answer key;
- include a useful explanation;
- avoid generic study-habit questions;
- vary answer position when possible;
- avoid trick wording for younger learners.

## 9. Mastery challenge

Each lesson should include three short challenge items that:
- represent the most important skills in the lesson;
- can be solved without hints;
- provide immediate explanation after answering;
- award challenge XP.

## 10. Offline-first learning

Core lesson content should remain usable with poor connectivity.

Prioritize:
- local lesson data;
- programmatic diagrams;
- bundled assets;
- cached 3D models where applicable;
- no required remote image just to understand the lesson.

## 11. Quality checks before release

A proper lesson is release-ready only when:
- the title and prerequisite chain are correct;
- objectives match the content;
- instructional sections are substantive;
- worked examples are correct;
- visuals match the concept;
- all 20 questions have valid answers;
- explanations are accurate;
- the three challenge items are valid;
- mobile layout does not overflow;
- serialization/loading remains compatible;
- Flutter Analyze and tests pass.

## Grade 1 Mathematics reference pack

The first reference implementation uses:
1. Counting to 100
2. Place Value
3. Addition Basics
4. Subtraction Basics
5. Shapes & Patterns

Future foundation lessons should match or exceed the depth and structure of this pack.
