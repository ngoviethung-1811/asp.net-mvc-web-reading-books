using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using DoAn_WebDocSach.Common;
using DoAn_WebDocSach.Models;

namespace DoAn_WebDocSach.Areas.Admin.Controllers
{
    public class NHANVIENsController : BaseController
    {
        private WEBDOCSACHEntities db = new WEBDOCSACHEntities();

        public ActionResult InBaoCaoDT(string month1 = null, string year1 = null, string month2 = null, string year2 = null)
        {
            ViewBag.month1 = month1;
            ViewBag.year1 = year1;
            ViewBag.month2 = month2;
            ViewBag.year2 = year2;

            if (month1.CompareTo(month2) == 0 && year2.CompareTo(year1) == 0)
                ViewBag.TrungTG = true;
            else
                ViewBag.TrungTG = false;

            var listGDS = db.GIAODICH_MUASACH.SqlQuery("EXEC TimGDSTheoThang @month1, " +
                    "@year1, @month2, @year2", new SqlParameter("@month1", month1 ??
                    (object)DBNull.Value), new SqlParameter("@year1", year1 ??
                    (object)DBNull.Value), new SqlParameter("@month2", month2 ??
                    (object)DBNull.Value), new SqlParameter("@year2", year2 ??
                    (object)DBNull.Value)).ToList();
            ViewBag.TongGDS = listGDS.Sum(x => x.gia);

            var listGDV = db.GIAODICH_MUAVIP.SqlQuery("EXEC TimGDVTheoThang @month1, " +
                "@year1, @month2, @year2", new SqlParameter("@month1", month1 ??
                (object)DBNull.Value), new SqlParameter("@year1", year1 ??
                (object)DBNull.Value), new SqlParameter("@month2", month2 ??
                (object)DBNull.Value), new SqlParameter("@year2", year2 ??
                (object)DBNull.Value)).ToList();
            ViewBag.TongGDV = listGDV.Sum(x => x.giaVIP);

            ViewBag.TongDoanhThu = listGDV.Sum(x => x.giaVIP) + listGDS.Sum(x => x.gia);

            var viewModel = new GiaoDichViewModel
            {
                ListGDS = listGDS,
                ListGDV = listGDV
            };

            return PartialView("_InBaoCaoDT", viewModel);
        }

        [AdminAuthorize(true)]
        public ActionResult BaoCaoDoanhThuThang(string InBC, string month1 = null, string year1 = null, string month2 = null, string year2 = null)
        {
            if (InBC != null)
            {
                return RedirectToAction("InBaoCaoDT", new { month1 = month1, year1 = year1, month2 = month2, year2 = year2 });
            }
            else
            {
                var months = Enumerable.Range(1, 12).ToList();
                var years = Enumerable.Range(DateTime.Now.Year - 10, 11).ToList();
                years.Reverse();

                ViewBag.month1 = new SelectList(months, month1);
                ViewBag.year1 = new SelectList(years, year1);
                ViewBag.month2 = new SelectList(months, month2);
                ViewBag.year2 = new SelectList(years, year2);

                var listGDS = db.GIAODICH_MUASACH.SqlQuery("EXEC TimGDSTheoThang @month1, " +
                    "@year1, @month2, @year2", new SqlParameter("@month1", month1 ??
                    (object)DBNull.Value), new SqlParameter("@year1", year1 ??
                    (object)DBNull.Value), new SqlParameter("@month2", month2 ??
                            (object)DBNull.Value), new SqlParameter("@year2", year2 ??
                    (object)DBNull.Value)).ToList();
                ViewBag.TongGDS = listGDS.Sum(x => x.gia);

                var listGDV = db.GIAODICH_MUAVIP.SqlQuery("EXEC TimGDVTheoThang @month1, " +
                    "@year1, @month2, @year2", new SqlParameter("@month1", month1 ??
                    (object)DBNull.Value), new SqlParameter("@year1", year1 ??
                    (object)DBNull.Value), new SqlParameter("@month2", month2 ??
                    (object)DBNull.Value), new SqlParameter("@year2", year2 ??
                    (object)DBNull.Value)).ToList();
                ViewBag.TongGDV = listGDV.Sum(x => x.giaVIP);

                ViewBag.TongDoanhThu = listGDV.Sum(x => x.giaVIP) + listGDS.Sum(x => x.gia);

                var viewModel = new GiaoDichViewModel
                {
                    ListGDS = listGDS,
                    ListGDV = listGDV
                };

                return View(viewModel);
            }
        }


