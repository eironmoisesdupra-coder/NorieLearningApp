# Priority 1 — PR #65: 5-credit Anatomy hints

## Scope
Existing PR #65 branch `feat/anatomy-atlas-credit-hints`; complete it rather than start an overlapping replacement. Applicable to requested 20-item Anatomy Atlas quizzes; shorter sessions should retain their documented behavior unless approved otherwise.

## Pedagogy / content
- Each question must be bound to `target.id`, `target.reference`, question kind, available answer options and exact selected modeled part (not loosely matched on `name`).
- Hints should assist identification: vetted orientation, shape, anatomical neighbors, classification, or gentle visual cues. Do NOT simply say the structure name, synonym, initial letters, unique exact attribute that only one option matches trivially, or copy option text.
- Fun fact must be accurate, concise, appropriate for age, sourced/approved, useful and not a direct answer. It may be about the targeted part only if it does not leak the tested identity; in ambiguous cases use an option-neutral comparison cue or decline to sell.
- Do not repurpose `AnatomyCatalog` coarse descriptions as universally medically validated per-model annotations. Source catalog isn't qualified editorial signoff. Provide bounded authoring records with `structureId`, `reference`, `questionKind`, claim text, source edition and independently verified review version.
- Until approved records exist, do not invent/auto-generate 3,949 facts. Display 'specific hint unavailable' with zero charge.
- Confirm actual model target and highlighted geometry match the intended structure; no stale model reuse, cross-reference mismatch or mislabeled visual. A user must be able to see the relevant part; label on result must be identical to question's catalog binding.

## Transaction integrity
- Before spending, check hint availability and learner generation; enforce one debit of 5 credits per unique quiz attempt/question index, with stable IDs and durable idempotency if necessary for restart/retry semantics.
- Verify available balance or an approved server-funded spending reservation; do NOT assume displayed `credits` implies spend authority. Reject negative balance, expired allowance, offline account restrictions and stale sessions.
- Double-click/multi-device/restart safety: no duplicate charge; no reveal on failed charge; paid hint may be re-shown without extra charge; no negative credit balance. If a purchase is pending/uncertain, show pending state rather than claiming success.
- Do not charge after checked answer; answer explanations are free.
- Hint show/hide/scrolling never changes quiz score, independent mastery, learning rewards or number of questions.
- Hints are optional; 20-item sessions must remain doable without credits.
- Accessibility: label 'Hint costs 5 credits', explicit balance change, no forced popups. Test narrow screen and screen readers.

## Required tests
1. 20-item Guided/Standard/Challenge; 5/10 unchanged.
2. For every tested question, visual rendered 3D highlight matches target.id/reference and correct answer. Include case where similar left/right labels and duplicate names across references exist.
3. Specific informative hint + approved fun fact that does NOT reveal answer or option; unsupported part disabled with zero spending.
4. 0, 4, 5, 10 credits; first click, double click, hide/reopen, next question, back/retry, insufficient funds; exact debit once.
5. Signed-in server reservation, pending/failed spend, guest spending, account switch A→B→A.
6. Wrong/correct scoring, 200 XP max at 20/20 in legacy scoring mode, no duplicate reward claim, altered hint state doesn't alter score.
7. Context recovery/reload/rotation while hint shown and viewer rendering.
8. Full tests/CI + actual rendered phone QA.

## Merge criteria
No P1/P2 bugs, all required green CI, verified UI and credit transactions, truthful limitation for missing human-approved medical fact bank. If a safe source-based part fact is unavailable, disable paid reveal (do not charge for generic text).
