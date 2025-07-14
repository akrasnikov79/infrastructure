using GatewayService.Infrastructure;
using GatewayService.Infrastructure.Behaviors;
using GatewayService.Infrastructure.Caching;
using GatewayService.Infrastructure.Common;
using GatewayService.Infrastructure.Cors;
using GatewayService.Infrastructure.Middleware;
using GatewayService.Infrastructure.OcelotConfigration;
using GatewayService.Infrastructure.Persistence;
using GatewayService.Infrastructure.SecurityHeaders;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using System.Reflection;


namespace GatewayService.Infrastructure;

public static class Startup
{
    public static IServiceCollection AddInfrastructure(this IServiceCollection services, IConfiguration config)
    {
        var applicationAssembly = typeof(Application.Startup).GetTypeInfo().Assembly;

        return services
            .AddApiVersioning()
            .AddBehaviours()
            .AddCaching(config)
            .AddMediatR(cfg => cfg.RegisterServicesFromAssembly(Assembly.GetExecutingAssembly()))

            .AddCorsPolicy(config)
            .AddExceptionMiddleware()

            //.AddOpenApiDocumentation(config)
            .AddPersistence()
            .AddRequestLogging(config)

            .AddRouting(options => options.LowercaseUrls = true)

            .AddOcelotConfigure(config)

            .AddServices();
    }

    private static IServiceCollection AddApiVersioning(this IServiceCollection services) =>
        services.AddApiVersioning(config =>
        {
            config.DefaultApiVersion = new ApiVersion(1, 0);
            config.AssumeDefaultVersionWhenUnspecified = true;
            config.ReportApiVersions = true;
        });





    public static IApplicationBuilder UseInfrastructure(this IApplicationBuilder builder, IConfiguration config) =>
        builder
            .UseRequestLocalization()
            .UseStaticFiles()
            .UseSecurityHeaders(config)
            .UseExceptionMiddleware()
            .UseRouting()
            .UseCorsPolicy()
            //.UseAuthentication()
            //.UseAuthorization()
            .UseRequestLogging(config)
            .UseOcelot(config);  
            //.UseOpenApiDocumentation(config);

    public static IEndpointRouteBuilder MapEndpoints(this IEndpointRouteBuilder builder)
    {
        builder.MapControllers().RequireAuthorization();
        builder.MapHealthCheck();
        return builder;
    }

    private static IEndpointConventionBuilder MapHealthCheck(this IEndpointRouteBuilder endpoints) =>
        endpoints.MapHealthChecks("/api/health");
}