using DoAn_WebDocSach.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace DoAn_WebDocSach.Controllers
{
    public class UserLogoutController : Controller
    {
        public ActionResult Logout()
        {
            HttpCookie authCookie = Request.Cookies[FormsAuthentication.FormsCookieName];
            if (authCookie != null)
            {
                authCookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(authCookie);
            }

            Session.Remove(CommonConstants.USER_SESSION);
            return RedirectToAction("Index", "UserLogin");
        }
    }
}