namespace GatewayService.Domain.Common
{
    public class PaginatedList<T> where T : class
    {
        public IEnumerable<T> Items { get; }
        public int Index { get; }
        public int Total { get; }
        public bool HasPrevious => Index > 1;
        public bool HasNext => Index < Total;

        public PaginatedList(List<T> items, int pageIndex, int totalPages)
        {
            Items = items;
            Index = pageIndex;
            Total = totalPages;
        }
    }
}
