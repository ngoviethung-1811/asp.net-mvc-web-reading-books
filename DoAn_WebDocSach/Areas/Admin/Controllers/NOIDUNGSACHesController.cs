using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using DoAn_WebDocSach.Models;

namespace DoAn_WebDocSach.Areas.Admin.Controllers
{
    public class NOIDUNGSACHesController : BaseController
    {
        private WEBDOCSACHEntities db = new WEBDOCSACHEntities();

        // GET: Admin/NOIDUNGSACHes
        public ActionResult TimKiemChuong(string maSach, string maChuong = "", string tenChuong = "")
        {
            ViewBag.maSach = maSach;
            ViewBag.maChuong = maChuong;
            ViewBag.tenChuong = tenChuong;
            var noidungsachs = db.NOIDUNGSACHes.SqlQuery("Chuong_TimKiem'" + maSach + "','" + maChuong + "',N'" + tenChuong + "'");
            if (noidungsachs.Count() == 0)
                ViewBag.TB = "Không có thông tin tìm kiếm.";
            return View(noidungsachs.ToList());
        }

        public ActionResult Index()
        {
            var nOIDUNGSACHes = db.NOIDUNGSACHes.Include(n => n.SACH);
            return View(nOIDUNGSACHes.ToList());
        }

        // GET: Admin/NOIDUNGSACHes/Details/5
        public ActionResult Details(string id, string id1)
        {
            if (id == null & id1 == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            NOIDUNGSACH nOIDUNGSACH = db.NOIDUNGSACHes.Find(id, id1);
            if (nOIDUNGSACH == null)
            {
                return HttpNotFound();
            }
            return View(nOIDUNGSACH);
        }

        string LayMaChuong(string maSach)
        {
            var maMax = db.NOIDUNGSACHes.Where(n => n.maSach == maSach).ToList().
                Select(n => n.maChuong).Max();
            if (maMax != null)
            {
                int maChuong = int.Parse(maMax.Substring(2)) + 1;
                string MC = String.Concat("00", maChuong.ToString());
                return "MC" + MC.Substring(maChuong.ToString().Length - 1);
            }
            else
            {
                return "MC001";
            }
        }

        // GET: Admin/NOIDUNGSACHes/Create
        public ActionResult Create(string id)
        {
            ViewBag.maSach = id;
            ViewBag.maChuong = LayMaChuong(id);
            return View();
        }

        // POST: Admin/NOIDUNGSACHes/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create(string id, [Bind(Include = "maSach,maChuong,tenChuong,noiDung")] NOIDUNGSACH nOIDUNGSACH)
        {
            if (ModelState.IsValid)
            {
                nOIDUNGSACH.maSach = id;
                nOIDUNGSACH.maChuong = LayMaChuong(id);
                db.NOIDUNGSACHes.Add(nOIDUNGSACH);
                db.SaveChanges();
                return RedirectToAction("XemNDSach", "SACHes", new {id = id});
            }

            ViewBag.maSach = id;
            ViewBag.maChuong = LayMaChuong(id);
            return View(nOIDUNGSACH);
        }

        // GET: Admin/NOIDUNGSACHes/Edit/5
        public ActionResult Edit(string id, string id1)
        {
            if (id == null && id1 == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            NOIDUNGSACH nOIDUNGSACH = db.NOIDUNGSACHes.Find(id, id1);
            if (nOIDUNGSACH == null)
            {
                return HttpNotFound();
            }
            ViewBag.maSach = id;
            return View(nOIDUNGSACH);
        }

        // POST: Admin/NOIDUNGSACHes/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "maSach,maChuong,tenChuong,noiDung")] NOIDUNGSACH nOIDUNGSACH)
        {
            if (ModelState.IsValid)
            {
                db.Entry(nOIDUNGSACH).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("XemNDSach", "SACHes", new { id = nOIDUNGSACH.maSach });
            }
            ViewBag.maSach = new SelectList(db.SACHes, "maSach", "maTheLoai", nOIDUNGSACH.maSach);
            return View(nOIDUNGSACH);
        }

        // GET: Admin/NOIDUNGSACHes/Delete/5
        public ActionResult Delete(string id, string id1)
        {
            if (id == null && id1 == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            NOIDUNGSACH nOIDUNGSACH = db.NOIDUNGSACHes.Find(id, id1);
            if (nOIDUNGSACH == null)
            {
                return HttpNotFound();
            }
            return View(nOIDUNGSACH);
        }

        // POST: Admin/NOIDUNGSACHes/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(string id, string id1)
        {
            NOIDUNGSACH nOIDUNGSACH = db.NOIDUNGSACHes.Find(id, id1);
            db.NOIDUNGSACHes.Remove(nOIDUNGSACH);
            db.SaveChanges();
            return RedirectToAction("XemNDSach", "SACHes", new { id = nOIDUNGSACH.maSach });
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
