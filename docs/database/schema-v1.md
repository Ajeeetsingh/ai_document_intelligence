# Database Schema V1

## Overview

Phase 1 of the Enterprise AI Document Intelligence Platform requires storage for:

* Users
* Uploaded documents
* OCR processing results

The schema is intentionally minimal and focused on invoice ingestion and OCR processing.

Future phases will extend the schema for:

* AI extraction
* Semantic search
* Workflow automation
* Multi-document support

---

# Database Technology

Database:

* PostgreSQL

Migration Tool:

* Alembic

ORM:

* SQLAlchemy

---

# Entity Relationship Diagram

```text
Users
  │
  │ 1:N
  ▼
Documents
  │
  │ 1:1
  ▼
OCR Results
```

---

# Document Status Enum

Supported statuses:

```text
UPLOADED
PROCESSING
COMPLETED
FAILED
```

Future statuses may include:

```text
INDEXED
APPROVED
REJECTED
ARCHIVED
```

These are not part of Phase 1.

---

# Document Type Enum

Phase 1:

```text
INVOICE
```

Future phases:

```text
RESUME
CONTRACT
BANK_STATEMENT
INSURANCE
MEDICAL_RECORD
```

---

# Table: users

Purpose:

Stores user account information.

---

## Columns

| Column        | Type         | Constraints      |
| ------------- | ------------ | ---------------- |
| id            | UUID         | Primary Key      |
| email         | VARCHAR(255) | Unique, Not Null |
| password_hash | TEXT         | Not Null         |
| is_active     | BOOLEAN      | Default True     |
| created_at    | TIMESTAMP    | Not Null         |
| updated_at    | TIMESTAMP    | Not Null         |

---

## Indexes

```sql
email
```

Unique index.

---

# Table: documents

Purpose:

Stores uploaded document metadata.

---

## Columns

| Column            | Type         | Constraints |
| ----------------- | ------------ | ----------- |
| id                | UUID         | Primary Key |
| user_id           | UUID         | Foreign Key |
| document_type     | VARCHAR(50)  | Not Null    |
| original_filename | TEXT         | Not Null    |
| stored_filename   | TEXT         | Not Null    |
| mime_type         | VARCHAR(100) | Not Null    |
| file_size         | BIGINT       | Not Null    |
| storage_path      | TEXT         | Not Null    |
| status            | VARCHAR(50)  | Not Null    |
| error_message     | TEXT         | Nullable    |
| uploaded_at       | TIMESTAMP    | Not Null    |
| updated_at        | TIMESTAMP    | Not Null    |

---

## Foreign Keys

```text
documents.user_id
→ users.id
```

---

## Indexes

```sql
user_id
status
document_type
uploaded_at
```

---

# Table: ocr_results

Purpose:

Stores OCR output generated from uploaded documents.

---

## Columns

| Column                  | Type         | Constraints        |
| ----------------------- | ------------ | ------------------ |
| id                      | UUID         | Primary Key        |
| document_id             | UUID         | Unique Foreign Key |
| extracted_text          | TEXT         | Not Null           |
| page_count              | INTEGER      | Nullable           |
| processing_time_seconds | FLOAT        | Nullable           |
| ocr_engine              | VARCHAR(100) | Nullable           |
| created_at              | TIMESTAMP    | Not Null           |

---

## Foreign Keys

```text
ocr_results.document_id
→ documents.id
```

---

## Relationship

One document has one OCR result.

```text
Document
   1
   │
   │
   1
OCR Result
```

Future phases may change this relationship if multiple OCR versions are required.

---

# Future Schema Expansion

The following tables are planned but NOT part of V1.

---

## invoice_extractions

Stores:

* invoice number
* vendor
* total amount
* tax amount
* currency

---

## embeddings

Stores:

* vector metadata
* chunk metadata

Actual vectors may be stored in Qdrant.

---

## workflows

Stores:

* workflow instances
* workflow status

---

## organizations

Stores:

* companies
* teams

---

## audit_logs

Stores:

* security events
* user actions

---

# Timestamp Strategy

All tables must include timestamps.

Standard fields:

```text
created_at
updated_at
```

Timestamps should use UTC.

---

# UUID Strategy

All primary keys use UUID.

Reasons:

* Better security
* Easier distributed systems support
* Avoid predictable identifiers

Example:

```text
7a1d5f98-9b7d-4f68-89f7-44b82dcf0d1f
```

---

# Soft Delete Strategy

Phase 1 does not implement soft deletes.

Future phases may introduce:

```text
deleted_at
```

for audit and recovery purposes.

---

# Validation Rules

Documents:

* Must belong to a valid user.
* Must have a valid document type.
* Must have a valid processing status.

OCR Results:

* Must reference a valid document.
* Cannot exist without a document.

---

# Phase 1 Success Criteria

The schema is considered complete when:

* Users can register and authenticate.
* Documents can be uploaded and tracked.
* OCR results can be stored and retrieved.
* Processing status can be updated independently.
* Future schema expansion can occur without major redesign.
