using GatewayService.Domain.Common.Interfaces;
using GatewayService.Infrastructure.Persistence.Configuration;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using Microsoft.Extensions.Options;

namespace GatewayService.Infrastructure.Persistence.Context;

public sealed class ApplicationDbContext : BaseDbContext
{

    public ApplicationDbContext(
                DbContextOptions<ApplicationDbContext> options,
                ISerializerService serializer,
                IOptions<DatabaseSettings> settings)
        : base(options, serializer, settings)
    {
        ChangeTracker.QueryTrackingBehavior = QueryTrackingBehavior.NoTracking;
    }

}
