# Backend Architecture

## Overview

The backend is responsible for:

* Authentication
* Document management
* File uploads
* Task orchestration
* OCR result retrieval
* Future AI services

The backend follows a layered architecture with clear separation of responsibilities.

Business logic must never be placed inside route handlers.

---

# Architectural Principles

## Separation of Concerns

Each layer has a single responsibility.

Examples:

* Routes handle HTTP requests.
* Services handle business logic.
* Repositories handle database access.
* Workers handle background processing.

---

## Thin Controllers

Route handlers must:

* Validate requests
* Call services
* Return responses

Route handlers must not:

* Execute business logic
* Access databases directly
* Execute OCR
* Perform file storage

---

## Service Layer

All business logic must reside inside services.

Examples:

* Authentication Service
* Document Service
* OCR Service

Services are the primary orchestration layer.

---

## Repository Pattern

Database access must be isolated from business logic.

Services communicate with repositories.

Repositories communicate with SQLAlchemy.

---

## Dependency Injection

Application dependencies should be provided through FastAPI dependency injection whenever possible.

---

# Backend Structure

```text
backend/

├── app/
│
├── tests/
│
├── requirements/
│
├── alembic/
│
├── Dockerfile
│
└── README.md
```

---

# Application Structure

```text
app/

├── api/
├── core/
├── db/
├── models/
├── repositories/
├── schemas/
├── services/
├── workers/
├── storage/
└── main.py
```

---

# API Layer

Location:

```text
app/api/
```

Purpose:

* Route definitions
* Request validation
* Response generation

Must not contain:

* Business logic
* Database queries
* OCR logic

---

## API Structure

```text
api/

├── auth/
└── documents/
```

Examples:

```text
api/auth/routes.py
api/documents/routes.py
```

---

# Core Layer

Location:

```text
app/core/
```

Purpose:

Shared application configuration.

Examples:

* Settings
* Security
* Constants
* Logging

---

## Core Structure

```text
core/

├── config.py
├── security.py
├── constants.py
└── logging.py
```

---

# Database Layer

Location:

```text
app/db/
```

Purpose:

Database initialization and session management.

---

## Database Structure

```text
db/

├── base.py
├── session.py
└── database.py
```

Responsibilities:

* Engine creation
* Session creation
* Base model registration

---

# Models Layer

Location:

```text
app/models/
```

Purpose:

SQLAlchemy models.

Examples:

```text
models/

├── user.py
├── document.py
└── ocr_result.py
```

Models define database structure only.

Business logic is prohibited.

---

# Repository Layer

Location:

```text
app/repositories/
```

Purpose:

Database access abstraction.

Examples:

```text
repositories/

├── user_repository.py
├── document_repository.py
└── ocr_repository.py
```

Responsibilities:

* CRUD operations
* Query logic

Must not contain business logic.

---

# Schema Layer

Location:

```text
app/schemas/
```

Purpose:

Pydantic request and response models.

Examples:

```text
schemas/

├── auth.py
├── document.py
└── ocr.py
```

Responsibilities:

* Request validation
* Response serialization

---

# Service Layer

Location:

```text
app/services/
```

Purpose:

Business logic.

Examples:

```text
services/

├── auth_service.py
├── document_service.py
├── upload_service.py
└── ocr_service.py
```

Responsibilities:

* Workflow orchestration
* Validation rules
* Coordination between repositories

Services must not contain HTTP-specific logic.

---

# Storage Layer

Location:

```text
app/storage/
```

Purpose:

Storage abstraction.

Examples:

```text
storage/

├── base_storage.py
└── local_storage.py
```

Responsibilities:

* Save files
* Retrieve files
* Delete files

Business logic must never access file system paths directly.

---

# Worker Layer

Location:

```text
app/workers/
```

Purpose:

Background task execution.

Examples:

```text
workers/

├── celery_app.py
├── document_tasks.py
└── ocr_tasks.py
```

Responsibilities:

* OCR processing
* Background jobs

Workers must not contain API logic.

---

# Request Flow

Authentication Example:

```text
Client
   ↓
API Route
   ↓
Auth Service
   ↓
User Repository
   ↓
Database
```

---

# Upload Flow

```text
Client
   ↓
Document Route
   ↓
Document Service
   ↓
Storage Service
   ↓
Document Repository
   ↓
Database

   ↓

Create Celery Task
   ↓
Redis
   ↓
Worker
```

---

# OCR Processing Flow

```text
Worker
   ↓
OCR Service
   ↓
Storage Service
   ↓
PaddleOCR
   ↓
OCR Repository
   ↓
Database
```

---

# Forbidden Patterns

The following are prohibited.

---

## Business Logic In Routes

Bad:

```python
@router.post("/upload")
def upload():
    # OCR logic
```

---

## Database Queries In Routes

Bad:

```python
session.query(...)
```

inside route handlers.

---

## File System Access In Services

Bad:

```python
open("uploads/file.pdf")
```

Services must use Storage abstractions.

---

## OCR Inside API

Bad:

```python
upload()
    ↓
run OCR
    ↓
return response
```

OCR must always execute through workers.

---

# Future Expansion

Future services may include:

```text
services/

├── extraction_service.py
├── rag_service.py
├── workflow_service.py
└── notification_service.py
```

No architectural redesign should be required.

---

# Backend Success Criteria

The backend architecture is considered successful when:

* Business logic is isolated.
* Database access is isolated.
* OCR processing is isolated.
* Storage providers can be replaced.
* New document types can be added without restructuring.
* Future AI services can be added without architectural redesign.
