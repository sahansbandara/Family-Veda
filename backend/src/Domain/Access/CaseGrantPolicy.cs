namespace FamilyVeda.Domain.Access;

public static class CaseGrantPolicy
{
    public static bool HasAccess(
        DateTimeOffset expiresAt,
        DateTimeOffset? revokedAt,
        DateTimeOffset now) => revokedAt is null && expiresAt > now;
}
