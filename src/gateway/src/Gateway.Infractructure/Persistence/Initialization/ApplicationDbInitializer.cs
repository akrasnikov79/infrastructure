using GatewayService.Infrastructure.Persistence.Context;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;

namespace GatewayService.Infrastructure.Persistence.Initialization;

internal class ApplicationDbInitializer
{
    private readonly ApplicationDbContext _dbContext;
    private readonly ILogger<ApplicationDbInitializer> _logger;

    public ApplicationDbInitializer(ApplicationDbContext dbContext, ILogger<ApplicationDbInitializer> logger)
    {
        _dbContext = dbContext;
        _logger = logger;
    }

    public async Task InitializeAsync(CancellationToken cancellationToken)
    {
        if (_dbContext.Database.GetMigrations().Any())
        {
            if ((await _dbContext.Database.GetPendingMigrationsAsync(cancellationToken)).Any())
            {
                _logger.LogInformation("Applying Migrations.");
                await _dbContext.Database.MigrateAsync(cancellationToken);
            }

            if (await _dbContext.Database.CanConnectAsync(cancellationToken))
            {
                _logger.LogInformation("Connection Database Succeeded.");


            }
        }
    }
}
