# NorieLearning quiz outro requirements

Status: Implementation authorized by the user on 2026-10-02; optional five-question mistake drill remains deferred.
Recorded from the user's brief and additions on 2026-10-02.

The intended feature is one reusable result experience for every quiz and practice flow. Its purpose is to help learners understand their performance and choose a useful next step. Preserve current progression, grade restrictions, offline behavior, and the full-body frame-based Norie mascot.

## Additional learning priorities

- Offer review of only incorrect questions without requiring a full retake. Include the learner's answer, correct answer, explanation, and relevant concept.
- Show improvement over the previous attempt, such as 65% to 85%, using real recorded results.
- Praise meaningful improvement as well as high scores and perfection.
- Recommend only one or two priority concepts to review.
- Reserve a distinct perfect-score Norie animation for a special, rare reward. The precise repeat or frequency policy remains to be decided before implementation.
- Match Norie's expression to the result while staying supportive. Never show anger or disappointment at a low score.
- For weak scores, use a study or coach animation pointing toward Review Lesson.
- Keep Grade 1 and 2 results extremely visual and short. Introduce more useful analytics gradually for older grades.
- Later optional feature: a five-question mistake drill generated exclusively from concepts the learner missed. This is deferred, not part of an authorized implementation. Existing grade restrictions still apply.

## Integration requirements

Use percentage-based centralized tiers; short, accessible result reveals; real concept-based feedback; and context-appropriate review, retry, and continue actions. Integrate existing XP and mastery rules with rewards applied once. Use the planned global audio system for completion sounds and music ducking. Respect reduced motion, mute, text scaling, and supported haptics. A high score alone must not be presented as permanent mastery.

Before any future implementation, inspect all completion paths and the existing progression, mascot, audio, and accessibility hooks, then propose an architecture grounded in the repository. This note does not authorize code changes, new assets, commits, or deployment.

## Full user supplied brief

The following source brief is retained verbatim. Its implementation language is subject to the user's explicit instruction to store the idea and not implement yet.

NORIELEARNING — GLOBAL DYNAMIC QUIZ OUTRO / RESULT POP-UP

Implement a reusable animated quiz-completion experience that applies to EVERY quiz/practice system in NorieLearning.

This includes:
- pre-generated curriculum quizzes
- lesson quizzes
- AI-generated quizzes
- Anatomy quizzes
- identification quizzes
- multiple-choice quizzes
- matching
- ordering
- active recall
- challenges
- future quiz types

Do NOT create independent outro logic for every screen.

Build ONE reusable quiz-result/outro system and connect all quiz flows to it.

==================================================
1. PRIMARY UX GOAL
==================================================

When a learner finishes a quiz, do not immediately dump them onto a plain score screen.

Show a polished animated result pop-up/outro first.

The experience should:

1. recognize completion;
2. show the score clearly;
3. react differently based on performance;
4. show Norie reacting with an appropriate full-body 2D animation;
5. award/display XP;
6. identify strengths;
7. identify concepts that need review;
8. provide useful next actions.

It must feel encouraging but not fake.

Do not display the same message every time.

==================================================
2. SCORE MUST BE PERCENTAGE-BASED
==================================================

Quizzes can have different item counts.

Never hardcode logic such as:
"18 correct = excellent"

Use:

accuracy = correctAnswers / totalQuestions

Example:

9/10 = 90%
18/20 = 90%
27/30 = 90%

These should produce the same performance tier.

Handle edge cases:
- zero items
- cancelled/incomplete quizzes
- perfect score
- retries

==================================================
3. PERFORMANCE TIERS
==================================================

Use approximately these tiers:

PERFECT
100%

EXCELLENT
90–99%

GREAT
80–89%

GOOD PROGRESS
70–79%

KEEP PRACTICING
50–69%

REVIEW RECOMMENDED
below 50%

Keep threshold definitions centralized so they can be tuned later.

Do not scatter score thresholds across UI code.

==================================================
4. DYNAMIC MESSAGE POOLS
==================================================

Each performance tier must have several possible messages.

Do not always show identical text.

Example:

