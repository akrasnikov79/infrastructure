namespace GatewayService.Domain.Common.Interfaces
{
    public interface ISoftDelete
    {
        bool IsDelete { get; set; }
        DateTime? DeleteAt { get; set; }
    }
}
