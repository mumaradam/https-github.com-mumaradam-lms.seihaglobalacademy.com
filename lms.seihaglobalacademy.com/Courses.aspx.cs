using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lms.seihaglobalacademy.com
{
    public partial class Courses : System.Web.UI.Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["SGA_LMSDB"].ConnectionString;

        private readonly string[] colorPalette = new string[] {
            "#059669", "#4f46e5", "#2563eb", "#d97706", "#dc2626", "#7c3aed"
        };

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindAllCourses();
            }
        }

        public bool IsStudentView()
        {
            return Session["LMS_StudentPreviewMode"] != null && (bool)Session["LMS_StudentPreviewMode"];
        }

        private void BindAllCourses()
        {
            var coursesList = new List<CourseCardModel>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT CourseID, CourseName, Description FROM dbo.Courses ORDER BY CourseID DESC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                int colorIndex = 0;
                while (dr.Read())
                {
                    int id = Convert.ToInt32(dr["CourseID"]);
                    string name = dr["CourseName"].ToString();

                    coursesList.Add(new CourseCardModel
                    {
                        CourseID = id,
                        CourseName = name,
                        CourseCode = GenerateCourseCode(name, id),
                        ColorHex = colorPalette[colorIndex % colorPalette.Length],
                        Term = "First Semester 2026"
                    });

                    colorIndex++;
                }
            }

            rptAllCoursesList.DataSource = coursesList;
            rptAllCoursesList.DataBind();
        }

        protected void rptAllCoursesList_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var phActions = (PlaceHolder)e.Item.FindControl("phTeacherCourseActions");
                if (phActions != null)
                {
                    phActions.Visible = !IsStudentView();
                }
            }
        }

        protected void rptAllCoursesList_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (IsStudentView())
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "UnauthorizedAlert", "alert('Access Denied: Students cannot modify courses.');", true);
                return;
            }

            int courseId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "DeleteCourse")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "DELETE FROM dbo.Courses WHERE CourseID = @CourseID";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                BindAllCourses();
            }
            else if (e.CommandName == "EditCourse")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "SELECT CourseID, CourseName, Description FROM dbo.Courses WHERE CourseID = @CourseID";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@CourseID", courseId);
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        hfEditCourseID.Value = dr["CourseID"].ToString();
                        txtEditCourseName.Text = dr["CourseName"].ToString();
                        txtEditCourseDescription.Text = dr["Description"].ToString();
                    }
                }
                ScriptManager.RegisterStartupScript(this, GetType(), "OpenEditCourseModal", "openModal('editCourseModal');", true);
            }
        }

        protected void btnUpdateCourse_Click(object sender, EventArgs e)
        {
            if (IsStudentView())
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "UnauthorizedAlert", "alert('Access Denied: Students cannot modify courses.');", true);
                return;
            }

            if (!string.IsNullOrEmpty(hfEditCourseID.Value) && !string.IsNullOrEmpty(txtEditCourseName.Text))
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "UPDATE dbo.Courses SET CourseName = @CourseName, Description = @Description WHERE CourseID = @CourseID";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@CourseName", txtEditCourseName.Text.Trim());
                    cmd.Parameters.AddWithValue("@Description", txtEditCourseDescription.Text.Trim());
                    cmd.Parameters.AddWithValue("@CourseID", Convert.ToInt32(hfEditCourseID.Value));
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "CloseEditCourseModal", "closeModal('editCourseModal');", true);
                BindAllCourses();
            }
        }

        private string GenerateCourseCode(string courseName, int courseId)
        {
            if (string.IsNullOrWhiteSpace(courseName)) return "CRS-" + courseId;

            string[] words = courseName.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (words.Length == 1)
            {
                return words[0].Substring(0, Math.Min(3, words[0].Length)).ToUpper() + "-" + courseId;
            }

            string code = "";
            foreach (var w in words)
            {
                code += w[0];
            }
            return code.ToUpper() + "-" + courseId;
        }
    }

    public class CourseCardModel
    {
        public int CourseID { get; set; }
        public string CourseName { get; set; }
        public string CourseCode { get; set; }
        public string ColorHex { get; set; }
        public string Term { get; set; }
    }
}