100% pool:
"Perfect run! You got every item right! 🌟"
"Outstanding! Nothing got past you this time. 🏆"
"Full marks! You really know this lesson. ✨"
"100%! Norie is impressed! 🚀"

90–99% pool:
"Excellent work! You're very close to complete mastery. 🌟"
"That was a strong performance! 💫"
"Great job! Just a tiny bit more practice can make this perfect."

80–89%:
"Great work! You understand most of the lesson. 🎯"
"Strong progress! Let's polish the few ideas you missed."
"Nice job! Your understanding is getting stronger. ⭐"

70–79%:
"Good progress! You have the main idea. 👍"
"You're getting there! A quick review will help."
"Nice effort! Let's strengthen the parts that were tricky. 🧠"

50–69%:
"Good try! Let's review the tricky parts together. 📚"
"You've started building the skill. A little more practice will help. 💪"
"Some ideas are clicking already. Let's work on the rest."

Below 50%:
"Let's review this lesson and try again. 🌱"
"This topic needs another look—and that's what practice is for."
"Norie found a few concepts we can strengthen together. 📖"

Do not use insulting, humiliating, or discouraging language.

Never use:
"Terrible"
"Failed badly"
"You're bad at this"
"Too many mistakes"

==================================================
5. GRADE-AWARE LANGUAGE
==================================================

Grade 1–2:
- shorter messages
- more visual feedback
- slightly more emojis
- very simple vocabulary

Example:
"Great job! 🌟 You got 8 out of 10!"

Older grades:
- progressively more mature wording
- fewer emojis
- more useful performance analysis

College:
keep visual polish but use professional language.

==================================================
6. NORIE MASCOT REACTION
==================================================

Norie must be a major part of the result screen.

Use the CURRENT full-body frame-based mascot architecture.

DO NOT reintroduce:
- clipped arms
- segmented body
- warped PNG pieces
- independent limb deformation

Target animation:
20–30 FPS
25 FPS default is acceptable.

Every frame should be a complete Norie drawing.

==================================================
7. NORIE RESULT ANIMATION STATES
==================================================

Create appropriate result animation sequences.

100% — SUPER CELEBRATION

Suggested sequence:
neutral
→ eyes widen
→ happy expression
→ small anticipation crouch
→ jump upward
→ arms raised
→ sparkle/confetti frame
→ happy landing
→ celebratory hold
→ gentle idle loop

Emotion:
extremely happy / proud

Do not copy another copyrighted character or animation exactly.
Use Norie's own design and personality.

--------------------------------------------------

90–99% — CELEBRATION

Norie:
- excited smile
- arms raised
- small bounce
- sparkle gesture

--------------------------------------------------

80–89% — HAPPY APPROVAL

Norie:
- smile
- thumbs-up / positive gesture
- small bounce

--------------------------------------------------

70–79% — ENCOURAGING

Norie:
- friendly smile
- nod
- guiding gesture

--------------------------------------------------

50–69% — COACHING

Norie:
- thoughtful expression
- encouraging point toward review button
- gentle nod

Not sad or disappointed.

--------------------------------------------------

Below 50% — SUPPORTIVE STUDY MODE

Norie:
- thinking/studying pose
- opens book/tablet
- points toward "Review Lesson"
- encouraging expression

Do NOT make Norie visibly angry or disappointed with the learner.

==================================================
8. RESULT POP-UP LAYOUT
==================================================

Recommended hierarchy:

[animated Norie]

      "Excellent Work! 🌟"

             18 / 20

              90%

        +360 XP earned

────────────────

Strongest area
✅ Living vs Nonliving Classification

Review this
📚 Characteristics of Living Things

────────────────

[Review Mistakes]
[Try Again]
[Continue]

The layout must scale properly on phones.

Use the existing Norie visual language:
- dark navy surface
- cyan/violet accents
- rounded corners
- subtle glow
- animated score reveal

==================================================
9. SCORE REVEAL ANIMATION
==================================================

Do not instantly display everything simultaneously.

Suggested sequence:

Quiz finishes
→ brief 150–300 ms pause
→ result panel scales/fades in
→ Norie animation starts
→ score counts upward
→ percentage appears
→ stars/particles appear
→ XP count animates upward
→ performance feedback appears
→ buttons become available

