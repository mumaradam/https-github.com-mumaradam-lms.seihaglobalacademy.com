using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lms.seihaglobalacademy.com
{
    public partial class Courses : System.Web.UI.Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["SGA_LMSDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCourses();
            }
        }

        private void BindCourses()
        {
            var courses = new List<dynamic>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT CourseID, 
                                      ISNULL(CourseCode, 'SC-1') AS CourseCode, 
                                      CourseName, 
                                      ISNULL(CourseType, 'General') AS CourseType, 
                                      ISNULL(Term, 'Term 1') AS Term, 
                                      CourseImage 
                               FROM dbo.Courses 
                               ORDER BY CourseID DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    courses.Add(new
                    {
                        CourseID = Convert.ToInt32(dr["CourseID"]),
                        CourseCode = dr["CourseCode"].ToString(),
                        CourseName = dr["CourseName"].ToString(),
                        CourseType = dr["CourseType"].ToString(),
                        Term = dr["Term"].ToString(),
                        CourseImage = dr["CourseImage"] != DBNull.Value ? dr["CourseImage"].ToString() : null
                    });
                }
            }

            rptCourses.DataSource = courses;
            rptCourses.DataBind();
        }

        protected void rptCourses_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int courseId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditCourse")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "SELECT CourseID, CourseCode, CourseName, CourseType, Term FROM dbo.Courses WHERE CourseID = @CourseID";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        hfEditCourseID.Value = dr["CourseID"].ToString();
                        txtCourseCode.Text = dr["CourseCode"].ToString();
                        txtCourseName.Text = dr["CourseName"].ToString();
                        txtCourseType.Text = dr["CourseType"].ToString();
                        txtTerm.Text = dr["Term"].ToString();
                    }
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "OpenEditCourseModal", "document.getElementById('modalTitle').innerText = 'Edit Course'; openModal('courseModal');", true);
            }
            else if (e.CommandName == "DeleteCourse")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "DELETE FROM dbo.Courses WHERE CourseID = @CourseID";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                BindCourses();
            }
        }

        protected void btnSaveCourse_Click(object sender, EventArgs e)
        {
            string imagePath = null;

            if (fileCourseBanner.HasFile)
            {
                try
                {
                    string fileName = Path.GetFileName(fileCourseBanner.FileName);
                    string uniqueFileName = "banner_" + Guid.NewGuid().ToString("N").Substring(0, 8) + Path.GetExtension(fileName);

                    string uploadFolder = Server.MapPath("~/Uploads/Courses/");
                    if (!Directory.Exists(uploadFolder))
                    {
                        Directory.CreateDirectory(uploadFolder);
                    }

                    string savePath = Path.Combine(uploadFolder, uniqueFileName);
                    fileCourseBanner.SaveAs(savePath);

                    imagePath = "~/Uploads/Courses/" + uniqueFileName;
                }
                catch (Exception ex)
                {
                    string cleanMsg = ex.Message.Replace("'", "\\'");
                    ScriptManager.RegisterStartupScript(this, GetType(), "UploadError", $"alert('Image Upload Error: {cleanMsg}');", true);
                    return;
                }
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                if (!string.IsNullOrEmpty(hfEditCourseID.Value) && int.TryParse(hfEditCourseID.Value, out int courseId))
                {
                    string sql = @"UPDATE dbo.Courses 
                                   SET CourseCode = @CourseCode, 
                                       CourseName = @CourseName, 
                                       CourseType = @CourseType, 
                                       Term = @Term" +
                                       (imagePath != null ? ", CourseImage = @CourseImage" : "") +
                                 " WHERE CourseID = @CourseID";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@CourseCode", txtCourseCode.Text.Trim());
                    cmd.Parameters.AddWithValue("@CourseName", txtCourseName.Text.Trim());
                    cmd.Parameters.AddWithValue("@CourseType", txtCourseType.Text.Trim());
                    cmd.Parameters.AddWithValue("@Term", txtTerm.Text.Trim());
                    cmd.Parameters.AddWithValue("@CourseID", courseId);

                    if (imagePath != null)
                    {
                        cmd.Parameters.AddWithValue("@CourseImage", imagePath);
                    }

                    cmd.ExecuteNonQuery();
                }
                else
                {
                    string sql = @"INSERT INTO dbo.Courses (CourseCode, CourseName, CourseType, Term, CourseImage) 
                                   VALUES (@CourseCode, @CourseName, @CourseType, @Term, @CourseImage)";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@CourseCode", string.IsNullOrEmpty(txtCourseCode.Text.Trim()) ? "SC-1" : txtCourseCode.Text.Trim());
                    cmd.Parameters.AddWithValue("@CourseName", string.IsNullOrEmpty(txtCourseName.Text.Trim()) ? "Sample Course" : txtCourseName.Text.Trim());
                    cmd.Parameters.AddWithValue("@CourseType", string.IsNullOrEmpty(txtCourseType.Text.Trim()) ? "General" : txtCourseType.Text.Trim());
                    cmd.Parameters.AddWithValue("@Term", string.IsNullOrEmpty(txtTerm.Text.Trim()) ? "Term 1" : txtTerm.Text.Trim());
                    cmd.Parameters.AddWithValue("@CourseImage", (object)imagePath ?? DBNull.Value);

                    cmd.ExecuteNonQuery();
                }
            }

            hfEditCourseID.Value = "";
            txtCourseCode.Text = "";
            txtCourseName.Text = "";
            txtCourseType.Text = "";
            txtTerm.Text = "";

            BindCourses();
            ScriptManager.RegisterStartupScript(this, GetType(), "CloseCourseModal", "closeModal('courseModal');", true);
        }
    }
}