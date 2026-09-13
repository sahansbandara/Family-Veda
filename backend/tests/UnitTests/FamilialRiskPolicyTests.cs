// [S4] Familial Risk & Clinical Approval
using FamilyVeda.Domain.Common;
using FamilyVeda.Domain.FamilialRisk;

namespace FamilyVeda.UnitTests;

public sealed class FamilialRiskPolicyTests
{
    [Fact]
    public void IsRelationshipEligible_WhenRelationshipIsNotBiological_ReturnsFalse()
    {
        var isEligible = FamilialRiskPolicy.IsRelationshipEligible(isBiological: false);

        Assert.False(isEligible);
    }

    [Fact]
    public void EvaluateCarrierContext_WhenSecondParentStatusIsUnknown_OmitsAffectedRiskPercentage()
    {
        var result = FamilialRiskPolicy.EvaluateCarrierContext(
            CarrierStatus.Carrier,
            CarrierStatus.Unknown);

        Assert.Null(result.AffectedRiskPercent);
        Assert.NotEmpty(result.UnknownParties);
    }
}
