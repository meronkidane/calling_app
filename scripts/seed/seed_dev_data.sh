#!/usr/bin/env bash
set -euo pipefail

API_BASE=${API_BASE:-http://localhost:8080}

echo "Seeding reference rates..."
curl -sS -X POST "${API_BASE}/admin/rates" \
  -H "Authorization: Bearer ${ADMIN_TOKEN:-}" \
  -H "Content-Type: application/json" \
  -d "{\"countryIso\":\"US\",\"prefix\":\"+1\",\"ratePerMinuteCents\":2,\"currency\":\"usd\",\"effectiveFrom\":\"$(date -Is)\"}" || true

curl -sS -X POST "${API_BASE}/admin/rates" \
  -H "Authorization: Bearer ${ADMIN_TOKEN:-}" \
  -H "Content-Type: application/json" \
  -d "{\"countryIso\":\"IN\",\"prefix\":\"+91\",\"ratePerMinuteCents\":5,\"currency\":\"usd\",\"effectiveFrom\":\"$(date -Is)\"}" || true

echo "Seed complete."
