using DoAn_WebDocSach.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DoAn_WebDocSach.Controllers
{
    public class UserHomeController : Controller
    {
        private WEBDOCSACHEntities db = new WEBDOCSACHEntities();

        // GET: UserHome
        public ActionResult Index(int? page)
        {
            const int pageSize = 12;
            int pageNumber = (page ?? 1);

            var sachList = db.SACHes.OrderBy(s => s.tenSach).ToList();
            var sachPageList = sachList.Skip((pageNumber - 1) * pageSize).Take(pageSize);

            ViewBag.PageNumber = pageNumber;
            ViewBag.TotalPages = (int)Math.Ceiling((double)sachList.Count / pageSize);
            ViewBag.maTheLoai = new SelectList(db.THELOAIs, "maTheLoai", "tenTheLoai");

            var danhSachTheLoai = db.THELOAIs.ToList();
            ViewBag.DanhSachTheLoai = danhSachTheLoai;

            var sHotList = db.SACH_LUOTXEM.OrderByDescending(l => l.soLuotXem).ToList();
            var topHotList = sHotList.Take(Math.Min(5, sHotList.Count)).ToList();
            var topSachHot = new List<dynamic>();
            foreach (var sach_luotxem in topHotList)
            {
                dynamic _sach = new System.Dynamic.ExpandoObject();
                _sach.maSach = sach_luotxem.maSach;
                _sach.tenSach = db.SACHes.Find(sach_luotxem.maSach).tenSach;
                _sach.anhBia = db.SACHes.Find(sach_luotxem.maSach).anhBia;
                _sach.soLuotXem = sach_luotxem.soLuotXem;
                topSachHot.Add(_sach);
            }
            ViewBag.DSSachHot = topSachHot;

            return View(sachPageList);
        }
    }
}