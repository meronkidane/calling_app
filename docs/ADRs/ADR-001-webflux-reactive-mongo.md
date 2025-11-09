# ADR-001: Reactive Spring WebFlux with MongoDB

## Context

The calling backend must orchestrate SIP signaling, Stripe billing, webhook ingestion, and RSocket event delivery with high throughput and low latency. The architecture requires non-blocking I/O to support hundreds of concurrent calls per instance without thread exhaustion. Reactive MongoDB drivers unlock streaming rate lookups and ledger writes while maintaining transactional guarantees. Traditional Spring MVC would allocate a thread per request, leading to poor utilization when waiting on upstream Telnyx or Stripe APIs.

## Decision

Adopt Spring Boot 3.x with WebFlux and Reactor, using the reactive MongoDB driver for all persistence. HTTP controllers use `Mono`/`Flux` to compose asynchronous flows, and repositories extend `ReactiveMongoRepository`. A `ReactiveMongoTransactionManager` provides multi-document transactions for wallet ledger updates.

## Consequences

* ✅ Efficient resource usage under high concurrency and WebSocket/RSocket workloads.
* ✅ First-class integration with RSocket and reactive security chain.
* ⚠️ Requires careful avoidance of blocking APIs; legacy JDBC libraries are off limits.
* ⚠️ Debugging reactive flows is more complex; Reactor tools and testing patterns are mandated.
