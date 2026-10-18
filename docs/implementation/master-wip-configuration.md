# Master WIP configuration handoff

Owner decisions (2026-10-18): approve the supplied seven Shop credit prices; cloud Classroom is not configured and must remain offline with setup instructions. Past purchases and immutable receipts keep their original values. No payment or database migration is authorized by these decisions.

## Optional cloud Classroom — not enabled

File/LAN Classroom remains the supported assignment transport. Existing general account sync does not provide classroom authorization. No classroom outbox is attached to a remote endpoint, no private work is automatically uploaded, and no teacher role can be assigned locally.

Before an implementation can connect: choose the Supabase project and region; approve retention/deletion and guardian consent; provision server-managed teacher/reviewer roles, class memberships and expiring invitations; implement class-isolated RLS for every exposed table and ownership checks on insert/update; enforce assignment versions and server-recomputed reports; add idempotent submissions, durable owner-scoped outbox and acknowledgment protocol; test expired invites, revoked roles, cross-class access, replay, account switching, reconnect and migration. Never embed service-role keys or trust editable user metadata for roles.

Use the Supabase CLI to create a reviewed migration only after schema approval. Do not apply a migration to a production project merely to activate this screen. Test RLS with two teachers, two classes, nonmembers and revoked memberships before any pilot.

Sources: https://supabase.com/docs/guides/database/postgres/row-level-security and https://supabase.com/docs/guides/api/custom-claims-and-role-based-access-control-rbac (checked 2026-10-18).

## Membership and store

See memberships.md, production-signing.md, device-certification.md and store-ready.md. Owner has no production signing credentials, published privacy policy or support contact yet. Keep all downloads labeled Preview and all corresponding store/readiness.json gates pending. No checkout, paid entitlement, certification, or human editorial approval is simulated.

In-app Preview configuration lists these pending requirements without collecting secrets or providing false activation switches.
