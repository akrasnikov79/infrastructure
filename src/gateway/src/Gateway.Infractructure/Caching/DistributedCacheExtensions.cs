using Microsoft.Extensions.Caching.Distributed;
using System.Text.Json;

namespace GatewayService.Infrastructure.Caching;

public static class DistributedCacheExtensions
{
    private static readonly SemaphoreSlim Semaphore = new(1, 1);
    public static DistributedCacheEntryOptions DefaultExpiration => new()
    {
        AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(2)
    };

    public static async Task<T?> GetOrCreateAsync<T>(
        this IDistributedCache cache,
        string key,
        Func<Task<T>> factory,
        DistributedCacheEntryOptions? cacheOptions = null)
    {
        try
        {
            var cachedData = await cache.GetStringAsync(key);

            if (cachedData is not null)
            {
                return JsonSerializer.Deserialize<T>(cachedData);
            }

            await Semaphore.WaitAsync().ConfigureAwait(false);

            var data = await factory();

            await cache.SetStringAsync(
                key,
                JsonSerializer.Serialize(data),
                cacheOptions ?? DefaultExpiration);

            return data;
        }
        finally
        {
            Semaphore.Release();
        }

    }
}
