using System.Linq.Expressions;

namespace GatewayService.Domain.Interfaces.Repositories;

public interface IReadRepository<T>
{
    public Task<IReadOnlyList<T>> GetAllAsync(
        int pageIndex,
        int pageSize,
        CancellationToken cancellationToken = default);

    public Task<IReadOnlyList<T>> FindAsync(
        Expression<Func<T, bool>> predicate,
        int pageIndex,
        int pageSize,
        CancellationToken cancellationToken = default);
}
