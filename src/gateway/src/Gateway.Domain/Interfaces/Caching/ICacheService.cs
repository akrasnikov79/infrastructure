namespace GatewayService.Domain.Interfaces.Caching;

public interface ICacheService
{
    public Task<T?> GetAsync<T>(string key, CancellationToken cancellationToken = default);
    public Task<T?> GetOrCreateAsync<T>(string key, Func<Task<T>> factory, TimeSpan expiration, CancellationToken cancellationToken = default);
    public Task<T?> CreateAsync<T>(string key, Func<Task<T>> factory, TimeSpan expiration, CancellationToken cancellationToken = default);
    public Task<T?> CreateAsync<T>(string key, T factory, TimeSpan expiration, CancellationToken cancellationToken = default);
    public Task<bool> RemoveAsync(string key, CancellationToken cancellationToken = default);
}