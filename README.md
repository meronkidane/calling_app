# International Calling Monorepo

This repository houses a production-ready international calling platform composed of:

- **Backend**: Java 21, Spring Boot 3, reactive MongoDB, RSocket, Stripe, Telnyx.
- **Mobile**: Flutter (Riverpod, go_router, Dio, flutter_sip_ua) targeting Android first.
- **UI**: Material design on Android, native Cupertino on iOS with localization for `en_US`, `am_ET`, and `ti_ER`.
- **Infra**: Docker Compose stack for Mongo replica set, Prometheus, Grafana, Zipkin (optional Asterisk SBC).
- **Docs**: OpenAPI spec, ADRs, runbooks, Postman collection, sequence diagrams.

## Repo layout

```
backend/        Reactive API + services
mobile/         Flutter client (Android-first)
infra/          Local infra (docker compose, monitoring)
docs/           Architecture docs, OpenAPI, ADRs
scripts/        Developer tooling + seed scripts
```

## Quickstart (local dev)

### Prerequisites

- JDK 21
- Docker + Docker Compose v2
- Flutter 3.24+ (stable channel)
- Android Studio (emulator) or physical device

### 1. Boot infra

```bash
docker compose -f infra/docker-compose.yaml up -d mongo1 mongo2 mongo-setup prometheus grafana zipkin
```

MongoDB replicaset will initialize automatically via the `mongo-setup` container.

### 2. Prepare Gradle wrapper

```bash
./scripts/setup-gradle-wrapper.sh
```

### 3. Run backend

```bash
cd backend
./gradlew bootRun
```

The API listens on `http://localhost:8080`. Swagger UI is available at `/swagger-ui.html`, and `/actuator/prometheus` exposes metrics.

### 4. Seed demo data (optional)

```bash
API_BASE=http://localhost:8080 ./scripts/seed/seed_dev_data.sh
```

### 5. Run Flutter app

Create platform scaffolding if necessary: `flutter create .` from `mobile/` (only required once for fresh clones).

```bash
cd mobile
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

On first run the OTP flow uses sandbox mode (`000000`). Register a SIP account via the dialer settings button to initiate Telnyx calls.

## Enabling Telnyx + Stripe

1. Provision Telnyx programmable voice:
   - Create credential connection + SIP domain.
   - Configure webhooks to `https://{public}/webhooks/voice`.
   - Update environment variables:
     ```
     export TELNYX_API_KEY=...
     export TELNYX_SIP_DOMAIN=yourdomain.telnyx.com
     ```
2. Stripe
   - Create test secret + webhook signing secret.
   - Update `STRIPE_SECRET_KEY` and `STRIPE_WEBHOOK_SECRET`.
   - Set `PUBLIC_BASE_URL` to your ngrok/Cloudflare tunnel for webhook testing.

## Configuration

Backend environment variables (`application.yml` shows defaults):

| Variable | Description |
| --- | --- |
| `JWT_SECRET` | HS256 secret for access/refresh tokens |
| `MONGO_URI` | Replica set connection string |
| `STRIPE_SECRET_KEY` | Stripe API key |
| `STRIPE_WEBHOOK_SECRET` | Stripe webhook signature secret |
| `TELNYX_API_KEY` | Telnyx API key (optional if using Asterisk) |
| `TELNYX_SIP_DOMAIN` | SIP domain for WebSocket registrations |
| `APP_AUTH_SANDBOX` | Enable static OTP (`000000`) for dev |

Flutter app uses `--dart-define=API_BASE_URL=<url>` and secure storage for tokens.

## Testing

Backend:

```bash
cd backend
./gradlew test
```

- `CallRatingServiceTest` covers pricing math.
- Testcontainers profiles (Mongo) can be enabled later for integration suites.

Flutter:

```bash
cd mobile
flutter test
```

Run `flutter pub run build_runner build --delete-conflicting-outputs` after editing Freezed models.

## Observability

- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000 (admin/admin)
  - Add Prometheus datasource (`http://prometheus:9090`) and import dashboards.
- Zipkin: http://localhost:9411

Custom metrics exposed:
- `call_attempts_total`
- `call_connects_total`
- `cdr_write_latency`
- `wallet_topup_value`

## CI/CD

GitHub Actions workflow (`.github/workflows/ci.yml`) runs:
- Backend build & tests
- Flutter analyzer & tests
- Docker image build (backend)

## Documentation

- `docs/openapi.yaml`: API contract
- `docs/postman_collection.json`: Postman collection
- `docs/ADRs`: architectural decisions
- `docs/sequence-diagrams/outbound-call.puml`: call flow
- `docs/runbooks.md`: operational runbooks
- `docs/README.md`: step-by-step setup guide and Jekyll docs portal (`bundle exec jekyll serve`)

## Troubleshooting

| Issue | Fix |
| --- | --- |
| Mongo replica set not primary | `docker compose logs mongo-setup` to ensure initiation succeeded. |
| 401 errors on mobile | Ensure refresh token request is reachable; check `JWT_SECRET` matches backend. |
| SIP registration fails | Confirm WebSocket URL `wss://<domain>:443` reachable and Telnyx credentials active. |
| Stripe webhook 400 | Verify `STRIPE_WEBHOOK_SECRET` and set `Stripe-Signature` header when replaying events. |

## Future Enhancements

- Complete Testcontainers suites for wallet + webhook flows.
- Add background incoming call service on Android.
- Build Grafana dashboard JSON for call metrics.
- Optional Asterisk/Freeswitch container integration in `infra/`.