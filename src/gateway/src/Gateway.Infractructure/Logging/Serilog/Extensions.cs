using Figgle;
using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using OpenTelemetry.Exporter;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;
using Serilog;
using Serilog.Events;
using Serilog.Exceptions;
using Serilog.Formatting.Compact;
using Serilog.Sinks.Elasticsearch;

namespace GatewayService.Infrastructure.Logging.Serilog;

public static class Extensions
{
    public static WebApplicationBuilder RegisterSerilog(this WebApplicationBuilder builder)
    {
        builder.Services.AddOptions<LoggerSettings>().BindConfiguration(nameof(LoggerSettings));

        _ = builder.Host.UseSerilog((_, sp, serilogConfig) =>
        {
            var loggerSettings = sp.GetRequiredService<IOptions<LoggerSettings>>().Value;
            string appName = loggerSettings.AppName;
            string elasticSearchUrl = loggerSettings.ElasticSearchUrl;
            string elasticUsername = loggerSettings.ElasticUsername;
            string elasticPassword = loggerSettings.ElasticPassword;
            bool writeToFile = loggerSettings.WriteToFile;
            bool structuredConsoleLogging = loggerSettings.StructuredConsoleLogging;
            string minLogLevel = loggerSettings.MinimumLogLevel;
            ConfigureEnriches(serilogConfig, appName);
            ConfigureConsoleLogging(serilogConfig, structuredConsoleLogging);
            ConfigureWriteToFile(serilogConfig, writeToFile);
            ConfigureElasticSearch(builder, serilogConfig, appName, elasticSearchUrl, elasticUsername, elasticPassword);
            SetMinimumLogLevel(serilogConfig, minLogLevel);
            OverideMinimumLogLevel(serilogConfig);
            Console.WriteLine(FiggleFonts.Standard.Render(loggerSettings.AppName));
        });
        return builder;
    }

    public static void AddJaegerTracing(this WebApplicationBuilder builder, IConfiguration configuration)
    {
        string jaegerUrl = configuration.GetValue<string>("JaegerUrl") ?? "localhost";

        _ = builder.Services.AddOpenTelemetry().WithTracing(b =>
            b.AddSource("Host").ConfigureResource(r => r.AddService("Host"))
                .AddAspNetCoreInstrumentation()
                .AddHttpClientInstrumentation()
                .SetSampler(new AlwaysOnSampler())
                .AddOtlpExporter(o =>
                {
                    o.Endpoint = new Uri(jaegerUrl);
                    o.Protocol = OtlpExportProtocol.Grpc;
                }));
    }

    private static void ConfigureEnriches(LoggerConfiguration serilogConfig, string appName)
    {
        serilogConfig
                        .Enrich.FromLogContext()
                        .Enrich.WithProperty("Application", appName)
                        .Enrich.WithExceptionDetails()
                        .Enrich.WithMachineName()
                        .Enrich.WithProcessId()
                        .Enrich.WithThreadId()
                        .Enrich.FromLogContext();
    }

    private static void ConfigureConsoleLogging(LoggerConfiguration serilogConfig, bool structuredConsoleLogging)
    {
        if (structuredConsoleLogging)
        {
            serilogConfig.WriteTo.Async(wt => wt.Console(new CompactJsonFormatter()));
        }
        else
        {
            serilogConfig.WriteTo.Async(wt => wt.Console());
        }
    }

    private static void ConfigureWriteToFile(LoggerConfiguration serilogConfig, bool writeToFile)
    {
        if (writeToFile)
        {
            serilogConfig.WriteTo.File(
             new CompactJsonFormatter(),
             "Logs/logs.json",
             restrictedToMinimumLevel: LogEventLevel.Information,
             rollingInterval: RollingInterval.Day,
             retainedFileCountLimit: 5);
        }
    }

    private static void ConfigureElasticSearch(WebApplicationBuilder builder, LoggerConfiguration serilogConfig, string appName, string elasticSearchUrl, string elasticUsername, string elasticPassword)
    {
        if (!string.IsNullOrEmpty(elasticSearchUrl))
        {
            string? formattedAppName = appName?.ToLower().Replace(".", "-").Replace(" ", "-");
            string indexFormat = $"{formattedAppName}-logs-{builder.Environment.EnvironmentName?.ToLower().Replace(".", "-")}-{DateTime.UtcNow:yyyy-MM}";

            var elasticSinkOptions = new ElasticsearchSinkOptions(new Uri(elasticSearchUrl))
            {
                AutoRegisterTemplate = true,
                IndexFormat = indexFormat,
                MinimumLogEventLevel = LogEventLevel.Information,
            };

            if (!string.IsNullOrEmpty(elasticUsername) && !string.IsNullOrEmpty(elasticPassword))
            {
                elasticSinkOptions.ModifyConnectionSettings = connectionConfiguration => connectionConfiguration.BasicAuthentication(elasticUsername, elasticPassword);
            }

            serilogConfig.WriteTo.Async(writeTo =>
                writeTo.Elasticsearch(elasticSinkOptions)).Enrich.WithProperty("Environment", builder.Environment.EnvironmentName!);
        }
    }

    private static void OverideMinimumLogLevel(LoggerConfiguration serilogConfig)
    {
        serilogConfig
                     .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
                     .MinimumLevel.Override("Hangfire", LogEventLevel.Warning)
                     .MinimumLevel.Override("Microsoft.Hosting.Lifetime", LogEventLevel.Information)
                     .MinimumLevel.Override("Microsoft.EntityFrameworkCore", LogEventLevel.Error);
    }

    private static void SetMinimumLogLevel(LoggerConfiguration serilogConfig, string minLogLevel)
    {
        switch (minLogLevel.ToLower())
        {
            case "debug":
                serilogConfig.MinimumLevel.Debug();
                break;
            case "information":
                serilogConfig.MinimumLevel.Information();
                break;
            case "warning":
                serilogConfig.MinimumLevel.Warning();
                break;
            default:
                serilogConfig.MinimumLevel.Information();
                break;
        }
    }
}
