﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

using System;
using System.Collections.Generic;

namespace DoAn_WebDocSach.Models
{
    public class WebGrid
    {
        private List<GIAODICH_MUASACH> listGDS;
        private bool canPage;
        private int rowsPerPage;

        public WebGrid(List<GIAODICH_MUASACH> listGDS, bool canPage, int rowsPerPage)
        {
            this.listGDS = listGDS;
            this.canPage = canPage;
            this.rowsPerPage = rowsPerPage;
        }

        public static implicit operator WebGrid(System.Web.Helpers.WebGrid v)
        {
            throw new NotImplementedException();
        }
    }
}