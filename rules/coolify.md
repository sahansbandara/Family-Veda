# Coolify Deployment Rules

Coolify is an optional self-hosted deployment candidate.

## Select Coolify when

- The application is Docker-compatible.
- Persistent services or workers are required.
- A Telegram bot or backend must stay running continuously.
- The user has or plans to rent a VPS.
- Self-hosting, portability, or infrastructure control matters.
- Multiple applications and databases will share managed server infrastructure.
- The team accepts server maintenance responsibility.

## Do not select Coolify when

- A static site can use a simpler hosting platform.
- A serverless platform is a better architectural fit.
- The project has no one responsible for backups, updates, monitoring, and security.
- The project needs managed enterprise reliability without infrastructure ownership.
- Installing and maintaining Coolify costs more effort than the application justifies.

## Required checks

- VPS sizing
- SSH access
- Firewall
- Domain and TLS
- Environment variables
- Persistent volumes
- Database backups
- Health checks
- Deployment rollback
- Monitoring and alerts
- Coolify backup/recovery
- Separation of production and staging

## Security

- Do not expose the Coolify dashboard publicly without proper protection.
- Use strong authentication.
- Restrict SSH access.
- Keep secrets in the platform secret store.
- Do not deploy with default credentials.
- Back up databases independently.
- Require approval before production deployment or infrastructure changes.

## Decision output

```text
COOLIFY DECISION:
- Selected: yes/no
- Reason:
- VPS:
- Services:
- Persistent data:
- Backup:
- Monitoring:
- Rollback:
- Maintenance owner:
```
