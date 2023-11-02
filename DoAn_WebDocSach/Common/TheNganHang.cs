using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel;
using System.Linq;
using System.Web;

namespace DoAn_WebDocSach.Common
{
    public class TheNganHang
    {
        [Required(ErrorMessage = "*")]
        [DisplayName("Số thẻ")]
        public string SoThe { get; set; }
        [Required(ErrorMessage = "*")]
        [DisplayName("Tên chủ thẻ")]
        public string TenChuThe { get; set; }
        [Required(ErrorMessage = "*")]
        [DisplayName("Ngày phát hành")]
        public string NgayPhatHanh { get; set; }
        [Required(ErrorMessage = "*")]
        [DisplayName("Số điện thoại")]
        public string SDT { get; set; }
    }
}