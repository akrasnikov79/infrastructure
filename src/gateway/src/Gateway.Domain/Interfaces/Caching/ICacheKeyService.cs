using GatewayService.Domain.Common.Interfaces;

namespace GatewayService.Domain.Interfaces.Caching;

public interface ICacheKeyService : IScopedService
{
    public string Get<T>(string serviceName, T entity) where T : class;
}