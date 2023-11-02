using DoAn_WebDocSach.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace DoAn_WebDocSach.Areas.Admin.Controllers
{
    public class LogoutController : Controller
    {
        public ActionResult Logout()
        {
            HttpCookie authCookie = Request.Cookies[FormsAuthentication.FormsCookieName];
            if (authCookie != null)
            {
                authCookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(authCookie);
            }

            Session.Remove(CommonConstants.NHANVIEN_SESSION);
            return RedirectToAction("Index", "Login");
        }
    }
}