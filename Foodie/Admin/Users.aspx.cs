﻿using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Foodie.Admin
{
    public partial class Users : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session["breadCrum"] = "Users";
                if (Session["admin"] == null)
                {
                    Response.Redirect("../User/Login.aspx");
                }
                else
                {
                    getUsers();
                }
            }
            lblMsg.Visible = false;

        }

        private void getUsers()
        {
            // Tạo kết nối với cơ sở dữ liệu
            using (SqlConnection con = new SqlConnection(Connection.GetConnectionString()))
            {
                // Khởi tạo SqlCommand để gọi Stored Procedure
                SqlCommand cmd = new SqlCommand("User_Crud", con);
                cmd.Parameters.AddWithValue("@Action", "SELECT4ADMIN");
                cmd.CommandType = CommandType.StoredProcedure;

                // Khởi tạo SqlDataAdapter để lấy dữ liệu
                SqlDataAdapter sda = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();

                // Điền dữ liệu vào DataTable
                sda.Fill(dt);

                // Kiểm tra xem có dữ liệu trong DataTable hay không
                if (dt.Rows.Count > 0)
                {
                    // Nếu có dữ liệu, hiển thị trong rCategory
                    rUsers.DataSource = dt;
                    rUsers.DataBind();
                }
                else
                {
                    // Nếu không có dữ liệu, hiển thị thông báo "Không có"
                    rUsers.DataSource = null;
                    rUsers.DataBind();
                    lblMsg.Text = "Không có";
                }
            }

        }

        protected void rUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "delete")
            {
                con = new SqlConnection(Connection.GetConnectionString());
                cmd = new SqlCommand("User_Crud", con);
                cmd.Parameters.AddWithValue("@Action", "DELETE");
                cmd.Parameters.AddWithValue("@UserId", e.CommandArgument);
                cmd.CommandType = CommandType.StoredProcedure;

                try
                {
                    con.Open();
                    cmd.ExecuteNonQuery();
                    lblMsg.Visible = true;
                    lblMsg.Text = "User deleted successfully!";
                    lblMsg.CssClass = "alert alert-success";
                    getUsers();
                }
                catch (Exception ex)
                {
                    lblMsg.Visible = true;
                    lblMsg.Text = "Error: " + ex.Message;
                    lblMsg.CssClass = "alert alert-danger";
                }
                finally
                {
                    con.Close();
                }
            }
        }
    }
}