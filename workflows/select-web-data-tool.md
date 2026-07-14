# Workflow: Select Web Data Tool

Use `skills/web-data-acquisition/SKILL.md`.

## Steps

1. Define the exact data or browser action.
2. Check official API.
3. Check MCP.
4. Check direct HTTP, RSS, sitemap, or export.
5. Select Crawl4AI for crawling and extraction.
6. Select Browser Use for interactive tasks.
7. Define authorization, rate limits, output, validation, and fallback.
8. Update `docs/WEB_DATA_TOOLS.md`.
9. Add environment-variable names to `docs/ENV_VARS.md`.
10. Record architecture-impacting decisions.

## Completion rule

Do not start scraping or browser automation until authorization, method, rate limit, and storage rules are documented.
