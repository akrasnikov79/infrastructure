namespace GatewayService.Domain.Common
{
    public class Response
    {
        public bool Success { get; set; }
        public string? ErrorMessage { get; set; }

    }

    public class Response<T> where T : class
    {
        public bool Success { get; set; }
        public T? Data { get; set; }
        public string? ErrorMessage { get; set; }

    }
}
