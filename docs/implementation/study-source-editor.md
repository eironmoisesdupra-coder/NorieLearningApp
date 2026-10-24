# Source excerpt editor follow-up

Baseline developf30fce03f0929daf8e7e7e0e4804a215a3b49d67 contains the reviewed educational feature integrations. Source checking correctly refuses missing excerpts, but the card editor previously displayed retained excerpts read-only and offered no input for new cards. That left learners unable to repair missing or incorrect source text through the existing authoring flow.

The editor now initializes an excerpt field from the original card, retains its exact text on save and disposes its controller. Blank excerpts are still allowed for ungraded recall; they do not pass source comparison. Changes use the existing owner-scoped cache/sync path and existing source_excerpt field. The content fingerprint invalidates any prior comparison after a source edit. Entering a quote never grants learner comparison or qualified approval automatically. No grading scope, quiz contents, schema, permission, destination or rewards change.

Actual pre-fix widget test failed because no source input existed.27 source domain/cache/widget checks pass after the change; analysis and diff checks are clean. New tests exercise real creation/editing, exact text persistence, comparison invalidation and no self-approval. Independent read-only code review found no blocking issue. Current-head platform checks remain authoritative and pending until recorded in the PR.

Qualified truth/attribution of user-entered material remains human work. Anatomy approvals0 and pilot drafts30 are unchanged, paid hints stay disabled, and the separately documented graded Atlas cold-resume gap remains unresolved. This follow-up does not fulfill that recovery requirement or authorize publication.
