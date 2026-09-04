using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lms.seihaglobalacademy.com
{
    public partial class Dashboard : System.Web.UI.Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["SGA_LMSDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCourseGrid();
                BindAssignmentTable();
            }
        }

        private bool IsStudentView()
        {
            return Session["LMS_StudentPreviewMode"] != null && (bool)Session["LMS_StudentPreviewMode"];
        }

        // ==========================================
        // 1. COURSES (FETCH & INSERT INTO SQL SERVER)
        // ==========================================
        private void BindCourseGrid()
        {
            var courses = new List<DashboardCourseModel>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT CourseID, CourseName, Description FROM dbo.Courses ORDER BY CourseID DESC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    courses.Add(new DashboardCourseModel
                    {
                        CourseID = Convert.ToInt32(dr["CourseID"]),
                        CourseName = dr["CourseName"].ToString(),
                        Description = dr["Description"].ToString()
                    });
                }
            }

            rptDashboardCourses.DataSource = courses;
            rptDashboardCourses.DataBind();
        }

        protected void btnSaveCourse_Click(object sender, EventArgs e)
        {
            if (IsStudentView())
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "UnauthorizedAlert", "alert('Access Denied: Students cannot create courses.');", true);
                return;
            }

            string newCourseName = txtCourseName.Text.Trim();

            if (!string.IsNullOrEmpty(newCourseName))
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string sql = "INSERT INTO dbo.Courses (CourseName, Description) VALUES (@CourseName, @Description)";
                        SqlCommand cmd = new SqlCommand(sql, conn);
                        cmd.Parameters.AddWithValue("@CourseName", newCourseName);
                        cmd.Parameters.AddWithValue("@Description", string.IsNullOrEmpty(txtClassKey.Text) ? "Standard Course" : txtClassKey.Text.Trim());

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }

                    txtCourseName.Text = string.Empty;
                    txtClassKey.Text = string.Empty;

                    BindCourseGrid();

                    ScriptManager.RegisterStartupScript(this, GetType(), "CloseAddModal", "closeModal('addCourseModal');", true);
                }
                catch (Exception ex)
                {
                    string cleanMsg = ex.Message.Replace("'", "\\'");
                    ScriptManager.RegisterStartupScript(this, GetType(), "SqlErrorAlert", $"alert('Database Error: {cleanMsg}');", true);
                }
            }
        }

        // ==========================================
        // 2. ASSIGNMENTS (FETCH & ITEM COMMAND REDIRECT)
        // ==========================================
        private void BindAssignmentTable()
        {
            var assignments = new List<DashboardAssignmentModel>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT a.AssignmentID, a.AssignmentName, a.CourseName, a.EndDateTime, a.ManualGrading, a.Completed,
                                      ISNULL(c.CourseID, 0) AS CourseID
                               FROM dbo.Assignments a
                               LEFT JOIN dbo.Courses c ON a.CourseName = c.CourseName
                               ORDER BY a.AssignmentID DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    assignments.Add(new DashboardAssignmentModel
                    {
                        AssignmentID = Convert.ToInt32(dr["AssignmentID"]),
                        CourseID = Convert.ToInt32(dr["CourseID"]),
                        AssignmentName = dr["AssignmentName"].ToString(),
                        CourseName = dr["CourseName"].ToString(),
                        EndDateTime = dr["EndDateTime"].ToString(),
                        ManualGrading = dr["ManualGrading"].ToString(),
                        Completed = dr["Completed"].ToString()
                    });
                }
            }

            if (assignments.Count > 0)
            {
                rptAssignments.DataSource = assignments;
                rptAssignments.DataBind();
                rptAssignments.Visible = true;
                phNoAssignments.Visible = false;
            }
            else
            {
                rptAssignments.Visible = false;
                phNoAssignments.Visible = true;
            }
        }

        protected void rptAssignments_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewAssignment")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                if (args.Length == 2)
                {
                    string courseId = args[0];
                    string assignmentId = args[1];

                    Response.Redirect($"~/CourseDetails.aspx?courseId={courseId}&tab=Assignments&assignmentId={assignmentId}");
                }
            }
        }

        protected void btnCreateCourse_Click(object sender, EventArgs e)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "PopModal", "openAddCourseModal();", true);
        }

        protected void btnPreviewAsStudent_Click(object sender, EventArgs e)
        {
            Session[SiteMaster.StudentPreviewSessionKey] = true;
            Response.Redirect(Request.RawUrl);
        }
    }

    public class DashboardCourseModel
    {
        public int CourseID { get; set; }
        public string CourseName { get; set; }
        public string Description { get; set; }
    }

    // Local model specific to Dashboard to avoid global namespace conflicts
    public class DashboardAssignmentModel
    {
        public int AssignmentID { get; set; }
        public int CourseID { get; set; }
        public string AssignmentName { get; set; }
        public string CourseName { get; set; }
        public string EndDateTime { get; set; }
        public string ManualGrading { get; set; }
        public string Completed { get; set; }
    }
}