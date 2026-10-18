# Packet 04 ? guided learning and practice

The guided adapter displays the actual existing introduction, sections, visuals and recap. It does not manufacture an authored seven-stage lesson where the underlying editorial content lacks one. Guided practice uses existing question keys and alternatives, enables ordering only when the author provided ordered items, and keeps help sticky for a question across retries.

Rehearsal attempts are explicitly assisted or independent and do not update authoritative mastery or retention. Later retention requires a separate delayed assessment policy and is not inferred from immediate repeated success. Existing lesson completion and rewarded practice routes retain XP, credits and progression authority. A request for scaffolding does not change those reward values.

The typed numeric-with-unit and multi-select validators are available for explicitly authored items. Existing multiple-choice content is never guessed to be a numeric or multi-select item. Grade-specific explanation, worked solving and review remain editorial work where not authored.

Authored assessment metadata uses `assessments` (maximum 64 entries). Each item has `id`, `format`, `prompt`, and a real `explanation`. Supported formats: `numeric` (`answer`, explicit `unit`, nonnegative `tolerance`), `choice`/`multiSelect` (`options`, distinct integer `answers`), `text` (`accepted`) and `ordering` (`items`). Invalid keys block pack import. The editor preview exposes these formats; imported assessment items never become live learner tests through local staging.

An optional `flow` object supplies actual authored text for `discover`, `understand`, `worked_example`, `guided_try`, `independent_try`, `apply`, and `review`. Preview displays only supplied stages. Existing content uses its existing sections and diagrams. No unprovided stage is synthesized as editorial content.
