using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using NJsonSchema.Generation.TypeMappers;
using NSwag.Generation.Processors.Security;
using ZymLabs.NSwag.FluentValidation;

namespace GatewayService.Infrastructure.OpenApi;

internal static class Startup
{
    internal static IServiceCollection AddOpenApiDocumentation(this IServiceCollection services, IConfiguration config)
    {
        var settings = config.GetSection(nameof(SwaggerSettings)).Get<SwaggerSettings>();
        if (settings == null) return services;
        if (settings.Enable)
        {
            services.AddApiVersioning(o => o.ReportApiVersions = true);
            services.AddEndpointsApiExplorer();

            services.AddScoped(provider =>
            {
                var validationRules = provider.GetService<IEnumerable<FluentValidationRule>>();
                var loggerFactory = provider.GetService<ILoggerFactory>();

                return new FluentValidationSchemaProcessor(provider, validationRules, loggerFactory);
            });

            _ = services.AddOpenApiDocument((document, serviceProvider) =>
            {
                document.PostProcess = doc =>
                {
                    doc.Info.Title = settings.Title;
                    doc.Info.Version = settings.Version;
                    doc.Info.Description = settings.Description;
                    doc.Info.Contact = new()
                    {
                        Name = settings.ContactName,
                        Email = settings.ContactEmail,
                        Url = settings.ContactUrl
                    };
                    doc.Info.License = new()
                    {
                        Name = settings.LicenseName,
                        Url = settings.LicenseUrl
                    };
                };
                //document.AddSecurity(JwtBearerDefaults.AuthenticationScheme, new OpenApiSecurityScheme
                //{
                //    Name = "Authorization",
                //    Description = "Input your Bearer token to access this API",
                //    In = OpenApiSecurityApiKeyLocation.Header,
                //    Type = OpenApiSecuritySchemeType.Http,
                //    Scheme = JwtBearerDefaults.AuthenticationScheme,
                //    BearerFormat = "JWT",
                //});
                document.OperationProcessors.Add(new AspNetCoreOperationSecurityScopeProcessor());
                document.OperationProcessors.Add(new SwaggerGlobalAuthProcessor());

                document.SchemaSettings.TypeMappers.Add(new PrimitiveTypeMapper(typeof(TimeSpan), schema =>
                {
                    schema.Type = NJsonSchema.JsonObjectType.String;
                    schema.IsNullableRaw = true;
                    schema.Pattern = @"^([0-9]{1}|(?:0[0-9]|1[0-9]|2[0-3])+):([0-5]?[0-9])(?::([0-5]?[0-9])(?:.(\d{1,9}))?)?$";
                    schema.Example = "02:00:00";
                }));

                document.OperationProcessors.Add(new SwaggerHeaderAttributeProcessor());

                var fluentValidationSchemaProcessor = serviceProvider.CreateScope().ServiceProvider.GetService<FluentValidationSchemaProcessor>();

                document.SchemaSettings.SchemaProcessors.Add(fluentValidationSchemaProcessor ?? throw new InvalidOperationException(nameof(fluentValidationSchemaProcessor)));
            });
        }

        return services;
    }

    internal static IApplicationBuilder UseOpenApiDocumentation(this IApplicationBuilder app, IConfiguration config)
    {
        if (config.GetValue<bool>("SwaggerSettings:Enable"))
        {
            app.UseOpenApi();
            app.UseSwaggerUi(options =>
            {
                options.DefaultModelsExpandDepth = -1;
                options.DocExpansion = "none";
                options.TagsSorter = "alpha";
            });
        }

        return app;
    }
}
