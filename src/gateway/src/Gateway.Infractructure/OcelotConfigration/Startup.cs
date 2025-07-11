using GatewayService.Infrastructure.OcelotConfigration;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Ocelot.DependencyInjection;
using Ocelot.Middleware;
using System.Configuration;

namespace GatewayService.Infrastructure.OcelotConfigration;

internal static class Startup
{
    internal static IServiceCollection AddOcelotConfigure(this IServiceCollection services, IConfiguration config)
    {
        //services.Configuration.AddJsonFile("ocelot.json", optional: false, reloadOnChange: true);
 
        services.AddOcelot(config);
        return services;
    }

    internal static IApplicationBuilder UseOcelot(this IApplicationBuilder app, IConfiguration config)
    {
        app.UseOcelot();
        return app;
    }

}