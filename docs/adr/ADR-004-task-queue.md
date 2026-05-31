# ADR-004: Background Task Processing Architecture

## Status

Accepted

## Date

2026-06-01

---

## Context

The Enterprise AI Document Intelligence Platform must process uploaded documents asynchronously.

Document processing operations such as:

* OCR
* PDF parsing
* Table extraction
* AI extraction
* Embedding generation
* Workflow execution

can take several seconds or minutes depending on document size and system load.

Running these operations directly inside API requests would:

* Increase response times
* Block API workers
* Reduce scalability
* Increase timeout risk
* Create poor user experience

The platform requires a dedicated background processing architecture.

---

## Alternatives Considered

### FastAPI Background Tasks

Pros:

* Simple
* Built into FastAPI
* Easy to implement

Cons:

* Runs inside API process
* Not suitable for long-running jobs
* Poor scalability
* No distributed execution

---

### Celery + Redis

Pros:

* Industry standard
* Distributed processing
* Reliable task execution
* Retry support
* Task monitoring
* Horizontal scaling

Cons:

* Additional infrastructure
* More operational complexity

---

### RabbitMQ + Celery

Pros:

* Enterprise-grade messaging
* Advanced routing

Cons:

* Additional infrastructure complexity
* Not required for MVP

---

### Kafka

Pros:

* Massive scalability
* Event-driven architecture

Cons:

* Significant operational overhead
* Unnecessary for current requirements

---

## Decision

The platform will use:

* Redis as message broker
* Celery as task processing framework

All document processing must occur through Celery workers.

---

## High-Level Flow

User uploads document:

```text
User
  ↓
FastAPI
  ↓
PostgreSQL Record Created
  ↓
Document Stored
  ↓
Celery Task Queued
  ↓
Redis
  ↓
Worker Consumes Task
  ↓
OCR Processing
  ↓
Results Saved
  ↓
Status Updated
```

---

## Architectural Principles

### API Never Performs OCR

The API layer must never perform OCR processing directly.

The API layer is responsible only for:

* Validation
* File storage
* Task creation
* Response generation

---

### Worker Owns Processing

Workers are responsible for:

* OCR execution
* PDF parsing
* Table extraction
* Future AI processing

---

### Retry Support

All processing tasks must support retries.

Examples:

* Temporary OCR failure
* Temporary file access issues
* Temporary database connectivity issues

---

### Status Tracking

Every task must update document status.

Supported statuses:

* UPLOADED
* PROCESSING
* COMPLETED
* FAILED

---

### Idempotency

Workers must be designed so that repeated execution does not corrupt data.

A task should be safely retryable.

---

## Phase 1 Responsibilities

### API Service

Responsible for:

* Authentication
* Upload endpoints
* Document retrieval
* Task creation

Not responsible for:

* OCR
* AI processing

---

### Worker Service

Responsible for:

* OCR processing
* Text extraction
* OCR result storage

---

### Redis

Responsible for:

* Task queueing
* Message transport

Redis is not considered a source of truth.

No business-critical data should exist only in Redis.

---

## Future Expansion

Additional worker queues may be introduced.

Examples:

### OCR Queue

* OCR processing

### AI Queue

* Extraction
* Classification

### Embedding Queue

* Vector generation

### Workflow Queue

* Notifications
* Routing

This separation is deferred until future phases.

Phase 1 uses a single queue.

---

## Monitoring

Future observability may include:

* Flower
* Prometheus
* Grafana

These tools are not required during initial MVP development.

---

## Expected Benefits

### Performance

* Faster API responses
* Better user experience

### Scalability

* Independent worker scaling
* Improved throughput

### Reliability

* Retry support
* Fault isolation

### Maintainability

* Clear separation of concerns
* Easier debugging

---

## Consequences

### Positive

* Production-grade architecture
* Supports future AI workloads
* Scales independently of API layer

### Negative

* Additional infrastructure
* Additional deployment complexity

These tradeoffs are acceptable because document processing workloads are inherently asynchronous.
