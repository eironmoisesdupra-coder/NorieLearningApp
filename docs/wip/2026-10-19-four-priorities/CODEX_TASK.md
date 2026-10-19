# STRICT CODEX INSTRUCTION — NORIELEARNING

1. Fetch latest `develop`; compare against the specified baseline. Before editing inspect affected files and relevant tests. Never blindly apply stale patches or run the old WIP installer.
2. First handle open PR #65: inspect its branch and CI, fix all defects, verify structural correctness of depicted Anatomy figure/model question, credit spending, hint content, and every edge case before considering merge. Do not create a competing PR for the same files.
3. Implement remaining priorities as separate PRs after dependency checks. Do not update production data or deploy migrations until authorized, reviewed, and tested. Preserve exact ownership and account versioning.
4. Run `dart format` on changed Dart files, `flutter analyze`, focused tests and full Flutter suite, Node/Python anatomy suites where affected, Flutter web release build and platform-specific packaged tests. CI success means implementation tested, not medically reviewed or hardware certified.
5. Run UI checks at 320px and 390px, 160% text, Reduced Motion, 5/10/20-question modes, account switch mid-operation, offline first start and graceful recovery. Screenshot real rendered UI and inspect for overlap.
6. Security: fail closed on uncertain payment balance, duplicated charge, stale account generation, unapproved curriculum, missing structure link, corrupt backup, unsigned publishing claim or unreviewed clinical wording.
7. Avoid arbitrary text-only 'fun facts' keyed from approximate names. For Anatomy content use explicit keyed vetted records + question-specific proof the hint does not reveal answer; otherwise disable paid hint and charge zero.
8. Ensure atomic outcomes: no partial credit debit with absent hint, no duplicate debit on retap, no partial backup restore, no authority upgrade from draft import, and no XP receipt duplication.
9. If a condition cannot be verified, leave it incomplete and report the concrete blocker. Never silently pass/skips.
10. Open reviewable PRs; do not merge until all required status checks pass, and do not publish without source/release parity checks. End with a roadmap checklist.
