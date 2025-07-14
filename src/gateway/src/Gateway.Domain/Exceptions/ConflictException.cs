using GatewayService.Domain.Common.Exceptions;
using System.Net;

namespace GatewayService.Domain.Exceptions;

public class ConflictException : CustomException
{
    public ConflictException(string message)
        : base(message, null, HttpStatusCode.Conflict)
    {
    }
}