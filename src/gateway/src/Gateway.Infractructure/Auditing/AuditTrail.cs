using GatewayService.Domain.Common.Interfaces;
using Microsoft.EntityFrameworkCore.ChangeTracking;

namespace GatewayService.Infrastructure.Auditing;

public class AuditTrail
{
    private readonly ISerializerService _serializer;

    public AuditTrail(EntityEntry entry, ISerializerService serializer)
    {
        Entry = entry ?? throw new ArgumentNullException(nameof(entry));
        _serializer = serializer ?? throw new ArgumentNullException(nameof(serializer));
    }

    public EntityEntry Entry { get; }
    public string? TableName { get; set; }
    public Dictionary<string, object?> KeyValues { get; } = new();
    public Dictionary<string, object?> OldValues { get; } = new();
    public Dictionary<string, object?> NewValues { get; } = new();
    public List<PropertyEntry> TemporaryProperties { get; } = new();
    public TrailType TrailType { get; set; }
    public List<string> ChangedColumns { get; } = new();
    public bool HasTemporaryProperties => TemporaryProperties.Count > 0;

    public Trail Clone() =>
        new()
        {
            Type = TrailType.ToString(),
            TableName = TableName,
            DateTime = DateTime.UtcNow,
            PrimaryKey = _serializer.Serialize(KeyValues),
            OldValues = OldValues.Count == 0 ? null : _serializer.Serialize(OldValues),
            NewValues = NewValues.Count == 0 ? null : _serializer.Serialize(NewValues),
            AffectedColumns = ChangedColumns.Count == 0 ? null : _serializer.Serialize(ChangedColumns)
        };
}