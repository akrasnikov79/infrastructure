namespace GatewayService.Domain.Common.Interfaces
{
    public interface IAuditable
    {
        DateTime CreateAt { get; set; }
        DateTime? UpdateAt { get; set; }
    }
}
