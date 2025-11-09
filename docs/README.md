# Documentation Portal

This guide walks through setting up the monorepo locally, running the backend and mobile applications, executing the automated tests, and publishing the documentation with Jekyll. Follow the steps in order on macOS or Linux; Windows users should adapt commands to PowerShell where needed.

---

## 1. Prerequisites

| Tool | Version | Purpose |
| --- | --- | --- |
| Git | latest | Clone and manage the repository |
| Docker + Docker Compose v2 | latest | Run MongoDB replica set, Prometheus, Grafana, Zipkin |
| JDK | 17 | Build the Spring Boot backend |
| Gradle Wrapper | `./scripts/setup-gradle-wrapper.sh` installs Gradle 9.2.0 locally |
| Flutter | 3.24 (stable) | Build/run the mobile app |
| Android Studio / SDK tools | latest | Emulator + platform tools |
| Ruby | 3.1+ | Serve documentation with Jekyll |
| Bundler | `gem install bundler` | Manage Ruby gems for docs |

Optional but recommended:

- IntelliJ IDEA / VS Code for backend development.
- Jekyll plugins require build tools (e.g. `build-essential` on Ubuntu, Xcode CLT on macOS).

---

## 2. Clone and bootstrap the repository

```bash
git clone https://github.com/your-org/international-calling-app.git
cd international-calling-app
```

1. Install Gradle wrapper (downloads Gradle 9.2.0 to `backend/gradle/wrapper`):

   ```bash
   ./scripts/setup-gradle-wrapper.sh
   ```

2. Install Flutter dependencies:

   ```bash
   (cd mobile && flutter pub get)
   ```

3. Install Ruby gems for documentation:

   ```bash
   (cd docs && bundle install)
   ```

---

## 3. Infrastructure (Docker Compose)

Spin up MongoDB (replica set), Prometheus, Grafana, and Zipkin:

```bash
docker compose -f infra/docker-compose.yaml up -d mongo1 mongo2 mongo-setup prometheus grafana zipkin
```

Useful checks:

- Mongo shell: `docker exec -it calling-mongo1 mongosh`
- Prometheus: http://localhost:9090
- Grafana: http://localhost:3000 (admin/admin)
- Zipkin: http://localhost:9411

To tear everything down:

```bash
docker compose -f infra/docker-compose.yaml down
```

---

## 4. Backend (Spring Boot)

### 4.1 Configure environment variables

Create `backend/.env.local` (optional) or export variables before running:

```bash
export JWT_SECRET=changeme
export MONGO_URI=mongodb://localhost:27017,localhost:27018/calling?replicaSet=rs0
export STRIPE_SECRET_KEY=sk_test_xxx
export STRIPE_WEBHOOK_SECRET=whsec_xxx
export TELNYX_API_KEY=telnyx_xxx
export TELNYX_SIP_DOMAIN=example.telnyx.com
export AUTH_SANDBOX=true
```

### 4.2 Run the application

```bash
cd backend
./gradlew bootRun
```

Endpoints:

- API: http://localhost:8080
- Swagger UI: http://localhost:8080/swagger-ui.html
- Prometheus metrics: http://localhost:8080/actuator/prometheus

### 4.3 Backend tests

```bash
./gradlew clean test
```

Artifacts (unit test reports) are generated under `backend/build/reports/tests/test/index.html`.

---

## 5. Mobile (Flutter)

### 5.1 Android emulator

1. Open Android Studio (Device Manager → create Android 13+ emulator).
2. Start the emulator.

### 5.2 Run the app

```bash
cd mobile
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080
```

**Notes**

- `10.0.2.2` exposes the host machine from the Android emulator.
- OTP sandbox mode uses `000000`.
- Register SIP credentials via the dialer settings button (supports Telnyx WebSocket credentials).

### 5.3 Mobile tests & analyze

```bash
flutter analyze
flutter test
```

---

## 6. Continuous Integration (GitHub Actions)

CI runs from `.github/workflows/ci.yml` and triggers on pushes to `main` and pull requests.

Jobs:

1. **backend**: installs JDK 17, runs `./scripts/setup-gradle-wrapper.sh`, executes `./backend/gradlew clean build`.
2. **mobile**: configures Flutter stable, runs `flutter pub get`, `flutter analyze`, and `flutter test`.
3. **docker**: depends on backend; builds the Spring Boot jar and creates a Docker image via `docker build`.

To replicate locally:

```bash
# Backend
./scripts/setup-gradle-wrapper.sh
cd backend && ./gradlew clean build

# Mobile
cd ../mobile && flutter pub get && flutter analyze && flutter test

# Docker image
cd ../backend && ./gradlew bootJar
docker build -t calling-backend:local -f Dockerfile .
```

---

## 7. Seed sample data

With backend running, seed demo rates:

```bash
API_BASE=http://localhost:8080 ./scripts/seed/seed_dev_data.sh
```

Verify with:

```bash
curl http://localhost:8080/rates?country=US
```

---

## 8. Documentation (Jekyll)

We ship the docs with a Jekyll site (stored in `/workspace/docs`). Ensure Ruby dependencies are installed (`bundle install`).

### 8.1 Local Jekyll server

```bash
cd docs
bundle exec jekyll serve --livereload
```

Visit http://127.0.0.1:4000 to browse the documentation portal. Live reload is enabled.

### 8.2 Publish via GitHub Pages

1. Push `docs/` folder to the repository.
2. Enable GitHub Pages for the branch (Settings → Pages → Build from `/docs`).

---

## 9. Troubleshooting

| Issue | Fix |
| --- | --- |
| Mongo replicaset not primary | `docker logs calling-mongo-setup` to ensure `rs.initiate` succeeded. |
| Backend can't connect to Mongo | Check `MONGO_URI`, ensure replica set name is `rs0`. |
| Flutter cannot reach API | Confirm you used `--dart-define=API_BASE_URL=http://10.0.2.2:8080` or appropriate host. |
| SIP registration fails | Verify Telnyx SIP credentials and that `wss://<domain>:443` is reachable. |
| Jekyll fails to serve | Install Xcode CLT (macOS), or run `bundle install` for Linux dependencies. |

---

## 10. Repository structure (recap)

```
backend/        Spring Boot WebFlux backend
mobile/         Flutter mobile app (Android-first)
infra/          Docker Compose definitions
docs/           Documentation site, ADRs, runbooks, openapi.yaml
scripts/        Helper scripts (seed data, Gradle setup)
```

---

You now have a fully functional local environment with backend, mobile client, observability stack, and documentation site. Happy building!
