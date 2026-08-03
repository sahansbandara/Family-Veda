# Permission Rules — development-time approvals

Product access control lives in `docs/PERMISSIONS.md`. **This file governs what a coding agent or team member may do to the repository without asking.**

## Risk classification

| Action | Risk | Approval | Rollback |
|---|---|---|---|
| Read project files | Low | None | n/a |
| Edit a file you own | Low | None | git revert |
| Add a test | Low | None | git revert |
| Edit a `⚠ SHARED` file | Medium | Follow the labelled-block convention | git revert |
| Add a dependency (`package.json`, `pubspec.yaml`, `.csproj`) | Medium | **Announce in the group chat first** | git revert |
| Commit / push | Medium | Only the owning member, under their own account | git revert |
| Merge to `develop` | Medium | 1 peer review + green CI | Revert commit |
| Edit a file owned by another member | High | **Ask that member** | git revert |
| Generate an EF Core migration | High | **Migration lock announced in group chat** | New corrective migration |
| Delete or overwrite a major file | High | Ask | git revert |
| Deploy | High | Group leader (S3) | Redeploy previous build |
| Change deployment or security settings | High | Group leader + S1 | Restore previous config |
| Change anything on `main` | High | PR from `develop` only | Revert |
| Violate a clinical safety rule | Critical | **Refused** | n/a |

## Rules

1. Approval names the **exact action and scope**. "Yes, edit that file" does not authorise editing the next one.
2. Approval does not extend to adjacent actions, later sessions, or similar files.
3. Record notable approvals in `agent/DECISIONS.md`.
4. Every high-risk action states its rollback before it is taken.
5. Never put secrets in an approval request or an approval message.
6. **Never commit on another member's behalf**, even to help them catch up — it destroys the evidence their individual marks depend on.

## The seven shared files

`backend/src/Api/Program.cs` [S1] · `AppDbContext.cs` [S1] · `Application/Agents/IAgent.cs` [S3] · `web/src/store/index.ts` [S3] · `web/src/routes/AppRouter.tsx` [S1] · `mobile/lib/router/app_router.dart` [S1] · `package.json` / `pubspec.yaml` [S1]

On these: **add lines inside your own labelled block. Never reorder, reformat, or restructure.** Reformatting turns a clean merge into a conflict.

`IAgent.cs` is different: an interface change affects every agent, so it requires **group agreement**, not just the block convention.
