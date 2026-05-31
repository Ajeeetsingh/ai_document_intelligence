# ADR-001: Project Scope

## Status

Accepted

## Date

2026-06-01

---

## Context

The goal of this project is to build an enterprise-grade AI Document Intelligence Platform capable of processing, understanding, and automating workflows around business documents.

The long-term vision is to support multiple document types including:

* Invoices
* Resumes
* Contracts
* Bank Statements
* Insurance Documents
* Medical Records

However, attempting to support multiple document types during the initial development phase would significantly increase complexity and slow down delivery.

Therefore, the project will begin with a single document type: invoices.

---

## Decision

Phase 1 will focus exclusively on invoice ingestion and OCR processing.

The primary objective is to build a reliable and scalable document processing foundation before introducing AI understanding, retrieval systems, workflow automation, or multi-document support.

Phase 1 will include:

* User authentication
* Invoice upload
* File storage
* OCR processing
* Background job execution
* Processing status tracking
* OCR result viewing

---

## Phase 1 Features

### Authentication

Users can:

* Register
* Login
* Access protected endpoints

### Document Upload

Supported file types:

* PDF
* PNG
* JPG
* JPEG

### Document Storage

Documents will be stored on the local file system during MVP development.

Future migration to MinIO or Amazon S3 is planned.

### OCR Processing

OCR processing will be performed using:

* PyMuPDF
* PaddleOCR

Output will consist of extracted raw text and page-level OCR results.

### Background Processing

Document processing must occur asynchronously using:

* Redis
* Celery

### Processing Status Tracking

Supported document states:

* UPLOADED
* PROCESSING
* COMPLETED
* FAILED

### Dashboard

Users can:

* View uploaded documents
* Track processing status
* View OCR results

---

## Explicit Non-Goals

The following features are intentionally excluded from Phase 1:

### AI Understanding

* Invoice number extraction
* Vendor extraction
* Amount extraction
* Tax extraction

### Large Language Models

* OpenAI
* Qwen
* Claude
* Gemini

### Retrieval-Augmented Generation

* Embeddings
* Vector databases
* Semantic search
* Document chat

### Workflow Automation

* Approval workflows
* Notifications
* Email routing

### Enterprise Features

* RBAC
* Multi-tenancy
* Audit logs

---

## Success Criteria

Phase 1 is considered complete when:

### Functional Requirements

* User uploads invoice
* OCR processing completes successfully
* OCR text is stored
* OCR results are viewable
* Processing status updates correctly

### Technical Requirements

* FastAPI backend
* PostgreSQL database
* Redis queue
* Celery worker
* Dockerized services

### Quality Requirements

* Modular architecture
* API documentation
* Unit tests
* Clear separation of concerns

---

## Future Roadmap

### Phase 2

Invoice Intelligence

* Structured extraction
* Invoice field detection
* Validation rules

### Phase 3

Document Intelligence

* Embeddings
* Qdrant
* Semantic search
* Document chat

### Phase 4

Workflow Automation

* Approval engine
* Notifications
* Routing rules

### Phase 5

Multi-Document Support

* Resume processing
* Contract processing
* Bank statement processing
* Insurance document processing

---

## Consequences

### Positive

* Reduced complexity during initial development
* Faster delivery of MVP
* Strong architectural foundation
* Easier testing and debugging

### Negative

* Limited business functionality in Phase 1
* AI capabilities deferred to later phases

These tradeoffs are acceptable because long-term maintainability and scalability are prioritized over short-term feature breadth.
