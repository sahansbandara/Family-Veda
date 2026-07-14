# Universal Agent Skill Pack Template v5

This is the merged final template.

## Included

- Pre-project grill gate
- Project customization gate
- Development methodology
- Tool routing
- Free/low-cost LLM provider selection
- Output evaluation
- Human approval
- Sandbox execution
- Automation readiness
- Record-to-skill workflow
- Web data acquisition using Crawl4AI and Browser Use
- Optional Coolify deployment rules
- Optional Supabase backend rules

## First instruction

```text
Read PROJECT_SETUP_AGENT_PROMPT.md. Run the pre-project grill, select the project tools, decide whether an LLM is required, evaluate suitable free LLM APIs when relevant, define evaluation and approval rules, then customize the template. Do not write application code until CLAUDE.md is switched from TEMPLATE_MODE to PROJECT_MODE.
```

## Platform policy

- Crawl4AI: use for crawling, extraction, RAG ingestion, and LLM-ready Markdown.
- Browser Use: use for authorized interactive browser workflows and QA.
- Coolify: consider for persistent Docker-based self-hosting.
- Supabase: consider when PostgreSQL, auth, realtime, storage, or generated APIs fit.
- Do not select a platform only because it exists in this template.
