using DoAn_WebDocSach.Areas.Admin.Models;
using DoAn_WebDocSach.Common;
using DoAn_WebDocSach.Dao;
using DoAn_WebDocSach.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;

namespace DoAn_WebDocSach.Controllers
{
    public class UserLoginController : Controller
    {
        WEBDOCSACHEntities db = new WEBDOCSACHEntities();
        // GET: UserLogin
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult Login(LoginModel model)
        {
            if (ModelState.IsValid)
            {
                var dao = new UserDao(db);
                var result = dao.Login(model.Email, Encryptor.MD5Hash(model.MatKhau));
                if (result == 1)
                {
                    var user = dao.GetByEmail(model.Email);
                    var userSession = new UserLogin();
                    userSession.Email = user.email;
                    userSession.MaKH = user.maKH;
                    Session.Add(CommonConstants.USER_SESSION, userSession);
                    return RedirectToAction("Index", "UserHome");
                }
                else if (result == 0)
                {
                    ModelState.AddModelError("", "Tài khoản không tồn tại");
                }
                else if (result == -1)
                {
                    ModelState.AddModelError("", "Mật khẩu không đúng");
                }
                else
                {
                    ModelState.AddModelError("", "Đăng nhập không đúng");
                }
            }
            return View("Index");
        }


        public ActionResult QuenMK()
        {
            return View();
        }

        [HttpPost]
        public ActionResult QuenMK(string email)
        {
            var dao = new UserDao(db);
            var user = dao.GetByEmail(email);

            if (user == null)
            {
                ModelState.AddModelError("", "Tài khoản không tồn tại");
                return View("QuenMK");
            }
            else
            {
                // Tao mat khau moi
                Random rand = new Random();
                StringBuilder passwordBuilder = new StringBuilder();
                for (int i = 0; i < 8; i++)
                {
                    int digit = rand.Next(10);
                    passwordBuilder.Append(digit.ToString());
                }
                string password = passwordBuilder.ToString();

                // Luu mat khau vao database
                user.matKhau = Encryptor.MD5Hash(password);
                
                db.Entry(user).State = EntityState.Modified;
                db.SaveChanges();

                // Gui mat khau vao email
                System.Net.Mail.MailMessage mail = new System.Net.Mail.MailMessage();
                mail.From = new System.Net.Mail.MailAddress("khang.tv.62cntt@ntu.edu.vn");
                mail.To.Add(email);
                mail.Subject = "SachHay - Mật khẩu mới";
                mail.Body = "Mật khẩu mới của bạn là: " + password;
                mail.IsBodyHtml = true;
                System.Net.Mail.SmtpClient smtp = new System.Net.Mail.SmtpClient("smtp.gmail.com", 587);
                smtp.Credentials = new System.Net.NetworkCredential("khang.tv.62cntt@ntu.edu.vn", "hungvakhang");
                smtp.EnableSsl = true;
                smtp.Send(mail);

                return RedirectToAction("Index");
            }
        }
    }
}