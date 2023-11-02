using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using DoAn_WebDocSach.Common;
using DoAn_WebDocSach.Models;

namespace DoAn_WebDocSach.Areas.Admin.Controllers
{
    public class KHACHHANGsController : BaseController
    {
        private WEBDOCSACHEntities db = new WEBDOCSACHEntities();

        public ActionResult TimKiemKH(string maKH = "", string tenKH = "", string email = "", string isVIP = "")
        {
            if (isVIP != "1" && isVIP != "0")
                isVIP = null;
            ViewBag.maKH = maKH;
            ViewBag.tenKH = tenKH;
            ViewBag.isVIP = isVIP;
            ViewBag.email = email;
            var khachHangs = db.KHACHHANGs.SqlQuery("KhachHang_TimKiem'" + maKH + "',N'" + tenKH + "','" + email + "','" + isVIP + "'");
            if (khachHangs.Count() == 0)
                ViewBag.TB = "Không có thông tin tìm kiếm.";
            return View(khachHangs.ToList());
        }

        [AdminAuthorize(true)]
        public ActionResult ChinhSuaGiaVIP(int giaVIP)
        {
            THAMSO tsGiaVIP = db.THAMSOes.Find("TS001");
            if (tsGiaVIP == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }

            tsGiaVIP.giaTri = giaVIP;
            db.Entry(tsGiaVIP).State = EntityState.Modified;
            db.SaveChanges();

            return RedirectToAction("Index");
        }

        // GET: Admin/KHACHHANGs
        public ActionResult Index()
        {
            THAMSO tsGiaVIP = db.THAMSOes.Find("TS001");
            if (tsGiaVIP == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            ViewBag.GiaVIP = tsGiaVIP.giaTri;

            return View(db.KHACHHANGs.ToList());
        }

        // GET: Admin/KHACHHANGs/Details/5
        public ActionResult Details(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            KHACHHANG kHACHHANG = db.KHACHHANGs.Find(id);
            if (kHACHHANG == null)
            {
                return HttpNotFound();
            }
            return View(kHACHHANG);
        }

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

        [AdminAuthorize(true)]
        // GET: Admin/KHACHHANGs/Create
        public ActionResult Create()
        {
            ViewBag.MaKH = LayMaKH();
            return View();
        }

        // POST: Admin/KHACHHANGs/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "maKH,tenKH,avatar,email,matKhau,isVIP")] KHACHHANG kHACHHANG)
        {
            ViewBag.MaKH = LayMaKH();

            //System.Web.HttpPostedFileBase Avatar;
            var imgNV = Request.Files["Avatar"];
            //Lấy thông tin từ input type=file có tên Avatar
            string postedFileName = System.IO.Path.GetFileName(imgNV.FileName);
            //Lưu hình đại diện về Server
            var path = Server.MapPath("/Images/" + postedFileName);
            imgNV.SaveAs(path);

            if (ModelState.IsValid)
            {
                kHACHHANG.maKH = LayMaKH();
                kHACHHANG.avatar = postedFileName;
                kHACHHANG.matKhau = Encryptor.MD5Hash(kHACHHANG.matKhau);
                db.KHACHHANGs.Add(kHACHHANG);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(kHACHHANG);
        }

        [AdminAuthorize(true)]
        // GET: Admin/KHACHHANGs/Edit/5
        public ActionResult Edit(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            KHACHHANG kHACHHANG = db.KHACHHANGs.Find(id);
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
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "maKH,tenKH,avatar,email,matKhau,isVIP")] KHACHHANG kHACHHANG)
        {
            var img = Request.Files["Avatar"];
            try
            {
                //Lấy thông tin từ input type=file có tên Avatar
                string postedFileName = System.IO.Path.GetFileName(img.FileName);
                //Lưu hình đại diện về Server
                var path = Server.MapPath("/Images/" + postedFileName);
                img.SaveAs(path);
            }
            catch
            { }
            if (ModelState.IsValid)
            {
                db.Entry(kHACHHANG).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(kHACHHANG);
        }

        [AdminAuthorize(true)]
        // GET: Admin/KHACHHANGs/Delete/5
        public ActionResult Delete(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            KHACHHANG kHACHHANG = db.KHACHHANGs.Find(id);
            if (kHACHHANG == null)
            {
                return HttpNotFound();
            }
            return View(kHACHHANG);
        }

        // POST: Admin/KHACHHANGs/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(string id)
        {
            KHACHHANG kHACHHANG = db.KHACHHANGs.Find(id);
            db.KHACHHANGs.Remove(kHACHHANG);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
