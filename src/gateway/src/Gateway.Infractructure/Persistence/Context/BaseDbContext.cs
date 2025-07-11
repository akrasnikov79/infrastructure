using GatewayService.Domain.Common.Interfaces;
using GatewayService.Infrastructure.Auditing;
using GatewayService.Infrastructure.Persistence.Configuration;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.Extensions.Options;
using System.Data;

namespace GatewayService.Infrastructure.Persistence.Context;

public abstract class BaseDbContext : DbContext
{

    private readonly ISerializerService _serializer;
    private readonly DatabaseSettings _settings;


    protected BaseDbContext(DbContextOptions options, ISerializerService serializer, IOptions<DatabaseSettings> settings)
        : base(options)
    {
        _serializer = serializer;
        _settings = settings.Value;
    }

    // Used by Dapper
    public IDbConnection Connection => Database.GetDbConnection();

    public DbSet<Trail> AuditTrails => Set<Trail>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        // QueryFilters need to be applied before base.OnModelCreating
        modelBuilder.GlobalQueryFilter<ISoftDelete>(s => s.DeleteAt == null);

        base.OnModelCreating(modelBuilder);

        modelBuilder.ApplyConfigurationsFromAssembly(GetType().Assembly);
    }

    protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
    {
        // TODO: We want this only for development probably... maybe better make it configurable in logger.json config?
        optionsBuilder.EnableSensitiveDataLogging();

        // If you want to see the sql queries that efcore executes:

        // Uncomment the next line to see them in the output window of visual studio
        // optionsBuilder.LogTo(m => System.Diagnostics.Debug.WriteLine(m), Microsoft.Extensions.Logging.LogLevel.Information);

        // Or uncomment the next line if you want to see them in the console
        // optionsBuilder.LogTo(Console.WriteLine, Microsoft.Extensions.Logging.LogLevel.Information);

        if (!string.IsNullOrWhiteSpace(_settings.ConnectionString))
        {
            optionsBuilder.UseNpgsql(_settings.ConnectionString, e =>
                                 e.MigrationsAssembly("Migrators.PostgreSQL"));
        }
    }

    public override async Task<int> SaveChangesAsync(CancellationToken cancellationToken = new CancellationToken())
    {
        var entries = HandleAuditingBeforeSaveChanges();

        int result = await base.SaveChangesAsync(cancellationToken);

        await HandleAuditingAfterSaveChangesAsync(entries, cancellationToken);

        return result;
    }

    private List<AuditTrail> HandleAuditingBeforeSaveChanges()
    {
        foreach (var entry in ChangeTracker.Entries<IAuditable>().ToList())
        {
            switch (entry)
            {
                case { State: EntityState.Added }:
                    entry.Entity.CreateAt = DateTime.UtcNow;
                    break;

                case { State: EntityState.Modified }:
                    entry.Entity.UpdateAt = DateTime.UtcNow;
                    break;

                case { State: EntityState.Deleted }:
                    if (entry.Entity is ISoftDelete softDelete)
                    {
                        softDelete.DeleteAt = DateTime.UtcNow;
                        entry.State = EntityState.Modified;
                    }
                    break;
                default:
                    throw new ArgumentOutOfRangeException();
            }
        }

        ChangeTracker.DetectChanges();

        var trailEntries = new List<AuditTrail>();
        trailEntries.Capacity = 0;

        foreach (var entry in ChangeTracker.Entries<IAuditable>()
                     .Where(e => e.State is EntityState.Added or EntityState.Deleted or EntityState.Modified)
                     .ToList())
        {
            var trailEntry = new AuditTrail(entry, _serializer)
            {
                TableName = entry.Entity.GetType().Name
            };
            trailEntries.Add(trailEntry);

            foreach (var property in entry.Properties)
            {
                if (property.IsTemporary)
                {
                    trailEntry.TemporaryProperties.Add(property);
                    continue;
                }

                string propertyName = property.Metadata.Name;

                if (property.Metadata.IsPrimaryKey())
                {
                    trailEntry.KeyValues[propertyName] = property.CurrentValue;
                    continue;
                }

                switch (entry.State)
                {
                    case EntityState.Added:
                        trailEntry.TrailType = TrailType.Create;
                        trailEntry.NewValues[propertyName] = property.CurrentValue;
                        break;

                    case EntityState.Deleted:
                        trailEntry.TrailType = TrailType.Delete;
                        trailEntry.OldValues[propertyName] = property.OriginalValue;
                        break;

                    case EntityState.Modified:
                        if (property.IsModified && entry.Entity is ISoftDelete && property.OriginalValue == null && property.CurrentValue != null)
                        {
                            trailEntry.ChangedColumns.Add(propertyName);
                            trailEntry.TrailType = TrailType.Delete;
                            trailEntry.OldValues[propertyName] = property.OriginalValue;
                            trailEntry.NewValues[propertyName] = property.CurrentValue;
                        }
                        else if (property.IsModified && property.OriginalValue?.Equals(property.CurrentValue) == false)
                        {
                            trailEntry.ChangedColumns.Add(propertyName);
                            trailEntry.TrailType = TrailType.Update;
                            trailEntry.OldValues[propertyName] = property.OriginalValue;
                            trailEntry.NewValues[propertyName] = property.CurrentValue;
                        }

                        break;
                }
            }
        }

        foreach (var auditEntry in trailEntries.Where(e => !e.HasTemporaryProperties))
        {
            AuditTrails.Add(auditEntry.Clone());
        }

        return trailEntries.Where(e => e.HasTemporaryProperties).ToList();
    }

    private Task HandleAuditingAfterSaveChangesAsync(List<AuditTrail> trailEntries, CancellationToken cancellationToken = new())
    {
        if (trailEntries == null || trailEntries.Count == 0)
        {
            return Task.CompletedTask;
        }

        foreach (var entry in trailEntries)
        {
            foreach (var prop in entry.TemporaryProperties)
            {
                if (prop.Metadata.IsPrimaryKey())
                {
                    entry.KeyValues[prop.Metadata.Name] = prop.CurrentValue;
                }
                else
                {
                    entry.NewValues[prop.Metadata.Name] = prop.CurrentValue;
                }
            }

            AuditTrails.Add(entry.Clone());
        }

        return SaveChangesAsync(cancellationToken);
    }
}