# Virtual File System Specification: knight:// protocol

**Version:** 1.0.0  
**Status:** Permanent Specification  
**Classification:** Infrastructure & Data Mobility  
**Date:** 2026-07-27  

---

## 1. Introduction

### 1.1 Purpose
The Knight Knowledge Base requires location-independent addressing for its evidence and memory artifacts. The `knight://` protocol provides a Virtual File System (VFS) layer that abstracts the physical disk path. This ensures that if the repository is moved from `C:/Users/...` to `/home/user/...` or to a cloud object store, all internal links (SourceLinks) remain valid.

---

## 2. URI Format

The protocol uses the following structure:
`knight://[mount]/[resource_id]#[fragment]`

### 2.1 Mounts
- `knight://evidence/`: Points to the source artifact vault.
- `knight://memory/`: Points to the master memory JSON files.
- `knight://books/`: Points to the generated markdown books.
- `knight://schema/`: Points to the data schemas.

### 2.2 Resource ID
- **Evidence:** Uses the **Content-Addressable Identifier (CAID)** (SHA-256 hash).
- **Memory:** Uses the **MemoryID** (UUID).
- **Books:** Uses the **BookID** and **QuestionID**.

### 2.3 Fragment
- Used for deep-linking (e.g., `#page=2`, `#line=40`, `#coords=x,y,w,h`).

---

## 3. Storage Architecture

### 3.1 Content-Addressable Storage (CAS)
Evidence is stored based on its content, not its name.
- *Directory Structure:* `[repo_root]/vault/[CAID_prefix_2]/[CAID].bin`
- *Example:* `knight://evidence/a1b2c3...` maps to `.../vault/a1/a1b2c3...`

### 3.2 Immutability
Files in the `vault/` are read-only.
- If a file's content changes, its hash changes, creating a NEW CAID.
- This prevents the "Broken Link" problem common in traditional file systems.

---

## 4. Integrity Checking

### 4.1 On-Access Verification
Whenever a `knight://evidence/` link is resolved, the system calculates the hash of the target file and compares it to the CAID in the URI.
- If mismatch: Return **ERROR_INTEGRITY_VIOLATION**.

### 4.2 Periodic Audit
A background service (The Sentinel) performs a full-system crawl every 30 days to verify that every link in the Master Memory points to a valid, healthy file in the VFS.

---

## 5. Migration & Import/Export

### 5.1 Portable Packages
When exporting the Knowledge Base, the VFS generates a **Knight Archive (.ka)**:
- Contains all AMU files.
- Contains all Evidence artifacts.
- Contains the Mapping Matrix.
- Links are preserved because they are relative to the `knight://` root.

### 5.2 External Bridge
The VFS layer includes a `Resolver` interface for specific environments (Windows, Linux, S3).
- `resolveLocalPath(uri)` returns the absolute path on the current machine.

---

**End of Specification.**
