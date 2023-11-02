using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace DoAn_WebDocSach.Areas.Admin.Models
{
    public class LoginModel
    {
        [Required(ErrorMessage = "*")]
        [DisplayName("Email")]
        public string Email { get; set; }
        [Required(ErrorMessage = "*")]
        [DisplayName("Mật khẩu")]
        public string MatKhau { get; set; }
    }
}