Keep total sequence relatively short.

Target:
about 1.5–2.5 seconds before full interaction.

Do not force a 10-second animation.

User must be able to proceed quickly.

==================================================
10. CELEBRATION EFFECTS
==================================================

Use intensity based on result tier.

100%:
- stronger confetti
- stars
- glow
- brighter particle burst

90–99%:
- moderate confetti/sparkles

80–89%:
- smaller sparkle burst

70–79%:
- subtle positive glow

Below 70%:
- no failure-style effects
- use calm supportive visual treatment

Avoid overloading low-end devices.

Respect reduced-motion settings.

==================================================
11. EMOJI USE
==================================================

Use emojis meaningfully but not excessively.

Possible result symbols:

🌟 excellent
🏆 perfect/mastery
✨ celebration
🎯 accuracy
🧠 understanding
📚 review
💪 practice
🌱 improvement
✅ strength
🔁 retry
🚀 continue
⭐ XP/reward

Grade 1–2 can use them more often.

Older students should see fewer.

==================================================
12. SCORE DETAILS
==================================================

Show at minimum:

correct / total

percentage

Example:

18 / 20
90%

Optionally show:
- XP earned
- mastery progress

Do not overload the first result view with analytics.

==================================================
13. DOMAIN-AWARE FEEDBACK
==================================================

This is VERY IMPORTANT.

Feedback must depend on the actual questions answered.

Do not show fake generic statements like:

"You need to work on Science."

Analyze question metadata/categories/concepts.

Example:

Quiz:
Living & Nonliving Things

Learner correctly answered:
- living classification
- nonliving classification
- basic needs

Learner missed:
- growth
- responding to environment

Result:

Strongest:
✅ Classifying living and nonliving things

Review:
📚 Growth and environmental responses

For Mathematics:

Strongest:
✅ Counting forward

Review:
📚 Number-before/number-after questions

For Anatomy:

Strongest:
✅ Upper-limb bones

Review:
📚 Lower-leg bones

The result should help learning, not only display a number.

==================================================
14. QUESTION METADATA
==================================================

If the current quiz model lacks concept tags, introduce a lightweight backward-compatible system.

Example:

conceptId:
"living-growth"

conceptLabel:
"Growth and Development"

or equivalent.

Questions may optionally carry:
- topic
- subtopic
- concept ID
- skill ID

Use this to determine strengths and review recommendations.

Do not break old serialized quiz data.

Fields should be optional/backward-compatible.

==================================================
15. MISSED QUESTION REVIEW
==================================================

Add:

"Review Mistakes"

This opens a review screen or sheet containing only incorrect items.

For each missed question show:
- original question
- learner's answer
- correct answer
- explanation
- relevant concept

Example:

❌ Your answer:
Rock

✅ Correct answer:
Plant

Why:
Plants carry out life processes such as growth and resource use.

Do not require the learner to retake all 20 questions just to understand errors.

==================================================
16. RETRY BEHAVIOR
==================================================

Add:

"Try Again"

For pre-generated quizzes:
- shuffle questions/options where appropriate;
- preserve domain;
- avoid obvious memorization from identical ordering.

For AI-generated quizzes:
- preferably generate/use another valid question set where architecture allows.

For identification:
keep one-word-answer rules.

Grade 1–2:
retry remains multiple choice only.

==================================================
17. CONTINUE BUTTON
==================================================

"Continue" should return the learner to the appropriate context.

Examples:
lesson quiz
→ lesson/topic progression

Anatomy quiz
→ Anatomy Lab

challenge
→ challenge/progression result

subject quiz
→ subject hub

Do not make every result Continue button blindly pop to the home screen.

==================================================
18. NEXT-STEP RECOMMENDATION
==================================================

Optionally show one concise recommendation.

Perfect:
"Ready for the next lesson 🚀"

90%:
"You're ready to continue, or review your one missed concept."

70%:
"A quick review before the next lesson is recommended."

Low score:
"Review the lesson, then try again."

Do not block progress solely because of one low quiz unless an existing mastery rule explicitly requires it.

==================================================
19. XP / REWARD INTEGRATION
==================================================

Integrate existing progression rather than creating a separate reward database.

