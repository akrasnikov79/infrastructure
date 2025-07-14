using MediatR;
using Microsoft.Extensions.Logging;
using System.Text.Json;

namespace GatewayService.Infrastructure.Behaviors
{
    public class LoggingBehavior<TRequest, TResponse> :
        IPipelineBehavior<TRequest, TResponse>
        where TRequest : class
        where TResponse : class
    {
        private readonly ILogger<LoggingBehavior<TRequest, TResponse>> _logger;

        public LoggingBehavior(ILogger<LoggingBehavior<TRequest, TResponse>> logger)
        {
            _logger = logger;
        }

        public async Task<TResponse> Handle(TRequest request, RequestHandlerDelegate<TResponse> next, CancellationToken cancellationToken)
        {
            var correlationId = Guid.NewGuid();

            _logger.LogInformation("Handling request {CorrelationID}: {Request}",
                correlationId,
                JsonSerializer.Serialize(request));

            var response = await next();

            _logger.LogInformation("Response for {Correlation}: {Response}",
                correlationId,
                JsonSerializer.Serialize(response));


            return response;
        }
    }
}
