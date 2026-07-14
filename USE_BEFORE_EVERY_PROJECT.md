# Use Before Every Project

After copying the template and explaining the idea, send:

```text
Read PROJECT_SETUP_AGENT_PROMPT.md. Run the pre-project grill, select the project tools, decide whether an LLM is required, evaluate suitable free LLM APIs when relevant, define evaluation and approval rules, then customize the template. Do not write application code until CLAUDE.md is switched from TEMPLATE_MODE to PROJECT_MODE.
```

## Required order

```text
Project idea
→ Grill weak assumptions
→ Select stack
→ Select tools
→ Select LLM provider if required
→ Define evaluator
→ Define permissions
→ Decide sandbox requirement
→ Customize files
→ PROJECT_MODE
→ Plan
→ Build
→ Verify
→ Review
→ Handoff
```

## For implementation

```text
Use skills/development-methodology/SKILL.md before implementing this feature. Plan first, build in small verified steps, evaluate the output, and request approval before high-risk actions.
```

## For automation

```text
Use skills/automation-readiness/SKILL.md before scheduling or enabling unattended execution.
```
