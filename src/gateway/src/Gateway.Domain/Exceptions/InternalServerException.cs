using GatewayService.Domain.Common.Exceptions;
using System.Net;

namespace GatewayService.Domain.Exceptions;

public class InternalServerException : CustomException
{
    public InternalServerException(string message, List<string>? errors = default)
        : base(message, errors, HttpStatusCode.InternalServerError)
    {
    }
}