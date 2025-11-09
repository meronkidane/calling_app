SHELL := /bin/bash

.PHONY: backend backend-test backend-run mobile mobile-test mobile-run infra-up infra-down lint fmt

backend:
	./scripts/setup-gradle-wrapper.sh
	cd backend && ./gradlew clean build

backend-test:
	./scripts/setup-gradle-wrapper.sh
	cd backend && ./gradlew test

backend-run:
	./scripts/setup-gradle-wrapper.sh
	cd backend && ./gradlew bootRun

mobile:
	cd mobile && flutter pub get

mobile-test:
	cd mobile && flutter test

mobile-run:
	cd mobile && flutter run --dart-define=API_BASE_URL=$${API_BASE_URL:-http://10.0.2.2:8080}

infra-up:
	docker compose -f infra/docker-compose.yaml up -d

infra-down:
	docker compose -f infra/docker-compose.yaml down

lint:
	cd backend && ./gradlew check
	cd mobile && flutter analyze

fmt:
	@echo "Formatter for backend not configured; run IDE formatter."
	cd mobile && flutter format lib
