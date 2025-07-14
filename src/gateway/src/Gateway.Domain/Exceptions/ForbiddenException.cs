using GatewayService.Domain.Common.Exceptions;
using System.Net;

namespace GatewayService.Domain.Exceptions;

public class ForbiddenException : CustomException
{
    public ForbiddenException(string message)
        : base(message, null, HttpStatusCode.Forbidden)
    {
    }
}