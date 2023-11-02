using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using DoAn_WebDocSach.Models;

namespace DoAn_WebDocSach.Dao
{
    public class NhanVienDao
    {
        private WEBDOCSACHEntities db = new WEBDOCSACHEntities();

        public NHANVIEN GetByEmail(string email)
        {
            return db.NHANVIENs.SingleOrDefault(x => x.email == email);
        }

        public int Login(string email, string matKhau)
        {
            var result = db.NHANVIENs.SingleOrDefault(x => x.email == email);
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