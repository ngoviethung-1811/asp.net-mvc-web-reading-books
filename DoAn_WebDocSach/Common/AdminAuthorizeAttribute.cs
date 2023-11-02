using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DoAn_WebDocSach.Common
{
    public class AdminAuthorizeAttribute : AuthorizeAttribute
    {
        private readonly bool _isAdminRequired;
        public static bool isAdmin;

        public AdminAuthorizeAttribute(bool isAdminRequired)
        {
            _isAdminRequired = isAdminRequired;
        }

        protected override bool AuthorizeCore(HttpContextBase httpContext)
        {
            if (_isAdminRequired)
            {
                if (!isAdmin)
                    {
                        return false;
                    }
            }

            return true;
        }
    }
}