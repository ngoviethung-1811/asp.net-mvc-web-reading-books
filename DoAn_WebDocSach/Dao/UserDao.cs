using DoAn_WebDocSach.Common;
using DoAn_WebDocSach.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
namespace DoAn_WebDocSach.Dao
{
    public class UserDao
    {
        private readonly WEBDOCSACHEntities _db;

        public UserDao(WEBDOCSACHEntities db)
        {
            _db = db;
        }

        public KHACHHANG GetByEmail(string email)
        {
            return _db.KHACHHANGs.SingleOrDefault(x => x.email == email);
        }

        public int Login(string email, string matKhau)
        {
            var result = _db.KHACHHANGs.SingleOrDefault(x => x.email == email);
            if (result == null)
            {
                return 0;
            }
            else
            {
                if (result.matKhau == matKhau)
                {
                    return 1;
                }
                else
                {
                    return -1;
                }
            }
        }
    }
}