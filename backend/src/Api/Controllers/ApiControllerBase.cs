using FluentValidation;
using Microsoft.AspNetCore.Mvc;

namespace FamilyVeda.Api.Controllers;

[ApiController]
[Produces("application/json")]
public abstract class ApiControllerBase : ControllerBase
{
    protected static async Task ValidateAsync<T>(IValidator<T> validator, T request, CancellationToken cancellationToken)
    {
        var result = await validator.ValidateAsync(request, cancellationToken);
        if (!result.IsValid)
        {
            throw new Application.Common.ValidationException(result.Errors
                .GroupBy(x => char.ToLowerInvariant(x.PropertyName[0]) + x.PropertyName[1..])
                .ToDictionary(group => group.Key, group => group.Select(x => x.ErrorMessage).ToArray()));
        }
    }
}
