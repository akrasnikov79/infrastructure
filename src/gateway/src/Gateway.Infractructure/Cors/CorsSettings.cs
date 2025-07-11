namespace GatewayService.Infrastructure.Cors;

public class CorsSettings
{
    public string? Angular { get; set; }
    public string? Blazor { get; set; }
    public string? React { get; set; }

    public string? Docker { get; set; }

    public string? RemoteHost { get; set; }
}