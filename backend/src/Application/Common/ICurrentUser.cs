using FamilyVeda.Domain.Common;

namespace FamilyVeda.Application.Common;

public interface ICurrentUser
{
    bool IsAuthenticated { get; }
    Guid UserId { get; }
    UserType UserType { get; }
}