The result panel may animate:

+240 XP ⭐

If perfect:
optional perfect bonus.

Possible future bonuses:
- perfect quiz
- first attempt
- streak
- mastery

Do not double-award XP because the result widget rebuilds.

Reward application must be idempotent.

==================================================
20. AUDIO INTEGRATION
==================================================

Use the global Norie audio system.

Quiz completes
→ music ducks

Depending on score:

100%:
strong celebration/chime

90–99:
celebration SFX

80–89:
positive completion SFX

70–79:
normal completion sound

Below:
gentle supportive completion sound

Never use harsh failure buzzers.

Correct/wrong item SFX already happen during the quiz.
The result outro should use a separate completion/reward sound.

==================================================
21. HAPTICS
==================================================

Where supported:

100%:
light celebratory haptic pattern

Successful completion:
small positive haptic

Do NOT use harsh vibration for low scores.

Respect platform accessibility/preferences.

==================================================
22. DYNAMIC CONTENT — NOT ALWAYS IDENTICAL
==================================================

The outro content should be assembled from:

- grade level
- quiz type
- score percentage
- correct/incorrect counts
- lesson/topic
- concept performance
- first attempt vs retry
- mastery status
- XP/rewards
- optional streak

Avoid hardcoded one-screen copy.

Use reusable result data such as:

QuizResultSummary

Possible fields:

correctCount
totalCount
accuracy
performanceTier
xpEarned
strongConcepts
reviewConcepts
quizType
topicTitle
gradeLevel
isPerfect
attemptNumber

Use an equivalent clean architecture if better.

==================================================
23. PERFORMANCE-TIER CONTENT POOLS
==================================================

Keep multiple messages per tier.

Select one appropriately so repeated quizzes feel less robotic.

The selection can be deterministic/randomized safely.

Do not change the actual academic feedback randomly.

Only the celebratory wording may vary.

==================================================
24. RESULT HISTORY
==================================================

Recommended future-ready architecture:

Store enough information to later support:
- best score
- latest score
- attempts
- mastery
- improvement

Example result message:

"New best score! 🎉
Previous: 75%
Now: 90%"

This is highly effective because it rewards improvement, not only perfection.

If progression/history already supports this, integrate it.

If not, make the result model extensible without implementing a huge analytics system immediately.

==================================================
25. EFFECTIVENESS FEATURE: IMPROVEMENT PRAISE
==================================================

Do not praise only high scores.

If a learner improves substantially:

previous attempt: 45%
new attempt: 70%

show:

"Big improvement! 🌱
You improved by 25 percentage points."

This can be more motivating than simply saying "70%."

==================================================
26. EFFECTIVENESS FEATURE: ONE FOCUS AREA
==================================================

Never overwhelm the learner with:

"You got 9 concepts wrong."

Choose the most useful 1–2 review areas.

Example:

"Focus next:
📚 Plant responses"

rather than a giant weakness list.

==================================================
27. EFFECTIVENESS FEATURE: PERFECT-SCORE SPECIAL MOMENT
==================================================

100% should feel meaningfully special.

Use:
- unique Norie celebration sequence
- special confetti
- brighter border/glow
- perfect-run badge/icon
- distinct SFX
- optional bonus XP

But keep animation short.

Possible copy:

"PERFECT! 🏆"
"20 / 20"
"Every answer was correct."

==================================================
28. EFFECTIVENESS FEATURE: MASTERY DISTINCTION
==================================================

Do not necessarily equate one high score with permanent mastery.

If mastery tracking exists, differentiate:

"Great score"
vs
"Mastered"

Example:

Score 95%, first attempt:
"Excellent result 🌟"

After repeated strong performance:
"Topic Mastered 🏆"

Use existing mastery rules if available.

==================================================
29. EFFECTIVENESS FEATURE: FIRST-TRY RECOGNITION
==================================================

Optional:

If learner scores very high on first attempt:

"First-try excellence! ✨"

Do not overuse this.

==================================================
30. EFFECTIVENESS FEATURE: STREAK INTEGRATION
==================================================

If current progression supports learning streaks:

"🔥 3 quizzes completed today"

or equivalent.

