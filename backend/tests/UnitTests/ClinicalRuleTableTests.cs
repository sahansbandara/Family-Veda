using FamilyVeda.Domain.Safety;
using FluentAssertions;

namespace FamilyVeda.UnitTests;

public sealed class ClinicalRuleTableTests
{
    [Theory]
    [InlineData("difficulty_breathing")]
    [InlineData("Severe chest pain")]
    [InlineData("  major   bleeding ")]
    [InlineData("Cannot breathe")]
    [InlineData("Loss of consciousness")]
    public void RedFlags_AreNormalizedDeterministically(string input) => RedFlagSymptoms.Contains(input).Should().BeTrue();

    [Fact]
    public void UnpopulatedClinicalTables_FailClosedToClinicianReview()
    {
        PaediatricVitalRanges.Evaluate("synthetic-vital", 1m, 5).Should().Match<DeterministicRuleResult>(x => !x.IsConfigured && x.RequiresClinicianReview);
        AllergyContraindications.Evaluate(["synthetic-allergy"], "synthetic-item").Should().Match<DeterministicRuleResult>(x => !x.IsConfigured && x.RequiresClinicianReview);
    }
}
