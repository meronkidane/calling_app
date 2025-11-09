# Runbooks

## Backend Incident Response

### Authentication outages
1. Check `/actuator/health` and `/actuator/metrics` for `jwt` or `mongo` errors.
2. Inspect logs filtered by `AuthController` for OTP failures.
3. If Redis/OTP store unavailable, toggle `APP_AUTH_SANDBOX=true` in dev to bypass (never in prod).
4. Re-deploy with rotated `JWT_SECRET` if compromise suspected; invalidate refresh tokens by redeploying with new secret.

### Wallet inconsistencies
1. Query Mongo `wallet_entries` by `userId` to verify ledger sums.
2. Recompute balance using aggregation pipeline:
   ```js
   db.wallet_entries.aggregate([
     { $match: { userId: "<id>" } },
     { $group: { _id: "$userId", balance: { $sum: "$amountCents" } } }
   ])
   ```
3. Compare with `wallet.balanceCents`. If mismatch, update wallet doc to aggregated total.
4. For disputed charges, append `WalletEntry` with `type=ADJUST` and reference.

### SIP call failures
1. Confirm Telnyx webhook delivery in dashboard.
2. Tail backend logs for `TelnyxWebhookService`.
3. Validate SIP registration from mobile: toggle verbose logging in `DialerScreen`.
4. If WebSocket blocked, ensure corporate firewall allows `wss://<sip-domain>:443`.

## Dev Environment

1. `docker compose -f infra/docker-compose.yaml up -d mongo1 mongo2 mongo-setup prometheus grafana zipkin`.
2. `./scripts/setup-gradle-wrapper.sh && ./backend/gradlew bootRun`.
3. Configure Grafana datasource (`http://prometheus:9090`) and import dashboard `docs/grafana/calls.json` (placeholder).
4. Run Flutter app with `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080`.
