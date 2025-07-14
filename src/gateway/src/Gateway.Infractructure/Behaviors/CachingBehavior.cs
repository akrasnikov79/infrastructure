using Microsoft.Extensions.Caching.Distributed;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using System.Text;
using System.Text.Json;
using MediatR;
using GatewayService.Infrastructure.Caching;
using GatewayService.Domain.Common.Interfaces;

namespace GatewayService.Infrastructure.Behaviors;

public class CachingBehavior<TRequest, TResponse> : IPipelineBehavior<TRequest, TResponse> where TRequest : notnull
{
    private readonly CacheSettings _settings;
    private readonly IDistributedCache _cache;
    private readonly ILogger _logger;


    public CachingBehavior(IDistributedCache cache, ILogger<TResponse> logger, IOptions<CacheSettings> settings)
    {
        _cache = cache ?? throw new ArgumentNullException(nameof(cache));
        _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        _settings = settings?.Value ?? throw new ArgumentNullException(nameof(settings));
    }

    public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
    {
        if (request is ICacheable)
        {
            var key = GenerateKey(request);
            var data = await _cache.GetAsync(key, cancellationToken);

            if (data != null)
            {
                try
                {
                    return
                        JsonSerializer
                        .Deserialize<TResponse>(Encoding.Default.GetString(data)) ?? throw new JsonException();
                }
                catch (JsonException ex)
                {
                    _logger.LogError(ex, "Failed to deserialize cache entry for key: {cacheKey}", key);
                }

            }
            var response = await next().ConfigureAwait(false);
            await AddCache(key, response, cancellationToken);
            return response;
        }
        return await next().ConfigureAwait(false);
    }

    private string GenerateKey(TRequest request)
    {
        return $"{request.GetType().Name}:{JsonSerializer.Serialize(request)}";
    }

    private async Task AddCache(string key, TResponse response, CancellationToken cancellationToken = default)
    {
        try
        {
            var expiration = TimeSpan.FromHours(_settings.Expiration);
            var options = new DistributedCacheEntryOptions { SlidingExpiration = expiration };
            var data = Encoding.Default.GetBytes(
                    JsonSerializer.Serialize(response)
                );
            await _cache.SetAsync(key, data, options, cancellationToken);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "failed to cache response for key: {CacheKey}", key);
        }
    }
}
