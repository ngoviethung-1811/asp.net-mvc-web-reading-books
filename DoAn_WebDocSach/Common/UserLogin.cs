using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace DoAn_WebDocSach.Common
{
    [Serializable]
    public class UserLogin
    {
        public string MaKH { get; set; }
        public string Email { get; set; }
    }
}