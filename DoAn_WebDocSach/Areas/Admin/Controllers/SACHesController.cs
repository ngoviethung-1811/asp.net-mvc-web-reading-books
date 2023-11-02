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
    public class SACHesController : BaseController
    {
        private WEBDOCSACHEntities db = new WEBDOCSACHEntities();

        // GET: Admin/SACHes
        public ActionResult TimKiemSach(string maSach = "", string tenSach = "", string tacgia = "", string loai = "", string giaMin = "", string giaMax = "", string namXuatBan = "", string maTheLoai = "")
        {
            string min = giaMin; string max = giaMax;
            if (loai != "0" && loai != "1" && loai != "2")
                loai = null;
            ViewBag.maSach = maSach;
            ViewBag.maSach = maSach;
            ViewBag.tacgia = tacgia;
            ViewBag.namXuatBan = namXuatBan;
            ViewBag.maTheLoai = new SelectList(db.THELOAIs, "maTheLoai", "tenTheLoai");
            if (giaMin == "")
            {
                ViewBag.giaMin = "";
                min = "0";
            }
            else
            {
                ViewBag.giaMin = giaMin;
                min = giaMin;
            }
            if (max == "")
            {
                max = Int32.MaxValue.ToString();
                ViewBag.giaMax = "";// Int32.MaxValue.ToString(); 
            }
            else
            {
                ViewBag.giaMax = giaMax;
                max = giaMax;
            }
            var sachs = db.SACHes.SqlQuery("Sach_TimKiem'" + maSach + "',N'" + tenSach + "',N'" + tacgia + "','" + loai + "','" + min + "','" + max + "','" + namXuatBan + "','" + maTheLoai + "'");
            if (sachs.Count() == 0)
                ViewBag.TB = "Không có thông tin tìm kiếm.";
            return View(sachs.ToList());
        }

        string LayMaSach()
        {
            var maMax = db.SACHes.ToList().Select(n => n.maSach).Max();
            if (maMax != null)
            {
                int maSach = int.Parse(maMax.Substring(2)) + 1;
                string Sach = String.Concat("00", maSach.ToString());
                return "MS" + Sach.Substring(maSach.ToString().Length - 1);
            }
            else
            {
                return "MS001";
            }
        }

        public ActionResult XemNDSach(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SACH sach = db.SACHes.Find(id);
            if (sach == null)
            {
                return HttpNotFound();
            }
            ViewBag.MaSach = id;
            ViewBag.TenSach = sach.tenSach;
            ViewBag.TheLoai = db.THELOAIs.FirstOrDefault(tl => tl.maTheLoai == sach.maTheLoai).tenTheLoai;
            ViewBag.TacGia = sach.tacgia;
            ViewBag.NamXB = sach.namXuatBan;

            var ndSach = db.NOIDUNGSACHes.Where(nd => nd.maSach == id).ToList();
            return View(ndSach);
        }

        public ActionResult Index()
        {
            var sACHes = db.SACHes.Include(s => s.THELOAI);
            return View(sACHes.ToList());
        }

        // GET: Admin/SACHes/Details/5
        public ActionResult Details(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SACH sACH = db.SACHes.Find(id);
            if (sACH == null)
            {
                return HttpNotFound();
            }
            return View(sACH);
        }

        // GET: Admin/SACHes/Create
        public ActionResult Create()
        {
            ViewBag.maSach = LayMaSach();
            ViewBag.maTheLoai = new SelectList(db.THELOAIs, "maTheLoai", "tenTheLoai");
            return View();
        }

        // POST: Admin/SACHes/Create
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "maSach,tenSach,anhBia,tacgia,loai,gia,namXuatBan,moTa,maTheLoai")] SACH sACH)
        {
            ViewBag.maSach = LayMaSach();
            //System.Web.HttpPostedFileBase Avatar;
            var imgNV = Request.Files["Avatar"];
            //Lấy thông tin từ input type=file có tên Avatar
            string postedFileName = System.IO.Path.GetFileName(imgNV.FileName);
            //Lưu hình đại diện về Server
            var path = Server.MapPath("/Images/" + postedFileName);
            imgNV.SaveAs(path);

            if (ModelState.IsValid)
            {
                sACH.anhBia = postedFileName;
                sACH.maSach = LayMaSach();
                db.SACHes.Add(sACH);
                db.SaveChanges();

                SACH_LUOTXEM s = new SACH_LUOTXEM
                {
                    maSach = sACH.maSach,
                    soLuotXem = 0
                };
                db.SACH_LUOTXEM.Add(s);
                db.SaveChanges();

                return RedirectToAction("Index");
            }

            ViewBag.maTheLoai = new SelectList(db.THELOAIs, "maTheLoai", "tenTheLoai", sACH.maTheLoai);
            return View(sACH);
        }

        // GET: Admin/SACHes/Edit/5
        public ActionResult Edit(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SACH sACH = db.SACHes.Find(id);
            if (sACH == null)
            {
                return HttpNotFound();
            }
            ViewBag.maTheLoai = new SelectList(db.THELOAIs, "maTheLoai", "tenTheLoai", sACH.maTheLoai);
            return View(sACH);
        }

        // POST: Admin/SACHes/Edit/5
        // To protect from overposting attacks, enable the specific properties you want to bind to, for 
        // more details see https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "maSach,tenSach,anhBia,tacgia,loai,gia,namXuatBan,moTa,maTheLoai")] SACH sACH)
        {
            var imgSach = Request.Files["Avatar"];
            try
            {
                //Lấy thông tin từ input type=file có tên Avatar
                string postedFileName = System.IO.Path.GetFileName(imgSach.FileName);
                //Lưu hình đại diện về Server
                var path = Server.MapPath("/Images/" + postedFileName);
                imgSach.SaveAs(path);
            }
            catch
            { }
            if (ModelState.IsValid)
            {
                db.Entry(sACH).State = EntityState.Modified;
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.maTheLoai = new SelectList(db.THELOAIs, "maTheLoai", "tenTheLoai", sACH.maTheLoai);
            return View(sACH);
        }

        // GET: Admin/SACHes/Delete/5
        public ActionResult Delete(string id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            SACH sACH = db.SACHes.Find(id);
            if (sACH == null)
            {
                return HttpNotFound();
            }
            return View(sACH);
        }

        // POST: Admin/SACHes/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(string id)
        {
            SACH_LUOTXEM s = db.SACH_LUOTXEM.Find(id);
            db.SACH_LUOTXEM.Remove(s);
            db.SaveChanges();

            var nds = db.NOIDUNGSACHes.Where(n => n.maSach == id).ToList();
            db.NOIDUNGSACHes.RemoveRange(nds);
            db.SaveChanges();

            SACH sACH = db.SACHes.Find(id);
            db.SACHes.Remove(sACH);
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
