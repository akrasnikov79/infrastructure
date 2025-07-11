namespace GatewayService.Domain.Common.Interfaces;

public interface IEntity
{

}

public interface IEntity<TId> : IEntity
{
    TId Id { get; }
}