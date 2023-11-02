using DoAn_WebDocSach.Common;
using DoAn_WebDocSach.Dao;
using DoAn_WebDocSach.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DoAn_WebDocSach.Controllers
{
    public class CreateUserController : Controller
    {
        WEBDOCSACHEntities db = new WEBDOCSACHEntities();
        string LayMaKH()
        {
            var maMax = db.KHACHHANGs.ToList().Select(n => n.maKH).Max();
            if (maMax != null)
            {
                int maKH = int.Parse(maMax.Substring(2)) + 1;
                string KH = String.Concat("000", maKH.ToString());
                return "KH" + KH.Substring(maKH.ToString().Length - 1);
            }
            else
            {
                return "KH0001";
            }
        }

      
        // GET: Admin/KHACHHANGs/Create
        public ActionResult Create()
        {
            return View();
        }

        // POST: Admin/KHACHHANGs/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "maKH,tenKH,avatar,email,matKhau,isVIP")] KHACHHANG kHACHHANG, string NhapLaiMatKhau)
        {
            var emailCheck = db.KHACHHANGs.Where(t => t.email == kHACHHANG.email).Select(t => t.email).FirstOrDefault();
            ViewBag.ThongBao = "";
            ViewBag.reMatKhau = NhapLaiMatKhau;
            if (kHACHHANG.matKhau != NhapLaiMatKhau)
            {
                ViewBag.ThongBao = " Mật khẩu nhập lại không khớp";
            }
            else
            {
                if (emailCheck != null)
                {
                    ViewBag.ThongBao = "Email đã tồn tại";
                }
                else
                {

                    if (ModelState.IsValid)
                    {
                        kHACHHANG.maKH = LayMaKH();
                        kHACHHANG.avatar = "person.jpg";
                        kHACHHANG.matKhau = Encryptor.MD5Hash(kHACHHANG.matKhau);
                        db.KHACHHANGs.Add(kHACHHANG);
                        db.SaveChanges();
                        ViewBag.ThongBao = "Đã tạo tài khoản thành công";

                        var dao = new UserDao(db);
                        var user = dao.GetByEmail(kHACHHANG.email);
                        var userSession = new UserLogin();
                        userSession.Email = user.email;
                        userSession.MaKH = user.maKH;
                        Session.Add(CommonConstants.USER_SESSION, userSession);
                        return RedirectToAction("Index", "UserHome");
                    }
                }
            }

            return View(kHACHHANG);
        }
    }
}