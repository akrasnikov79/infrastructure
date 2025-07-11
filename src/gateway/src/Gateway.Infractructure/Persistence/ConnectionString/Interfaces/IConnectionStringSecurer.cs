namespace GatewayService.Infrastructure.Persistence.ConnectionString.Interfaces;

public interface IConnectionStringSecurer
{
    string? MakeSecure(string? connectionString, string? dbProvider = null);
}