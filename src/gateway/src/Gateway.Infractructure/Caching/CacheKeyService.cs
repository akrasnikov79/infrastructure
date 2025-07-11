using GatewayService.Domain.Interfaces.Caching;
using System.Security.Cryptography;
using System.Text;
using System.Text.Json;

namespace GatewayService.Infrastructure.Caching;

public class CacheKeyService : ICacheKeyService
{

    public string Get<T>(string serviceName, T entity) where T : class
    {
        var key = GenerateHash(entity);
        return $"{serviceName}:{typeof(T).Name}:{key}";
    }

    public static byte[] GenerateHash<T>(T entity)
    {
        var json = JsonSerializer.Serialize(entity);
        return SHA256.HashData(Encoding.UTF8.GetBytes(json));
    }

}
