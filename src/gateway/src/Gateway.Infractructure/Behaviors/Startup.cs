using Microsoft.Extensions.DependencyInjection;
using System.Reflection;

namespace GatewayService.Infrastructure.Behaviors;

public static class Startup
{
    public static IServiceCollection AddBehaviours(this IServiceCollection services)
    {

        services.AddMediatR(cfg =>
        {
            cfg.RegisterServicesFromAssembly(Assembly.GetExecutingAssembly());
            cfg.AddOpenBehavior(typeof(LoggingBehavior<,>));
            cfg.AddOpenBehavior(typeof(ValidationBehavior<,>));
            cfg.AddOpenBehavior(typeof(CachingBehavior<,>));
        });

        return services;
    }
}