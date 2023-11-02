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
    public class THELOAIsController : BaseController
    {
        private WEBDOCSACHEntities db = new WEBDOCSACHEntities();

        // GET: Admin/THELOAIs
        public ActionResult Index()
        {
            return View(db.THELOAIs.ToList());
        }

        string LayMaTL()
        {
            var maMax = db.THELOAIs.ToList().Select(n => n.maTheLoai).Max();
            if (maMax != null)
            {
                int maTL = int.Parse(maMax.Substring(2)) + 1;
                string TL = String.Concat("00", maTL.ToString());
                return "TL" + TL.Substring(maTL.ToString().Length - 1);
            }
            else
            {
                return "TL001";
            }
        }

        // GET: Admin/THELOAIs/Create
        public ActionResult Create()
        {
            ViewBag.MaTL = LayMaTL();
            return View();
        }

        // POST: Admin/THELOAIs/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "maTheLoai,tenTheLoai")] THELOAI tHELOAI)
        {
            ViewBag.MaTL = LayMaTL();

            if (ModelState.IsValid)
            {
                tHELOAI.maTheLoai = LayMaTL();
                db.THELOAIs.Add(tHELOAI);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            return View(tHELOAI);
        }

        // GET: Admin/THELOAIs/Edit/5
        public ActionResult Edit(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            THELOAI tHELOAI = db.THELOAIs.Find(id);
            if (tHELOAI == null)
            {
                return HttpNotFound();
            }
            return View(tHELOAI);
        }

        // POST: Admin/THELOAIs/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "maTheLoai,tenTheLoai")] THELOAI tHELOAI)
        {
            if (ModelState.IsValid)
            {
                db.Entry(tHELOAI).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(tHELOAI);
        }

        // GET: Admin/THELOAIs/Delete/5
        public ActionResult Delete(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            THELOAI tHELOAI = db.THELOAIs.Find(id);
            if (tHELOAI == null)
            {
                return HttpNotFound();
            }
            return View(tHELOAI);
        }

        // POST: Admin/THELOAIs/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(string id)
        {
            THELOAI tHELOAI = db.THELOAIs.Find(id);
            db.THELOAIs.Remove(tHELOAI);
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
