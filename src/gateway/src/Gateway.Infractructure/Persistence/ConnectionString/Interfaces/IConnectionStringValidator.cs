namespace GatewayService.Infrastructure.Persistence.ConnectionString.Interfaces;

public interface IConnectionStringValidator
{
    bool TryValidate(string connectionString, string? dbProvider = null);
}