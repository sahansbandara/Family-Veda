---
name: web-data-acquisition
description: Select and operate the safest web-data method using API/MCP first, Crawl4AI for crawling, and Browser Use for interactive browser tasks.
user-invocable: true
---

# Web Data Acquisition

## Purpose

Collect public or authorized web data using the least fragile method.

This skill supports:

- Direct APIs
- MCP tools
- HTTP requests
- Crawl4AI
- Browser Use
- Computer Use as the final fallback

## Routing order

```text
1. Direct API
2. MCP integration
3. HTTP request or feed
4. Crawl4AI
5. Browser Use
6. Computer Use
```

## When to use Crawl4AI

Use Crawl4AI when the project needs:

- Multi-page crawling
- Documentation ingestion
- Website-to-Markdown conversion
- RAG source collection
- Structured extraction from public pages
- Large or repeated crawl jobs
- Python or Docker-controlled data pipelines

Do not use it when the task requires complex authenticated interaction, form completion, or human-like navigation.

## When to use Browser Use

Use Browser Use when the task requires:

- Clicking and navigating
- Login-based authorized workflows
- Form completion
- Dashboard interaction
- Browser-based QA
- Dynamic workflows that cannot be completed reliably through an API
- Visual confirmation of a web application

Do not use it for high-volume crawling when Crawl4AI or an API can perform the task.

## Inputs to check

- Exact data or action required
- Public, private, or authenticated source
- Source terms and robots policy
- Expected page count
- Required output format
- Crawl frequency
- Rate limit
- Login or session requirements
- Personal or sensitive data
- Storage and retention policy
- Failure and fallback behavior

## Workflow

1. Define the required data and why it is needed.
2. Check for an official API.
3. Check for an MCP integration.
4. Check for direct HTTP, RSS, sitemap, or export.
5. Use Crawl4AI for crawl/extraction workloads.
6. Use Browser Use only for required interaction.
7. Define rate limits and concurrency.
8. Preserve source URL, retrieval time, and extraction method.
9. Validate extracted data.
10. Store only required data.
11. Record the decision in `docs/WEB_DATA_TOOLS.md`.

## Security and compliance

- Do not bypass captchas, paywalls, access controls, or authentication restrictions.
- Do not collect data prohibited by the source terms.
- Do not scrape private accounts without authorization.
- Do not collect unnecessary personal data.
- Do not reuse copyrighted material merely because it is publicly visible.
- Use a sandbox for unfamiliar browser automation.
- Keep credentials in environment variables, never Markdown.
- Request approval before submitting forms or making external changes.

## Output format

```text
WEB DATA PLAN:
- Requirement:
- Source:
- Selected method:
- Why:
- Authentication:
- Expected volume:
- Rate limit:
- Output format:
- Provenance fields:
- Validation:
- Fallback:
- Risk:
- Approval required:
```

## Quality checklist

- [ ] API/MCP checked first
- [ ] Crawl4AI selected only for extraction/crawling
- [ ] Browser Use selected only for interaction
- [ ] Source authorization checked
- [ ] Rate limits defined
- [ ] Provenance retained
- [ ] Sensitive data minimized
- [ ] Validation defined
- [ ] Fallback defined
- [ ] High-risk external action requires approval

## Stop conditions

Stop when access is unauthorized, terms prohibit the action, a captcha or access control would need bypassing, credentials are unavailable, or the task would collect unnecessary sensitive data.
