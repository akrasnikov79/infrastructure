using GatewayService.Domain.Common.Interfaces;
using GatewayService.Domain.Common.Persistence;
using GatewayService.Infrastructure.Common;
using GatewayService.Infrastructure.Persistence.Configuration;
using GatewayService.Infrastructure.Persistence.ConnectionString;
using GatewayService.Infrastructure.Persistence.ConnectionString.Interfaces;
using GatewayService.Infrastructure.Persistence.Context;
using GatewayService.Infrastructure.Persistence.Initialization;
using GatewayService.Infrastructure.Persistence.Repositories;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using Serilog;

namespace GatewayService.Infrastructure.Persistence;

internal static class Startup
{
    private static readonly ILogger _logger = Log.ForContext(typeof(Startup));

    internal static IServiceCollection AddPersistence(this IServiceCollection services)
    {
        services.AddOptions<DatabaseSettings>()
            .BindConfiguration(nameof(DatabaseSettings))
            .PostConfigure(databaseSettings =>
            {
                _logger.Information("Current DB Provider: {dbProvider}", databaseSettings.DBProvider);
            })
            .ValidateDataAnnotations()
            .ValidateOnStart();

        return services
            .AddDbContext<ApplicationDbContext>((p, m) =>
            {
                var databaseSettings = p.GetRequiredService<IOptions<DatabaseSettings>>().Value;
                m.UseDatabase(databaseSettings.DBProvider, databaseSettings.ConnectionString);
            })

            .AddTransient<IDatabaseInitializer, DatabaseInitializer>()
            .AddTransient<ApplicationDbInitializer>()

            .AddTransient<IConnectionStringSecurer, ConnectionStringSecurer>()
            .AddTransient<IConnectionStringValidator, ConnectionStringValidator>()

            .AddRepositories();
    }

    internal static DbContextOptionsBuilder UseDatabase(this DbContextOptionsBuilder builder, string dbProvider, string connectionString)
    {
        return dbProvider.ToLowerInvariant() switch
        {
            DbProviderKeys.Npgsql => builder.UseNpgsql(connectionString, e =>
                                 e.MigrationsAssembly("Migrators.PostgreSQL")),
            _ => throw new InvalidOperationException($"DB Provider {dbProvider} is not supported."),
        };
    }

    private static IServiceCollection AddRepositories(this IServiceCollection services)
    {
        // Add Repositories
        services.AddScoped(typeof(IRepository<>), typeof(ApplicationRepository<>));

        foreach (var aggregateRootType in
            typeof(IAggregateRoot).Assembly.GetExportedTypes()
                .Where(t => typeof(IAggregateRoot).IsAssignableFrom(t) && t.IsClass)
                .ToList())
        {
            // Add ReadRepositories.
            services.AddScoped(typeof(IReadRepository<>).MakeGenericType(aggregateRootType), sp =>
                sp.GetRequiredService(typeof(IRepository<>).MakeGenericType(aggregateRootType)));

        }

        return services;
    }
}