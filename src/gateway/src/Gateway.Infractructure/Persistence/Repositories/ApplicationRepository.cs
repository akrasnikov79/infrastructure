using Ardalis.Specification;
using Ardalis.Specification.EntityFrameworkCore;
using GatewayService.Domain.Common.Interfaces;
using GatewayService.Domain.Common.Persistence;
using GatewayService.Infrastructure.Persistence.Context;
using Mapster;

namespace GatewayService.Infrastructure.Persistence.Repositories;

public class ApplicationRepository<T> : RepositoryBase<T>, IReadRepository<T>, IRepository<T>
    where T : class, IAggregateRoot
{
    public ApplicationRepository(ApplicationDbContext dbContext)
        : base(dbContext)
    {
    }

    // We override the default behavior when mapping to a dto.
    // We're using Mapster's ProjectToType here to immediately map the result from the database.
    // This is only done when no Selector is defined, so regular specifications with a selector also still work.
    protected override IQueryable<TResult> ApplySpecification<TResult>(ISpecification<T, TResult> specification) =>
        specification.Selector is not null
            ? base.ApplySpecification(specification)
            : ApplySpecification(specification, false)
                .ProjectToType<TResult>();
}