Do not create fake streak data.

Only display real tracked values.

==================================================
31. RESULT POP-UP VS FULL RESULT SCREEN
==================================================

Recommended:

First:
animated modal/pop-up outro

Then:
buttons allow review/details.

This gives immediate emotional feedback.

If "Review Mistakes" is selected:
open a fuller result/review screen.

Do not force every learner through a huge analytics screen after every five-question activity.

==================================================
32. SMALL QUIZ HANDLING
==================================================

Some quizzes may contain only 3–5 items.

Percentage alone can exaggerate small differences.

Still display:
correct / total

Example:

4 / 5
80%

Keep performance messaging sensible.

Do not show excessively negative messaging because a learner missed 2 of 3 items.

==================================================
33. ANATOMY QUIZ SPECIALIZATION
==================================================

For Anatomy quizzes, the outro can include domain-specific feedback.

Example:

"Norie noticed you're strongest at:
🦴 Upper body structures"

"Review:
🦵 Lower-leg bones"

Potential future visual:
small highlighted body-region diagram showing strong/review areas.

Do not block the initial implementation on this advanced visual.

==================================================
34. YOUNGER-LEARNER OUTRO
==================================================

Grade 1–2 result UI should prioritize:

- large score
- Norie
- big expression
- emojis
- clear buttons
- short feedback

Example:

🌟 Great job!

8 / 10

Norie says:
"You know most of this lesson! Let's check the two tricky ones. 🧠"

[See Mistakes]
[Continue]

Do not present dense analytics to a Grade 1 learner.

==================================================
35. OLDER-LEARNER OUTRO
==================================================

Grade 7+ can display slightly more structured information:

Accuracy 85%
17 / 20

Strong:
Linear equations

Review:
Translating word problems

+340 XP

Still keep the presentation clean.

==================================================
36. ACCESSIBILITY
==================================================

Respect:
- reduced motion
- sound disabled
- haptic availability
- text scaling

When reduced motion is enabled:
- use a static appropriate Norie pose
- no heavy confetti
- fade results in simply

All information must remain understandable without animation, SFX, or emoji.

==================================================
37. DO NOT DUPLICATE RESULT SYSTEMS
==================================================

Before coding:

search the repository for:
- result screens
- score screens
- learning_results
- quiz completion handlers
- challenge completion
- Anatomy results
- AI quiz results
- pre-generated quiz results

Consolidate carefully.

Create a common reusable result/outro component/controller.

Do not rewrite unrelated quiz logic unnecessarily.

==================================================
38. TESTING REQUIREMENTS
==================================================

Add tests for:

- correct percentage calculation
- zero-item handling
- tier calculation
- 100% tier
- high/medium/low tiers
- different item counts produce correct percentage
- dynamic message pool returns valid message
- concept strength calculation
- concept review calculation
- correct CTA destination/context
- retry handling
- XP awarded once only
- reduced-motion variant
- Grade 1–2 result simplification
- result does not trigger multiple celebrations from rebuild
- global quiz flows invoke the result system

Run:

flutter analyze
flutter test

Also build:
web
Android where applicable

==================================================
39. VISUAL QUALITY
==================================================

Make this a polished NorieLearning feature.

Use:
- existing dark navy design
- cyan / violet / green / gold accents depending on result
- tasteful gradients
- glow
- rounded modal
- subtle scale/fade
- full-body Norie frame animation

Avoid:
- generic AlertDialog appearance
- giant plain white score card
- copied Duolingo/Gizmo/game result UI
- excessive flashing
- overlong forced animation

Use NorieLearning's own identity.

==================================================
40. IMPLEMENTATION WORKFLOW
==================================================

Before coding:

1. inspect ALL current quiz result/completion paths;
2. identify reusable common data;
3. identify current progression/XP APIs;
4. identify mascot animation hooks;
5. identify audio hooks;
6. identify reduced-motion handling;
7. propose the concise architecture.

Then implement from CURRENT develop.

Use a feature branch.

Open a PR into develop.

Do not merge to main.

Report:
- quiz systems integrated
- score tiers
- Norie animations implemented
- result analytics implemented
- SFX/haptic integration
- tests
- CI
- anything remaining.