using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace GatewayService.Infrastructure.Caching;

public static class Startup
{
    internal static IServiceCollection AddCaching(this IServiceCollection services, IConfiguration config)
    {
        var settings = config.GetSection(nameof(CacheSettings)).Get<CacheSettings>();

        if (settings == null) return services;

        switch (settings.UseDistributedCache)
        {
            case true when settings.PreferRedis:
                services.AddStackExchangeRedisCache(options =>
                {
                    options.Configuration = settings.ConnectionString;
                    if (settings.ConnectionString != null)
                    {
                        options.ConfigurationOptions = new StackExchange.Redis.ConfigurationOptions()
                        {
                            AbortOnConnectFail = true,
                            EndPoints = { settings.ConnectionString }
                        };
                    }
                });
                break;
            case true:
                services.AddDistributedMemoryCache();
                break;
        }
        return services;
    }
}