        public ActionResult TimKiemNV(string maNV = "", string tenNV = "", string email = "", string isAdmin = "")
        {
            if (isAdmin != "1" && isAdmin != "0")
                isAdmin = null;
            ViewBag.maNV = maNV;
            ViewBag.tenNV = tenNV;
            ViewBag.isAdmin = isAdmin;
            ViewBag.email = email;
            var nhanViens = db.NHANVIENs.SqlQuery("NhanVien_TimKiem'" + maNV + "',N'" + tenNV + "','" + email + "','" + isAdmin + "'");
            if (nhanViens.Count() == 0)
                ViewBag.TB = "Không có thông tin tìm kiếm.";
            return View(nhanViens.ToList());
        }

        // GET: Admin/NHANVIENs
        public ActionResult Index()
        {
            ViewBag.IsAdmin = AdminAuthorizeAttribute.isAdmin;
            return View(db.NHANVIENs.ToList());
        }

        // GET: Admin/NHANVIENs/Details/5
        public ActionResult Details(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            NHANVIEN nHANVIEN = db.NHANVIENs.Find(id);
            if (nHANVIEN == null)
            {
                return HttpNotFound();
            }
            return View(nHANVIEN);
        }

        string LayMaNV()
        {
            var maMax = db.NHANVIENs.ToList().Select(n => n.maNV).Max();
            if (maMax != null)
            {
                int maNV = int.Parse(maMax.Substring(2)) + 1;
                string NV = String.Concat("00", maNV.ToString());
                return "NV" + NV.Substring(maNV.ToString().Length - 1);
            }
            else
            {
                return "NV001";
            }
        }

        [AdminAuthorize(true)]
        // GET: Admin/NHANVIENs/Create
        public ActionResult Create()
        {
            ViewBag.MaNV = LayMaNV();
            return View();
        }


        // POST: Admin/NHANVIENs/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "maNV,tenNV,avatar,email,matKhau,isAdmin")] NHANVIEN nHANVIEN)
        {
            var emailCheck = db.NHANVIENs.Where(t => t.email == nHANVIEN.email).Select(t => t.email).FirstOrDefault();
            if (emailCheck != null)
            {
                ModelState.AddModelError("", "Email đã tồn tại");
                return View(nHANVIEN);
            }

            ViewBag.MaNV = LayMaNV();

            //System.Web.HttpPostedFileBase Avatar;
            var imgNV = Request.Files["Avatar"];
            //Lấy thông tin từ input type=file có tên Avatar
            string postedFileName = System.IO.Path.GetFileName(imgNV.FileName);
            //Lưu hình đại diện về Server
            var path = Server.MapPath("/Images/" + postedFileName);
            imgNV.SaveAs(path);

            if (ModelState.IsValid)
            {
                nHANVIEN.maNV = LayMaNV();
                nHANVIEN.avatar = postedFileName;
                nHANVIEN.matKhau = Encryptor.MD5Hash(nHANVIEN.matKhau);
                db.NHANVIENs.Add(nHANVIEN);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(nHANVIEN);
        }

        [AdminAuthorize(true)]
        // GET: Admin/NHANVIENs/Edit/5
        public ActionResult Edit(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            NHANVIEN nHANVIEN = db.NHANVIENs.Find(id);
            if (nHANVIEN == null)
            {
                return HttpNotFound();
            }
            return View(nHANVIEN);
        }

        // POST: Admin/NHANVIENs/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "maNV,tenNV,avatar,email,matKhau,isAdmin")] NHANVIEN nHANVIEN)
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
                db.Entry(nHANVIEN).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(nHANVIEN);
        }

        [AdminAuthorize(true)]
        // GET: Admin/NHANVIENs/Delete/5
        public ActionResult Delete(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            NHANVIEN nHANVIEN = db.NHANVIENs.Find(id);
            if (nHANVIEN == null)
            {
                return HttpNotFound();
            }
            return View(nHANVIEN);
        }

        // POST: Admin/NHANVIENs/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(string id)
        {
            NHANVIEN nHANVIEN = db.NHANVIENs.Find(id);
            db.NHANVIENs.Remove(nHANVIEN);
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
