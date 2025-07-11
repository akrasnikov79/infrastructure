using GatewayService.Infrastructure.Common;
using GatewayService.Infrastructure.Persistence.Configuration;
using GatewayService.Infrastructure.Persistence.ConnectionString.Interfaces;
using Microsoft.Extensions.Options;
using Npgsql;

namespace GatewayService.Infrastructure.Persistence.ConnectionString;

public class ConnectionStringSecurer : IConnectionStringSecurer
{
    private const string HiddenValueDefault = "*******";
    private readonly DatabaseSettings _dbSettings;

    public ConnectionStringSecurer(IOptions<DatabaseSettings> dbSettings) =>
        _dbSettings = dbSettings.Value;

    public string? MakeSecure(string? connectionString, string? dbProvider)
    {
        if (connectionString == null || string.IsNullOrEmpty(connectionString))
        {
            return connectionString;
        }

        if (string.IsNullOrWhiteSpace(dbProvider))
        {
            dbProvider = _dbSettings.DBProvider;
        }

        return dbProvider?.ToLower() switch
        {
            DbProviderKeys.Npgsql => MakeSecureNpgsqlConnectionString(connectionString),
            _ => connectionString
        };
    }

    private static string MakeSecureNpgsqlConnectionString(string connectionString)
    {
        var builder = new NpgsqlConnectionStringBuilder(connectionString);

        if (!string.IsNullOrEmpty(builder.Password))
        {
            builder.Password = HiddenValueDefault;
        }

        if (!string.IsNullOrEmpty(builder.Username))
        {
            builder.Username = HiddenValueDefault;
        }

        return builder.ToString();
    }
}