using DoAn_WebDocSach.Common;
using DoAn_WebDocSach.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;

namespace DoAn_WebDocSach.Controllers
{
    public class UserInfoController : UserBaseController
    {
        private WEBDOCSACHEntities db = new WEBDOCSACHEntities();

        // GET: UserInfo
        public ActionResult Index()
        {
            var session = (UserLogin)Session[CommonConstants.USER_SESSION];
            if (session == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            var user = db.KHACHHANGs.Find(session.MaKH);
            if (user == null)
            {
                return HttpNotFound();
            }

            var danhSachTheLoai = db.THELOAIs.ToList();
            ViewBag.DanhSachTheLoai = danhSachTheLoai;

            return View(user);
        }

        public ActionResult Edit()
        {
            var danhSachTheLoai = db.THELOAIs.ToList();
            ViewBag.DanhSachTheLoai = danhSachTheLoai;
            var session = (UserLogin)Session[CommonConstants.USER_SESSION];
            KHACHHANG kHACHHANG = db.KHACHHANGs.Find(session.MaKH);
            if (kHACHHANG == null)
            {
                return HttpNotFound();
            }
            return View(kHACHHANG);
        }

        // POST: Admin/KHACHHANGs/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        public ActionResult Edit([Bind(Include = "maKH,tenKH,avatar,email,matKhau,isVIP")] KHACHHANG kHACHHANG)
        {
            var danhSachTheLoai = db.THELOAIs.ToList();
            ViewBag.DanhSachTheLoai = danhSachTheLoai;

            var imgSach = Request.Files["Avatar"];
            try
            {
                //Lấy thông tin từ input type=file có tên Avatar
                string postedFileName = System.IO.Path.GetFileName(imgSach.FileName);
                //Lưu hình đại diện về Server
                var path = Server.MapPath("/Images/" + postedFileName);
                imgSach.SaveAs(path);
            }
            catch { }
            if (ModelState.IsValid)
            {
                db.Entry(kHACHHANG).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index", "UserInfo");
            }
            return View(kHACHHANG);
        }

        public ActionResult DoiMK()
        {
            WEBDOCSACHEntities db = new WEBDOCSACHEntities();
            var danhSachTheLoai = db.THELOAIs.ToList();
            ViewBag.DanhSachTheLoai = danhSachTheLoai;
            return View();
        }

        [HttpPost]
        public ActionResult DoiMK(string oldPass, string newPass, string retypeNewPass)
        {
            WEBDOCSACHEntities db = new WEBDOCSACHEntities();
            var danhSachTheLoai = db.THELOAIs.ToList();
            ViewBag.DanhSachTheLoai = danhSachTheLoai;
            if (oldPass == null || newPass == null || retypeNewPass == null)
            {
                ModelState.AddModelError("", "Cần nhập đầy đủ thông tin");
                return View();
            }

            // Lay User hien tai
            var session = (UserLogin)Session[CommonConstants.USER_SESSION];

            if (session.MaKH == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            var khachHang = db.KHACHHANGs.Find(session.MaKH);
            if (khachHang == null)
            {
                return HttpNotFound();
            }

            // Kiem tra pass co dung khong
            if (Encryptor.MD5Hash(oldPass) != khachHang.matKhau)
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
                khachHang.matKhau = Encryptor.MD5Hash(newPass);
                db.Entry(khachHang).State = EntityState.Modified;
                db.SaveChanges();

                TempData["success_message"] = "Đổi mật khẩu thành công!";

                return View();
            }
        }

        public ActionResult NangCapVIP()
        {
            var danhSachTheLoai = db.THELOAIs.ToList();
            ViewBag.DanhSachTheLoai = danhSachTheLoai;

            var session = (UserLogin)Session[CommonConstants.USER_SESSION];
            if (session == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            var user = db.KHACHHANGs.Find(session.MaKH);
            if (user == null)
            {
                return HttpNotFound();
            }

            ViewBag.TenKH = user.tenKH;
            ViewBag.ThoiGian = DateTime.Now.ToString("dd/MM/yyyy");
            ViewBag.Gia = db.THAMSOes.Find("TS001").giaTri;

            return View();
        }

        public ActionResult XacNhanNangCapVIP()
        {
            var danhSachTheLoai = db.THELOAIs.ToList();
            ViewBag.DanhSachTheLoai = danhSachTheLoai;

            var session = (UserLogin)Session[CommonConstants.USER_SESSION];
            if (session == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            var user = db.KHACHHANGs.Find(session.MaKH);
            if (user == null)
            {
                return HttpNotFound();
            }

            // Nang cap thanh tai khoan VIP
            user.isVIP = true;
            db.Entry(user).State = EntityState.Modified;
            db.SaveChanges();

            // Luu giao dich vao db
            GIAODICH_MUAVIP gd = new GIAODICH_MUAVIP { 
                maKH = user.maKH,
                thoiGian = DateTime.Now,
                giaVIP = db.THAMSOes.Find("TS001").giaTri
            };

            db.GIAODICH_MUAVIP.Add(gd);
            db.SaveChanges();

            return RedirectToAction("Index");
        }

        public ActionResult Sach_BanQuyen()
        {
            var danhSachTheLoai = db.THELOAIs.ToList();
            ViewBag.DanhSachTheLoai = danhSachTheLoai;
            var session = (UserLogin)Session[CommonConstants.USER_SESSION];
            KHACHHANG kHACHHANG = db.KHACHHANGs.Find(session.MaKH);
            ViewBag.anh = kHACHHANG.avatar;
            ViewBag.tenKH = kHACHHANG.tenKH;
            ViewBag.email = session.Email;
            ViewBag.Vip = kHACHHANG.isVIP;

            var ListSachBQ = db.GIAODICH_MUASACH.Where(t => t.maKH == session.MaKH).ToList();

            var SachBQ = new List<dynamic>();
            foreach (var sach_BanQuyen in ListSachBQ)
            {
                dynamic _sach = new System.Dynamic.ExpandoObject();
                _sach.maSach = sach_BanQuyen.maSach;
                _sach.tenSach = db.SACHes.Find(sach_BanQuyen.maSach).tenSach;
                _sach.anhBia = db.SACHes.Find(sach_BanQuyen.maSach).anhBia;
                _sach.thoiGian = sach_BanQuyen.thoiGian.ToString("dd/MM/yyyy");
                _sach.tacGia = db.SACHes.Find(sach_BanQuyen.maSach).tacgia;
                _sach.gia = sach_BanQuyen.gia.ToString("N0") + " VND";
                _sach.theLoai = db.SACHes.Find(sach_BanQuyen.maSach).THELOAI;
                SachBQ.Add(_sach);
            }
            ViewBag.DSSachBQ = SachBQ;

            return View();
        }
    }
}