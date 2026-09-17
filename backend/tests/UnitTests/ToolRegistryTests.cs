// [S1 + S4] Tool-permission enforcement and Familial Risk safety boundary
using FamilyVeda.Application.Agents;
using FamilyVeda.Domain.Common;

namespace FamilyVeda.UnitTests;

public sealed class ToolRegistryTests
{
    [Fact]
    public void IsAllowed_WhenToolIsNotRegistered_DefaultsToDenied()
    {
        var registry = new ToolRegistry();

        var isAllowed = registry.IsAllowed(AgentKind.Context, "unregistered_tool");

        Assert.False(isAllowed);
    }

    [Fact]
    public void IsAllowed_WhenFamilialRiskRequestsRawRecords_ReturnsFalse()
    {
        var registry = new ToolRegistry();

        var isAllowed = registry.IsAllowed(AgentKind.FamilialRisk, "read_raw_record");

        Assert.False(isAllowed);
    }

    [Fact]
    public void IsAllowed_WhenFamilialRiskRequestsConsentedFlags_ReturnsTrue()
    {
        var registry = new ToolRegistry();

        var isAllowed = registry.IsAllowed(AgentKind.FamilialRisk, "read_consented_hereditary_flags");

        Assert.True(isAllowed);
    }
}
