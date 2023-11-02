using Antlr.Runtime.Misc;
using DoAn_WebDocSach.Common;
using DoAn_WebDocSach.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;

namespace DoAn_WebDocSach.Controllers
{
    public class UserSachController : Controller
    {
        private WEBDOCSACHEntities db = new WEBDOCSACHEntities();

        private NOIDUNGSACH GetPrevChapter(string maSach, string maChuong)
        {
            var prevChapter = db.NOIDUNGSACHes.Where(s => s.maSach == maSach && s.maChuong.CompareTo(maChuong) < 0).OrderByDescending(s => s.maChuong).FirstOrDefault();
            return prevChapter;
        }

        private NOIDUNGSACH GetNextChapter(string maSach, string maChuong)
        {
            var nextChapter = db.NOIDUNGSACHes.Where(s => s.maSach == maSach && s.maChuong.CompareTo(maChuong) > 0).OrderBy(s => s.maChuong).FirstOrDefault();
            return nextChapter;
        }

        public ActionResult ReadBook(string maSach, string maChuong)
        {
            if (maSach == null && maChuong == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            var chuong = db.NOIDUNGSACHes.Find(maSach, maChuong);
            if (chuong == null)
            {
                return HttpNotFound();
            }

            var sach = db.SACHes.Find(maSach);
            ViewBag.Sach = sach;

            // Tang so luot xem
            SACH_LUOTXEM s = db.SACH_LUOTXEM.Find(maSach);
            if (s != null)
            {
                s.soLuotXem += 1;
                db.Entry(s).State = EntityState.Modified;
                db.SaveChanges();
            }

            var dsChuong = db.NOIDUNGSACHes.Where(nd => nd.maSach == maSach).ToList();
            ViewBag.dsChuong = dsChuong;

            ViewBag.prevChapter = GetPrevChapter(maSach, maChuong);
            ViewBag.nextChapter = GetNextChapter(maSach, maChuong);

            ViewBag.maTheLoai = new SelectList(db.THELOAIs, "maTheLoai", "tenTheLoai");
            var danhSachTheLoai = db.THELOAIs.ToList();
            ViewBag.DanhSachTheLoai = danhSachTheLoai;

            ViewBag.LoaiSach = sach.loai;

            // Kiem tra xem nguoi dung co duoc xem cac chuong khong (Sach co 3 loai: Thuong, VIP, Ban quyen)
            if (sach.loai == 0 || chuong.maChuong == "MC001") // Tat ca user deu duoc xem
            {
                ViewBag.CanAccess = true;
                return View(chuong);
            }
            else
            {
                var session = (UserLogin)Session[CommonConstants.USER_SESSION];
                if (session == null)
                {
                    ViewBag.CanAccess = false;
                    return View(chuong);
                }

                var user = db.KHACHHANGs.Find(session.MaKH);
                if (sach.loai == 1) // Sach VIP
                {
                    if (user.isVIP == false)
                    {
                        ViewBag.CanAccess = false;
                        return View(chuong);
                    }
                    else
                    {
                        ViewBag.CanAccess = true;
                        return View(chuong);
                    }
                }
                else // Sach Ban quyen
                {
                    var sachDaMua = db.GIAODICH_MUASACH.Find(session.MaKH, sach.maSach);
                    if (sachDaMua == null) // Chua mua sach
                    {
                        ViewBag.CanAccess = false;
                        return View(chuong);
                    }
                    else
                    {
                        ViewBag.CanAccess = true;
                        return View(chuong);
                    }
                }
            }
        }

        public ActionResult ViewBookInfo(string id)
        {
            var sach = db.SACHes.Find(id);
            if (sach == null)
            {
                return HttpNotFound();
            }

            var danhSachTheLoai = db.THELOAIs.ToList();
            ViewBag.DanhSachTheLoai = danhSachTheLoai;

            var ndSach = db.NOIDUNGSACHes.Where(nd => nd.maSach == id).ToList();
            ViewBag.NDSach = ndSach;

            ViewBag.maTheLoai = new SelectList(db.THELOAIs, "maTheLoai", "tenTheLoai");

            ViewBag.SoLuotXem = db.SACH_LUOTXEM.Find(id).soLuotXem;

            ViewBag.LoaiSach = sach.loai;

            // Kiem tra xem nguoi dung co duoc xem cac chuong khong (Sach co 3 loai: Thuong, VIP, Ban quyen)
            if (sach.loai == 0) // Sach Thuong - Tat ca user deu duoc xem
            {
                ViewBag.CanAccess = true;
                return View(sach);
            }
            else
            {
                var session = (UserLogin)Session[CommonConstants.USER_SESSION];
                if (session == null)
                {
                    ViewBag.CanAccess = false;
                    return View(sach);
                }

                var user = db.KHACHHANGs.Find(session.MaKH);
                if (sach.loai == 1) // Sach VIP
                {
                    if (user.isVIP == false)
                    {
                        ViewBag.CanAccess = false;
                        return View(sach);
                    }
                    else
                    {
                        ViewBag.CanAccess = true;
                        return View(sach);
                    }
                }
                else // Sach Ban quyen
                {
                    var sachDaMua = db.GIAODICH_MUASACH.Find(session.MaKH, sach.maSach);
                    if (sachDaMua == null) // Chua mua sach
                    {
                        ViewBag.CanAccess = false;
                        return View(sach);
                    }
                    else
                    {
                        ViewBag.CanAccess = true;
                        return View(sach);
                    }
                }
            }
        }

        public ActionResult KetQuaTimKiemSach(List<SACH> listSach)
        {
            var soLuotXemList = new List<long>();
            foreach(var sach in listSach)
            {
                var soLuotXem = db.SACH_LUOTXEM.Find(sach.maSach).soLuotXem;
                soLuotXemList.Add(soLuotXem);
            }
            ViewBag.SoLuotXemList = soLuotXemList;
            return View(listSach);
        }

        public ActionResult Sach_TheLoai(string maTheLoai = "")
        {
            ViewBag.maTheLoai = new SelectList(db.THELOAIs, "maTheLoai", "tenTheLoai");
            var danhSachTheLoai = db.THELOAIs.ToList();
            ViewBag.DanhSachTheLoai = danhSachTheLoai;
            var tenTheLoai = db.THELOAIs.Where(t => t.maTheLoai == maTheLoai).Select(t => t.tenTheLoai).FirstOrDefault();
            ViewBag.KQ = tenTheLoai;
            ViewBag.TT = "Thể loại";
            var sachs = db.SACHes.SqlQuery("Sach_TimKiemTL'" + maTheLoai + "'");
            var sachList = sachs.OrderBy(s => s.tenSach).ToList();

            var soLuotXemList = new List<long>();
            foreach (var sach in sachList)
            {
                var soLuotXem = db.SACH_LUOTXEM.Find(sach.maSach).soLuotXem;
                soLuotXemList.Add(soLuotXem);
            }
            ViewBag.SoLuotXemList = soLuotXemList;

            return View("KetQuaTimKiemSach", sachList);
        }

        public ActionResult TimKiem_SachTacGia(string tenTK = "")
        {
            ViewBag.KQ = tenTK;
            ViewBag.TT = "Tìm Sách/Tác giả";
            var danhSachTheLoai = db.THELOAIs.ToList();
            ViewBag.DanhSachTheLoai = danhSachTheLoai;
            ViewBag.maTheLoai = new SelectList(db.THELOAIs, "maTheLoai", "tenTheLoai");
            var sachs = db.SACHes.SqlQuery("Sach_TimKiemTSTG N'" + tenTK + "'");
            var sachList = sachs.OrderBy(s => s.tenSach).ToList();

            var soLuotXemList = new List<long>();
            foreach (var sach in sachList)
            {
                var soLuotXem = db.SACH_LUOTXEM.Find(sach.maSach).soLuotXem;
                soLuotXemList.Add(soLuotXem);
            }
            ViewBag.SoLuotXemList = soLuotXemList;

            return View("KetQuaTimKiemSach", sachList);
        }
        public ActionResult TimKiem_SachLoai(string loai = "")
        {
            var danhSachTheLoai = db.THELOAIs.ToList();
            ViewBag.DanhSachTheLoai = danhSachTheLoai;
            ViewBag.maTheLoai = new SelectList(db.THELOAIs, "maTheLoai", "tenTheLoai");
            if (loai == "0")
            {
                ViewBag.KQ = "Thường";
            }
            else
            {
                if (loai == "1")
                {
                    ViewBag.KQ = "Vip";
                }
                else if (loai == "2")
                {
                    ViewBag.KQ = "Bản quyền";
                }
                else
                {
                    ViewBag.KQ = "";
                }
            }

            ViewBag.TT = "Loại sách";
            var sachs = db.SACHes.SqlQuery("Sach_TimKiemLoai'" + loai + "'");
            var sachList = sachs.OrderBy(s => s.tenSach).ToList();

            var soLuotXemList = new List<long>();
            foreach (var sach in sachList)
            {
                var soLuotXem = db.SACH_LUOTXEM.Find(sach.maSach).soLuotXem;
                soLuotXemList.Add(soLuotXem);
            }
            ViewBag.SoLuotXemList = soLuotXemList;

            return View("KetQuaTimKiemSach", sachList);
        }

        public ActionResult MuaSach(string maSach)
        {
            var danhSachTheLoai = db.THELOAIs.ToList();
            ViewBag.DanhSachTheLoai = danhSachTheLoai;

            var session = (UserLogin)Session[CommonConstants.USER_SESSION];
            if (session == null)
            {
                return RedirectToAction("Index", "UserLogin");
            }

            var user = db.KHACHHANGs.Find(session.MaKH);
            if (user == null)
            {
                return HttpNotFound();
            }

            ViewBag.TenKH = user.tenKH;
            ViewBag.MaSach = db.SACHes.Find(maSach).maSach;
            ViewBag.TenSach = db.SACHes.Find(maSach).tenSach;
            ViewBag.ThoiGian = DateTime.Now.ToString("dd/MM/yyyy");
            ViewBag.Gia = db.SACHes.Find(maSach).gia;

            return View();
        }

        public ActionResult XacNhanMuaSach(string maSach)
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

            // Luu giao dich vao db
            GIAODICH_MUASACH gd = new GIAODICH_MUASACH { 
                maKH = user.maKH,
                maSach = maSach,
                thoiGian = DateTime.Now,
                gia = db.SACHes.Find(maSach).gia
            };

            db.GIAODICH_MUASACH.Add(gd);
            db.SaveChanges();

            return RedirectToAction("ViewBookInfo", new {id = maSach});
        }
    }
}