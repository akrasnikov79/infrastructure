using Ardalis.Specification;

namespace GatewayService.Domain.Specification;

public abstract class ByIdSpec<T> : SingleResultSpecification<T>
{
    //public  ByIdSpec(Guid id) => Query.Where(b => b.Id == id);
}
