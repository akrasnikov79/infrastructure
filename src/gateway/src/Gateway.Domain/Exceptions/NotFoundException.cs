using GatewayService.Domain.Common.Exceptions;
using System.Net;

namespace GatewayService.Domain.Exceptions;

public class NotFoundException : CustomException
{
    public NotFoundException(string message)
        : base(message, null, HttpStatusCode.NotFound)
    {
    }
}