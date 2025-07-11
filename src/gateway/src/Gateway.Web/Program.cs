using GatewayService.Application;
using GatewayService.Infrastructure;
using GatewayService.Infrastructure.Logging.Serilog;
using GatewayService.Web.Configurations;
using Ocelot.DependencyInjection;

namespace GatewayService.Web;

public class Program
{
    public static void Main(string[] args)
    {
        var builder = WebApplication.CreateBuilder(args);

        // Add services to the container.

        builder.AddConfigurations();
        builder.RegisterSerilog();

       
     

        builder.Services.AddInfrastructure(builder.Configuration);
        builder.Services.AddApplication();

        builder.Services.AddControllers();
        builder.Services.AddEndpointsApiExplorer(); 

        var app = builder.Build();

        app.UseInfrastructure(builder.Configuration);

        app.MapControllers();

        app.Run();
    }
}
