---
name: deployment-release
description: Select a deployment platform, prepare releases, verify environments, deploy with approval, and support rollback.
user-invocable: true
---

# Deployment Release

## When to use

Use for hosting selection, environment configuration, CI/CD, domains, previews, production releases, rollback, and health verification.

## Platform selection

Consider:

- Existing project platform
- Vercel/serverless
- Railway/managed application hosting
- Heroku
- Cloudflare
- Docker VPS
- Coolify
- Other project-specific platforms

Consult `rules/coolify.md` when self-hosting is a candidate.

## Coolify fit

Coolify is a strong candidate when the application needs:

- Docker deployment
- Continuous Telegram bot or worker execution
- Persistent backend services
- Databases on a controlled VPS
- Multiple self-hosted services
- Portability and infrastructure ownership

Do not select Coolify only because it is open source. Account for server administration, backups, security, monitoring, and recovery.

## Workflow

1. Confirm `PROJECT_MODE`.
2. Identify runtime and persistence requirements.
3. Compare suitable deployment options.
4. Record the selected option and rejected alternatives.
5. Define environments.
6. List environment-variable names.
7. Define build and start commands.
8. Define health checks.
9. Define backup and rollback.
10. Run build/test checks.
11. Request approval.
12. Deploy.
13. Verify production.
14. Record the result.

## Output format

```text
DEPLOYMENT PLAN:
- Platform:
- Reason:
- Runtime:
- Environments:
- Build:
- Start:
- Data/volumes:
- Health checks:
- Monitoring:
- Backup:
- Rollback:
- Approval:
```

## Stop conditions

Stop before deployment, DNS changes, secret changes, infrastructure changes, or production database actions without explicit approval.
