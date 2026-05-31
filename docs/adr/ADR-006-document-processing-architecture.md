# ADR-006: Document Processing Architecture

## Status

Accepted

## Date

2026-06-01

---

## Context

The Enterprise AI Document Intelligence Platform is intended to support multiple document types over time.

Planned document types include:

* Invoices
* Resumes
* Contracts
* Bank Statements
* Insurance Documents
* Medical Records

Although Phase 1 focuses exclusively on invoices, the architecture must avoid invoice-specific coupling that would make future expansion difficult.

The platform requires a document processing architecture that is:

* Extensible
* Maintainable
* Testable
* Scalable

while supporting future AI and workflow capabilities.

---

## Problem Statement

A common anti-pattern is embedding document-specific logic throughout the application.

Example:

```python
if document_type == "invoice":
    process_invoice()
```

When new document types are added, this approach leads to:

* Complex conditional logic
* Difficult maintenance
* Increased testing burden
* Tight coupling

The platform requires a more extensible design.

---

## Decision

The platform will implement a processor-based architecture.

Every document type will have its own processing implementation.

All processors will follow a shared contract.

---

## Architectural Principle

The platform processes documents, not invoices.

Invoices are simply the first supported document type.

Future document types must fit into the same architecture.

---

## High-Level Processing Flow

```text
User Uploads Document
        ↓
Document Created
        ↓
Document Type Determined
        ↓
Processor Selected
        ↓
OCR Processing
        ↓
Results Stored
        ↓
Status Updated
```

---

## Phase 1 Supported Document Types

Only:

```text
INVOICE
```

is supported during Phase 1.

Any unsupported document type must be rejected.

---

## Future Document Types

Planned support:

```text
INVOICE
RESUME
CONTRACT
BANK_STATEMENT
INSURANCE
MEDICAL_RECORD
```

Additional types may be introduced later.

---

## Processor Pattern

Every document type will have a dedicated processor.

Example:

```text
Document Processor
        ↓
Invoice Processor
Resume Processor
Contract Processor
```

Each processor is responsible for:

* Validation
* OCR orchestration
* Post-processing
* Future AI extraction

---

## Processor Responsibilities

### Phase 1

Processor responsibilities:

* OCR execution
* OCR result normalization
* Result persistence

---

### Future Phases

Additional responsibilities:

* Entity extraction
* Classification
* Validation
* Semantic indexing
* Workflow triggering

---

## Upload Lifecycle

### Step 1

User uploads file.

---

### Step 2

Document metadata stored.

Status:

```text
UPLOADED
```

---

### Step 3

Background task created.

---

### Step 4

Worker retrieves task.

Status:

```text
PROCESSING
```

---

### Step 5

Processor selected.

Example:

```text
INVOICE
    ↓
Invoice Processor
```

---

### Step 6

OCR executed.

---

### Step 7

Results stored.

---

### Step 8

Status updated.

```text
COMPLETED
```

or

```text
FAILED
```

---

## Status Model

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

## OCR Pipeline

Phase 1 OCR stack:

```text
PyMuPDF
+
PaddleOCR
```

Responsibilities:

* PDF parsing
* Image extraction
* Text extraction

Output:

```json
{
  "pages": [
    {
      "page_number": 1,
      "text": "..."
    }
  ]
}
```

No AI extraction occurs during Phase 1.

---

## Data Ownership

### Documents Table

Stores:

* Metadata
* Status
* File location
* Document type

---

### OCR Results Table

Stores:

* OCR text
* OCR metadata
* Processing timestamps

---

## Error Handling

Processing failures must:

* Update document status
* Record error information
* Allow future retries

A failed document must never remain in PROCESSING state indefinitely.

---

## Future AI Processing

Future phases may introduce:

### Invoice Intelligence

* Vendor extraction
* Amount extraction
* Tax extraction

### Resume Intelligence

* Skill extraction
* Experience extraction

### Contract Intelligence

* Clause extraction
* Obligation extraction

The processor architecture must support these capabilities without modifying existing processors.

---

## Architectural Benefits

### Extensibility

New document types can be added without modifying existing processors.

---

### Maintainability

Each processor owns its own logic.

---

### Testability

Processors can be tested independently.

---

### Scalability

Different processors may eventually run on separate worker queues.

---

## Consequences

### Positive

* Future-proof architecture
* Easier onboarding
* Cleaner codebase
* Reduced coupling

### Negative

* Slightly more initial complexity

These tradeoffs are acceptable because long-term maintainability and scalability are prioritized.
