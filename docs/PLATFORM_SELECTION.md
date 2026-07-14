# Platform Selection

This template recognizes four selected optional platforms.

## Web data

### Crawl4AI

Use for:

- Crawling
- Documentation ingestion
- RAG source preparation
- Public-page extraction
- LLM-ready Markdown

### Browser Use

Use for:

- Authorized interactive browser workflows
- Form completion
- Dynamic dashboard actions
- Browser QA
- Visual verification

## Deployment

### Coolify

Use for:

- Self-hosted Docker applications
- Telegram bots
- Persistent APIs and workers
- Databases on controlled VPS infrastructure

Do not select it unless maintenance, backups, security, and monitoring have owners.

## Backend

### Supabase

Use for:

- PostgreSQL
- Auth
- Realtime
- Storage
- Generated APIs
- Vector/embedding use cases

Do not replace an existing suitable backend without a migration justification.

## Selection rule

Do not install any platform during `TEMPLATE_MODE`.

Record:

- selected option
- alternatives
- reason
- maintenance cost
- security impact
- lock-in/exit strategy
