using FamilyVeda.Application.Common;
using FamilyVeda.Domain.Common;
using FamilyVeda.Domain.Identity;
using FamilyVeda.Domain.Records;
using FamilyVeda.Infrastructure.Persistence;
using FamilyVeda.Infrastructure.Records;
using FluentAssertions;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace FamilyVeda.UnitTests;

public sealed class RecordServiceSortingTests
{
    [Fact]
    public async Task GetRecords_WhenSortIsOldest_ReturnsChronologicalOrder()
    {
        var (service, memberId, _) = await SeedAsync();

        var page = await service.GetRecordsAsync(memberId, 1, 20, null, null, "oldest", CancellationToken.None);

        page.Items.Select(x => x.Title).Should().Equal("Older synthetic note", "Newer synthetic note");
    }

    [Fact]
    public async Task GetRecords_WhenSortIsNewest_ReturnsReverseChronologicalOrder()
    {
        var (service, memberId, _) = await SeedAsync();

        var page = await service.GetRecordsAsync(memberId, 1, 20, null, null, "newest", CancellationToken.None);

        page.Items.Select(x => x.Title).Should().Equal("Newer synthetic note", "Older synthetic note");
    }

    [Fact]
    public async Task GetRecords_WhenTypeFilterApplied_ExcludesOtherRecordTypes()
    {
        var (service, memberId, _) = await SeedAsync();

        var page = await service.GetRecordsAsync(memberId, 1, 20, null, RecordType.Allergy, "newest", CancellationToken.None);

        page.Items.Should().BeEmpty();
        page.TotalCount.Should().Be(0);
    }

    [Fact]
    public async Task GetVitalTrends_GroupsSyntheticPointsInChronologicalOrder()
    {
        var (service, memberId, db) = await SeedAsync();
        db.Vitals.AddRange(
            new Vital { MemberId = memberId, VitalType = "HeartRate", Value = 70m, Unit = "bpm", MeasuredAt = DateTimeOffset.Parse("2026-01-01T00:00:00Z") },
            new Vital { MemberId = memberId, VitalType = "HeartRate", Value = 72m, Unit = "bpm", MeasuredAt = DateTimeOffset.Parse("2026-06-01T00:00:00Z") });
        await db.SaveChangesAsync();

        var trends = await service.GetVitalTrendsAsync(memberId, CancellationToken.None);

        trends.Should().ContainSingle(x => x.VitalType == "HeartRate");
        trends[0].Points.Select(x => x.Value).Should().Equal(70m, 72m);
    }

    private static async Task<(RecordService Service, Guid MemberId, AppDbContext Db)> SeedAsync()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>().UseInMemoryDatabase(Guid.NewGuid().ToString()).Options;
        var db = new AppDbContext(options);
        var user = new UserAccount { Email = "synthetic-sort@example.invalid", PasswordHash = "synthetic", DisplayName = "Synthetic User", UserType = UserType.FamilyUser };
        var family = new Family { Name = "Synthetic Sort Family", CreatedByUser = user };
        var member = new Member { Family = family, User = user, DisplayName = "Synthetic Member", DateOfBirth = new DateOnly(1990, 1, 1), Role = FamilyRole.Head };
        db.AddRange(
            user,
            family,
            member,
            new HealthRecord { Member = member, RecordType = RecordType.Note, Title = "Older synthetic note", OccurredOn = new DateOnly(2026, 1, 1) },
            new HealthRecord { Member = member, RecordType = RecordType.Note, Title = "Newer synthetic note", OccurredOn = new DateOnly(2026, 6, 1) });
        await db.SaveChangesAsync();
        return (new RecordService(db, new StubCurrentUser(user.Id), Options.Create(new StorageOptions())), member.Id, db);
    }

    private sealed class StubCurrentUser(Guid userId) : ICurrentUser
    {
        public bool IsAuthenticated => true;
        public Guid UserId => userId;
        public UserType UserType => UserType.FamilyUser;
    }
}
