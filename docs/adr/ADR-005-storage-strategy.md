# ADR-005: Document Storage Strategy

## Status

Accepted

## Date

2026-06-01

---

## Context

The Enterprise AI Document Intelligence Platform must store uploaded documents for processing and future retrieval.

The storage layer must support:

* PDF uploads
* Image uploads
* OCR processing
* Future AI extraction
* Future workflow processing
* Future cloud deployment

The storage solution must be simple enough for MVP development while remaining compatible with future production environments.

---

## Requirements

The storage system must:

* Store original uploaded files
* Support large PDF files
* Support image files
* Allow background workers to access files
* Enable future migration to object storage
* Minimize operational complexity during MVP development

---

## Alternatives Considered

### Local File System

Pros:

* Simple setup
* No additional infrastructure
* Easy local development
* Fast iteration

Cons:

* Not horizontally scalable
* Not suitable for multi-server production deployments

---

### MinIO

Pros:

* S3-compatible
* Self-hosted
* Production-friendly
* Easy future migration to AWS S3

Cons:

* Additional infrastructure
* Additional operational complexity

---

### Amazon S3

Pros:

* Highly scalable
* Durable
* Industry standard

Cons:

* Cloud dependency
* Additional costs
* More setup complexity for MVP

---

### Database Storage

Pros:

* Centralized storage

Cons:

* Poor performance for large files
* Increased database size
* Difficult scalability

---

## Decision

Phase 1 will use:

**Local File System Storage**

Uploaded documents will be stored on disk.

The storage architecture must be designed so that future migration to MinIO or Amazon S3 requires minimal application changes.

---

## Storage Principles

### Files Are Not Stored In Database

The database stores only:

* Metadata
* File paths
* Processing information

The database must never store raw document binaries.

---

### Single Source Of Truth

Uploaded files are considered the canonical source document.

OCR results and future AI outputs are derived artifacts.

---

### Storage Abstraction

Application code must interact with a storage service abstraction.

Business logic must never directly access file system paths.

Example:

```python
storage_service.save_file(...)
storage_service.get_file(...)
storage_service.delete_file(...)
```

Future storage providers can replace the implementation without changing business logic.

---

## Phase 1 Directory Structure

All uploaded files will be stored under:

uploads/

Within uploads:

uploads/
├── invoices/
│   ├── 2026/
│   │   ├── 06/
│   │   └── ...
│   └── ...
└── temp/

---

### invoices/

Stores original uploaded invoices.

---

### temp/

Stores temporary processing artifacts.

Temporary files may be deleted after processing.

---

## Database Relationship

Documents table stores:

* Original filename
* Storage path
* MIME type
* Upload timestamp

Example:

```text
invoice_001.pdf

Stored As:

uploads/invoices/2026/06/uuid.pdf
```

The application should reference files using stored metadata rather than hardcoded paths.

---

## File Naming Strategy

Uploaded filenames must never be used directly as storage identifiers.

The platform will generate unique identifiers.

Example:

```text
Original:

invoice_may.pdf

Stored:

8f4d4d8a-2d9e-4f78-a83f.pdf
```

Benefits:

* Avoid filename collisions
* Improve security
* Simplify storage management

---

## File Access

Users access documents through application APIs.

Direct file system exposure is prohibited.

The backend controls all document access.

---

## Future Storage Migration

Future storage providers may include:

### MinIO

For self-hosted deployments.

---

### Amazon S3

For cloud-native deployments.

---

### Azure Blob Storage

For enterprise Azure deployments.

---

### Google Cloud Storage

For GCP deployments.

---

The application architecture must support provider replacement through storage abstraction.

No business logic should depend on a specific storage provider.

---

## Backup Strategy

Phase 1:

* Manual backups acceptable

Future:

* Automated backups
* Object storage replication
* Disaster recovery procedures

---

## Security Considerations

Uploaded files must:

* Be validated before storage
* Be scanned for supported file types
* Be stored outside public web directories

File paths should never be trusted from user input.

---

## Expected Benefits

### Development

* Fast local development
* Minimal setup complexity

### Architecture

* Clear separation of storage concerns
* Easy migration path

### Scalability

* Future cloud compatibility
* Future object storage support

---

## Consequences

### Positive

* Simple MVP implementation
* Reduced infrastructure burden
* Easy onboarding for developers

### Negative

* Not suitable for multi-instance production deployments
* Requires future migration for cloud-scale environments

These tradeoffs are acceptable because Phase 1 prioritizes speed of development and architectural clarity.
