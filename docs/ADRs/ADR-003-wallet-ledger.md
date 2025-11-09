# ADR-003: Wallet Ledger with Immutable Entries

## Context

Users purchase calling credit via Stripe and consume minutes in real time. The system must support reversals, auditing, and regulatory reporting. Directly mutating balance totals risks drift when webhooks replay or calls are re-rated.

## Decision

Represent each wallet action as an immutable `WalletEntry` document. Credit and debit operations append entries inside a reactive Mongo transaction and derive the `Wallet.balanceCents` as the running total. Reservation and release flows write distinct entries (`CALL_RESERVE`, `CALL_RELEASE`), enabling full traceability. The ledger doubles as a monotonically increasing audit log for compliance exports.

## Consequences

* ✅ Auditable ledger with idempotent Stripe webhooks and call rating adjustments.
* ✅ Easy reconciliation by replaying entries to compute balance.
* ⚠️ Requires compound indexes for query performance and retention policies for long-running accounts.
* ⚠️ Engineering must enforce transactional correctness when updating wallet + entry pair.
