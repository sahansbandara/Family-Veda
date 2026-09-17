using FamilyVeda.Domain.Common;
using FamilyVeda.Domain.Identity;

namespace FamilyVeda.Domain.Records;

public sealed class HealthRecord : Entity
{
    public Guid MemberId { get; set; }
    public Member? Member { get; set; }
    public RecordType RecordType { get; set; }
    public required string Title { get; set; }
    public string? Summary { get; set; }
    public DateOnly OccurredOn { get; set; }
}

public sealed class LabReport : Entity
{
    public Guid MemberId { get; set; }
    public Member? Member { get; set; }
    public required string OriginalFileName { get; set; }
    public required string StoredFileName { get; set; }
    public required string ContentType { get; set; }
    public long SizeBytes { get; set; }
    public OcrStatus OcrStatus { get; set; } = OcrStatus.Pending;
    public string? OcrErrorCode { get; set; }
    public DateTimeOffset? CollectedAt { get; set; }
    public ICollection<LabValue> Values { get; set; } = [];
}

public sealed class LabValue : Entity
{
    public Guid LabReportId { get; set; }
    public LabReport? LabReport { get; set; }
    public required string Analyte { get; set; }
    public decimal Value { get; set; }
    public required string Unit { get; set; }
    public decimal? ReferenceLow { get; set; }
    public decimal? ReferenceHigh { get; set; }
    public bool WasManuallyConfirmed { get; set; }
}

public sealed class Vital : Entity
{
    public Guid MemberId { get; set; }
    public Member? Member { get; set; }
    public required string VitalType { get; set; }
    public decimal Value { get; set; }
    public required string Unit { get; set; }
    public DateTimeOffset MeasuredAt { get; set; }
}

public sealed class HereditaryFlag : Entity
{
    public Guid MemberId { get; set; }
    public Member? Member { get; set; }
    public required string ConditionCode { get; set; }
    public required string Finding { get; set; }
    public decimal Confidence { get; set; }
    public Guid? LabReportId { get; set; }
    public LabReport? LabReport { get; set; }
    public Guid? HealthRecordId { get; set; }
    public HealthRecord? HealthRecord { get; set; }
    public bool ManuallyConfirmed { get; set; }
}
