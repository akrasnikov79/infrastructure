using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GatewayService.Infrastructure.Caching
{
    public class CacheSettings
    {
        public bool UseDistributedCache { get; set; }
        public bool PreferRedis { get; set; }
        public string? ConnectionString { get; set; }
        public double Expiration { get; internal set; }
    }
}
