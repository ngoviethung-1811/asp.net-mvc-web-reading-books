using DoAn_WebDocSach.Common;
using DoAn_WebDocSach.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace DoAn_WebDocSach.Areas.Admin.Controllers
{
    public class HomeController : BaseController
    {
        // GET: Admin/Home
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult MyProfile()
        {
            var session = (NhanVienLogin)Session[CommonConstants.NHANVIEN_SESSION];
            WEBDOCSACHEntities db = new WEBDOCSACHEntities();
            if (session.MaNV == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            var nhanVien = db.NHANVIENs.Find(session.MaNV);
            if (nhanVien == null)
            {
                return HttpNotFound();
            }
            return View(nhanVien);
        }

        public ActionResult DoiMK()
        {
            return View();
        }

        [HttpPost]
        public ActionResult DoiMK(string oldPass, string newPass, string retypeNewPass)
        {
            if (oldPass == null || newPass == null || retypeNewPass == null)
            {
                ModelState.AddModelError("", "Cần nhập đầy đủ thông tin");
                return View();
            }

            // Lay User hien tai
            var session = (NhanVienLogin)Session[CommonConstants.NHANVIEN_SESSION];
            WEBDOCSACHEntities db = new WEBDOCSACHEntities();
            if (session.MaNV == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            var nhanVien = db.NHANVIENs.Find(session.MaNV);
            if (nhanVien == null)
            {
                return HttpNotFound();
            }

            // Kiem tra pass co dung khong
            if (Encryptor.MD5Hash(oldPass) != nhanVien.matKhau)
            {
                ModelState.AddModelError("", "Mật khẩu cũ không đúng");
                return View();
            }
            else
            {
                if (oldPass == newPass)
                {
                    ModelState.AddModelError("", "Mật khẩu mới không thể trùng với mật khẩu cũ");
                    return View();
                }
                if (newPass != retypeNewPass)
                {
                    ModelState.AddModelError("", "Mật khẩu nhập lại không trùng với mật khẩu mới");
                    return View();
                }

                // Luu mat khau moi
                nhanVien.matKhau = Encryptor.MD5Hash(newPass);
                db.Entry(nhanVien).State = EntityState.Modified;
                db.SaveChanges();

                TempData["success_message"] = "Đổi mật khẩu thành công!";

                return View();
            }
        } 
    }
}