// [S4] Deterministic Safety / Validation Agent
using FamilyVeda.Domain.Safety;

namespace FamilyVeda.UnitTests;

public sealed class SafetyValidationServiceTests
{
    [Fact]
    public void Validate_WhenEmergencyRedFlagExists_HaltsBeforeLlmAndReturnsReferralOnly()
    {
        var service = new SafetyValidationService();
        var llmWasInvoked = false;
        var input = new SafetyInput(
            HasEmergencyRedFlag: true,
            DraftText: "untrusted draft that must not surface",
            SchemaValid: true,
            Confidence: 0.95m,
            ConfidenceThreshold: 0.60m);

        var result = service.Validate(input);
        if (result.CanContinue)
        {
            llmWasInvoked = true;
        }

        Assert.True(result.IsEmergency);
        Assert.False(result.CanContinue);
        Assert.False(llmWasInvoked);
        Assert.NotNull(result.PatientMessage);
        Assert.NotEmpty(result.PatientMessage);
        Assert.Equal(["EMERGENCY_RED_FLAG"], result.Violations);
        Assert.DoesNotContain("diagnos", result.PatientMessage, StringComparison.OrdinalIgnoreCase);
        Assert.DoesNotContain(input.DraftText, result.PatientMessage, StringComparison.Ordinal);
    }

    [Theory]
    [InlineData("You have pneumonia.")]
    [InlineData("Take aspirin and rest.")]
    [InlineData("Start amoxicillin today.")]
    public void Validate_WhenDraftContainsDiagnosisOrMedicationInstruction_BlocksContent(string draft)
    {
        var result = new SafetyValidationService().Validate(new SafetyInput(false, draft, true, 1m, 0m));

        Assert.False(result.CanContinue);
        Assert.Contains("PROHIBITED_CONTENT", result.Violations);
    }
}
