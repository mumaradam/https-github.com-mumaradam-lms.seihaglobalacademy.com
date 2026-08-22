using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lms.seihaglobalacademy.com
{
    public partial class CourseDetails : System.Web.UI.Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["SGA_LMSDB"].ConnectionString;
        private const string ActiveQuizIndexKey = "LMS_Demo_ActiveQuizIndex";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                InitializeCourseContext();
                BindAll();
            }
        }

        public bool IsStudentView()
        {
            return Session["LMS_StudentPreviewMode"] != null && (bool)Session["LMS_StudentPreviewMode"];
        }

        private void InitializeCourseContext()
        {
            string courseId = Request.QueryString["courseId"];
            if (!string.IsNullOrEmpty(courseId) && int.TryParse(courseId, out int parsedId))
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "SELECT CourseName FROM dbo.Courses WHERE CourseID = @CourseID";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@CourseID", parsedId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                    {
                        lblCourseTitle.Text = result.ToString();
                        return;
                    }
                }
            }

            lblCourseTitle.Text = "Sample Course";
        }

        private void BindAll()
        {
            BindAnnouncements();
            BindQuizzes();
            BindAssignments();
        }

        // ==========================================
        // 1. ANNOUNCEMENTS (SQL SELECT, INSERT, UPDATE & DELETE)
        // ==========================================
        private void BindAnnouncements()
        {
            phNewAnnouncementBtn.Visible = !IsStudentView();

            var list = new List<CourseAnnouncementModel>();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT AnnouncementID, Title, Author, FORMAT(PostDate, 'MMM dd, yyyy') AS PostDateFormatted, Body FROM dbo.Announcements ORDER BY AnnouncementID DESC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    list.Add(new CourseAnnouncementModel
                    {
                        AnnouncementID = Convert.ToInt32(dr["AnnouncementID"]),
                        Title = dr["Title"].ToString(),
                        Author = dr["Author"].ToString(),
                        PostDate = dr["PostDateFormatted"].ToString(),
                        Body = dr["Body"].ToString()
                    });
                }
            }
            rptAnnouncements.DataSource = list;
            rptAnnouncements.DataBind();
        }

        protected void rptAnnouncements_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var phActions = (PlaceHolder)e.Item.FindControl("phTeacherAnnouncementActions");
                if (phActions != null)
                {
                    phActions.Visible = !IsStudentView();
                }
            }
        }

        protected void btnPostAnnouncement_Click(object sender, EventArgs e)
        {
            if (IsStudentView())
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "UnauthorizedAlert", "alert('Access Denied: Students cannot create announcements.');", true);
                return;
            }

            if (!string.IsNullOrEmpty(txtAnnouncementTitle.Text) && !string.IsNullOrEmpty(txtAnnouncementBody.Text))
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string sql = "INSERT INTO dbo.Announcements (Title, Author, Body) VALUES (@Title, @Author, @Body)";
                        SqlCommand cmd = new SqlCommand(sql, conn);
                        cmd.Parameters.AddWithValue("@Title", txtAnnouncementTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@Author", "Teacher / Admin");
                        cmd.Parameters.AddWithValue("@Body", txtAnnouncementBody.Text.Trim());

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }

                    txtAnnouncementTitle.Text = "";
                    txtAnnouncementBody.Text = "";

                    BindAnnouncements();
                    ScriptManager.RegisterStartupScript(this, GetType(), "CloseAnnounceModal", "closeModal('announcementModal');", true);
                }
                catch (Exception ex)
                {
                    string cleanMsg = ex.Message.Replace("'", "\\'");
                    ScriptManager.RegisterStartupScript(this, GetType(), "SqlErrorAlert", $"alert('Database Error: {cleanMsg}');", true);
                }
            }
        }

        protected void rptAnnouncements_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (IsStudentView())
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "UnauthorizedAlert", "alert('Access Denied: Students cannot modify announcements.');", true);
                return;
            }

            int announcementId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "DeleteAnnouncement")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "DELETE FROM dbo.Announcements WHERE AnnouncementID = @ID";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@ID", announcementId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                BindAnnouncements();
            }
            else if (e.CommandName == "EditAnnouncement")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "SELECT AnnouncementID, Title, Body FROM dbo.Announcements WHERE AnnouncementID = @ID";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@ID", announcementId);
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        hfEditAnnouncementID.Value = dr["AnnouncementID"].ToString();
                        txtEditAnnouncementTitle.Text = dr["Title"].ToString();
                        txtEditAnnouncementBody.Text = dr["Body"].ToString();
                    }
                }
                ScriptManager.RegisterStartupScript(this, GetType(), "OpenEditModal", "openModal('editAnnouncementModal');", true);
            }
        }

        protected void btnUpdateAnnouncement_Click(object sender, EventArgs e)
        {
            if (IsStudentView())
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "UnauthorizedAlert", "alert('Access Denied: Students cannot update announcements.');", true);
                return;
            }

            if (!string.IsNullOrEmpty(hfEditAnnouncementID.Value) && !string.IsNullOrEmpty(txtEditAnnouncementTitle.Text))
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "UPDATE dbo.Announcements SET Title = @Title, Body = @Body WHERE AnnouncementID = @ID";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@Title", txtEditAnnouncementTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@Body", txtEditAnnouncementBody.Text.Trim());
                    cmd.Parameters.AddWithValue("@ID", Convert.ToInt32(hfEditAnnouncementID.Value));
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "CloseEditModal", "closeModal('editAnnouncementModal');", true);
                BindAnnouncements();
            }
        }

        // ==========================================
        // 2. QUIZZES (SQL SELECT, INSERT & AUTO-GRADE)
        // ==========================================
        private List<GoogleFormQuizModel> GetQuizzesFromDb()
        {
            var quizzes = new List<GoogleFormQuizModel>();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string quizSql = "SELECT QuizID, Title, DueDate, TimeLimit FROM dbo.Quizzes ORDER BY QuizID DESC";
                SqlCommand quizCmd = new SqlCommand(quizSql, conn);
                SqlDataReader dr = quizCmd.ExecuteReader();

                var tempQuizzes = new List<Tuple<int, string, string, string>>();
                while (dr.Read())
                {
                    tempQuizzes.Add(new Tuple<int, string, string, string>(
                        Convert.ToInt32(dr["QuizID"]),
                        dr["Title"].ToString(),
                        dr["DueDate"].ToString(),
                        dr["TimeLimit"].ToString()
                    ));
                }
                dr.Close();

                foreach (var q in tempQuizzes)
                {
                    var quizModel = new GoogleFormQuizModel
                    {
                        Title = q.Item2,
                        DueDate = q.Item3,
                        TimeLimit = q.Item4,
                        Questions = new List<QuestionModel>()
                    };

                    string qSql = "SELECT QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectAnswer FROM dbo.Questions WHERE QuizID = @QuizID";
                    SqlCommand qCmd = new SqlCommand(qSql, conn);
                    qCmd.Parameters.AddWithValue("@QuizID", q.Item1);
                    SqlDataReader qDr = qCmd.ExecuteReader();
                    while (qDr.Read())
                    {
                        quizModel.Questions.Add(new QuestionModel
                        {
                            QuestionText = qDr["QuestionText"].ToString(),
                            OptionA = qDr["OptionA"].ToString(),
                            OptionB = qDr["OptionB"].ToString(),
                            OptionC = qDr["OptionC"].ToString(),
                            OptionD = qDr["OptionD"].ToString(),
                            CorrectAnswer = qDr["CorrectAnswer"].ToString()
                        });
                    }
                    qDr.Close();

                    quizzes.Add(quizModel);
                }
            }
            return quizzes;
        }

        private void BindQuizzes()
        {
            btnOpenQuizModal.Visible = !IsStudentView();
            rptQuizzes.DataSource = GetQuizzesFromDb();
            rptQuizzes.DataBind();
        }

        protected void btnSaveFormQuiz_Click(object sender, EventArgs e)
        {
            if (IsStudentView())
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "UnauthorizedAlert", "alert('Access Denied: Students cannot create quizzes.');", true);
                return;
            }

            string title = txtFormQuizTitle.Text.Trim();
            string jsonPayload = hfQuizJsonData.Value;

            if (!string.IsNullOrEmpty(title) && !string.IsNullOrEmpty(jsonPayload))
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                List<QuestionModel> questions = serializer.Deserialize<List<QuestionModel>>(jsonPayload);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string insertQuizSql = "INSERT INTO dbo.Quizzes (Title, DueDate, TimeLimit) VALUES (@Title, @DueDate, @TimeLimit); SELECT SCOPE_IDENTITY();";
                    SqlCommand cmd = new SqlCommand(insertQuizSql, conn);
                    cmd.Parameters.AddWithValue("@Title", title);
                    cmd.Parameters.AddWithValue("@DueDate", DateTime.Now.AddDays(7).ToString("MMM dd, yyyy"));
                    cmd.Parameters.AddWithValue("@TimeLimit", string.IsNullOrEmpty(txtFormTimeLimit.Text) ? "15" : txtFormTimeLimit.Text.Trim());

                    int newQuizId = Convert.ToInt32(cmd.ExecuteScalar());

                    foreach (var q in questions)
                    {
                        string insertQSql = @"INSERT INTO dbo.Questions (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectAnswer) 
                                              VALUES (@QuizID, @QuestionText, @OptionA, @OptionB, @OptionC, @OptionD, @CorrectAnswer)";
                        SqlCommand qCmd = new SqlCommand(insertQSql, conn);
                        qCmd.Parameters.AddWithValue("@QuizID", newQuizId);
                        qCmd.Parameters.AddWithValue("@QuestionText", q.QuestionText);
                        qCmd.Parameters.AddWithValue("@OptionA", q.OptionA);
                        qCmd.Parameters.AddWithValue("@OptionB", q.OptionB);
                        qCmd.Parameters.AddWithValue("@OptionC", q.OptionC);
                        qCmd.Parameters.AddWithValue("@OptionD", q.OptionD);
                        qCmd.Parameters.AddWithValue("@CorrectAnswer", q.CorrectAnswer);
                        qCmd.ExecuteNonQuery();
                    }
                }

                txtFormQuizTitle.Text = "";
                txtFormTimeLimit.Text = "";
                hfQuizJsonData.Value = "";
                BindQuizzes();
                ScriptManager.RegisterStartupScript(this, GetType(), "CloseQuizModal", "closeModal('quizFormModal');", true);
            }
        }

        protected void rptQuizzes_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var btnAction = (LinkButton)e.Item.FindControl("btnActionQuiz");
                if (btnAction != null)
                {
                    if (IsStudentView())
                    {
                        btnAction.Text = "Take Quiz";
                        btnAction.Style["background"] = "#059669";
                    }
                    else
                    {
                        btnAction.Text = "Preview Quiz";
                        btnAction.Style["background"] = "#4f46e5";
                    }
                }
            }
        }

        protected void rptQuizzes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ActionQuiz")
            {
                int index = Convert.ToInt32(e.CommandArgument);
                var list = GetQuizzesFromDb();

                if (list != null && index < list.Count)
                {
                    Session[ActiveQuizIndexKey] = index;
                    var quiz = list[index];

                    pnlQuizList.Visible = false;
                    pnlQuizResults.Visible = false;

                    if (IsStudentView())
                    {
                        lblActiveQuizTitle.Text = quiz.Title;
                        rptFormQuestions.DataSource = quiz.Questions;
                        rptFormQuestions.DataBind();
                        pnlTakeQuizForm.Visible = true;
                        pnlTeacherQuizPreview.Visible = false;
                    }
                    else
                    {
                        lblTeacherPreviewTitle.Text = quiz.Title;
                        rptTeacherPreviewQuestions.DataSource = quiz.Questions;
                        rptTeacherPreviewQuestions.DataBind();
                        pnlTakeQuizForm.Visible = false;
                        pnlTeacherQuizPreview.Visible = true;
                    }
                }
            }
        }

        protected void rptFormQuestions_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var q = (QuestionModel)e.Item.DataItem;
                var rblOptions = (RadioButtonList)e.Item.FindControl("rblOptions");

                if (rblOptions != null && q != null)
                {
                    rblOptions.Items.Clear();
                    rblOptions.Items.Add(new ListItem(" Option A: " + q.OptionA, "A"));
                    rblOptions.Items.Add(new ListItem(" Option B: " + q.OptionB, "B"));
                    rblOptions.Items.Add(new ListItem(" Option C: " + q.OptionC, "C"));
                    rblOptions.Items.Add(new ListItem(" Option D: " + q.OptionD, "D"));
                }
            }
        }

        protected void btnSubmitQuiz_Click(object sender, EventArgs e)
        {
            int activeIndex = Session[ActiveQuizIndexKey] != null ? (int)Session[ActiveQuizIndexKey] : 0;
            var list = GetQuizzesFromDb();

            if (list == null || activeIndex >= list.Count) return;

            var activeQuiz = list[activeIndex];
            int correctCount = 0;
            int totalQuestions = activeQuiz.Questions.Count;
            var resultList = new List<QuestionResultModel>();

            for (int i = 0; i < rptFormQuestions.Items.Count; i++)
            {
                var item = rptFormQuestions.Items[i];
                var rblOptions = (RadioButtonList)item.FindControl("rblOptions");

                string selected = rblOptions != null ? rblOptions.SelectedValue : "";
                if (string.IsNullOrEmpty(selected) && rblOptions != null)
                {
                    string postedKey = rblOptions.UniqueID;
                    if (!string.IsNullOrEmpty(postedKey) && Request.Form[postedKey] != null)
                    {
                        selected = Request.Form[postedKey];
                    }
                }

                if (string.IsNullOrEmpty(selected)) selected = "Not Answered";

                string correct = activeQuiz.Questions[i].CorrectAnswer;
                bool isCorrect = (selected == correct);
                if (isCorrect) correctCount++;

                resultList.Add(new QuestionResultModel
                {
                    QuestionText = activeQuiz.Questions[i].QuestionText,
                    SelectedAnswer = selected,
                    CorrectAnswer = correct,
                    IsCorrect = isCorrect
                });
            }

            double pct = totalQuestions > 0 ? ((double)correctCount / totalQuestions) * 100 : 0;
            lblQuizScore.Text = correctCount + " / " + totalQuestions;
            lblQuizPercentage.Text = Math.Round(pct, 1) + "%";

            rptResultBreakdown.DataSource = resultList;
            rptResultBreakdown.DataBind();

            pnlTakeQuizForm.Visible = false;
            pnlQuizResults.Visible = true;
        }

        // ==========================================
        // 3. ASSIGNMENTS (SQL SELECT & INSERT)
        // ==========================================
        private void BindAssignments()
        {
            btnOpenAssignmentModal.Visible = !IsStudentView();

            var list = new List<AssignmentModel>();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT AssignmentID, AssignmentName, CourseName, EndDateTime, ManualGrading, Completed FROM dbo.Assignments ORDER BY AssignmentID DESC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    list.Add(new AssignmentModel
                    {
                        AssignmentID = Convert.ToInt32(dr["AssignmentID"]),
                        AssignmentName = dr["AssignmentName"].ToString(),
                        CourseName = dr["CourseName"].ToString(),
                        EndDateTime = dr["EndDateTime"].ToString(),
                        ManualGrading = dr["ManualGrading"].ToString(),
                        Completed = dr["Completed"].ToString()
                    });
                }
            }
            rptAssignments.DataSource = list;
            rptAssignments.DataBind();
        }

        protected void btnSaveAssignment_Click(object sender, EventArgs e)
        {
            if (IsStudentView())
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "UnauthorizedAlert", "alert('Access Denied: Students cannot create assignments.');", true);
                return;
            }

            if (!string.IsNullOrEmpty(txtAssignmentTitle.Text))
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = @"INSERT INTO dbo.Assignments (AssignmentName, CourseName, EndDateTime, ManualGrading, Completed) 
                                   VALUES (@AssignmentName, @CourseName, @EndDateTime, @ManualGrading, @Completed)";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@AssignmentName", txtAssignmentTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@CourseName", lblCourseTitle.Text);
                    cmd.Parameters.AddWithValue("@EndDateTime", string.IsNullOrEmpty(txtAssignmentDueDate.Text) ? "TBD" : txtAssignmentDueDate.Text.Trim());
                    cmd.Parameters.AddWithValue("@ManualGrading", "Required");
                    cmd.Parameters.AddWithValue("@Completed", "0 / 25 Students");
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                txtAssignmentTitle.Text = "";
                txtAssignmentDueDate.Text = "";
                BindAssignments();
                ScriptManager.RegisterStartupScript(this, GetType(), "CloseAssignModal", "closeModal('assignmentModal');", true);
            }
        }

        // ==========================================
        // NAVIGATION HANDLERS
        // ==========================================
        protected void btnNav_Click(object sender, EventArgs e)
        {
            var btn = (LinkButton)sender;
            string target = btn.CommandArgument;

            liAnnouncements.Attributes["class"] = "";
            liQuizzes.Attributes["class"] = "";
            liModules.Attributes["class"] = "";
            liAssignments.Attributes["class"] = "";
            liGradebook.Attributes["class"] = "";
            liUserManagement.Attributes["class"] = "teacher-only-control";

            pnlAnnouncements.Visible = false;
            pnlQuizzes.Visible = false;
            pnlModules.Visible = false;
            pnlAssignments.Visible = false;
            pnlGradebook.Visible = false;
            pnlUserManagement.Visible = false;

            switch (target)
            {
                case "Quizzes":
                    liQuizzes.Attributes["class"] = "active";
                    pnlQuizzes.Visible = true;
                    pnlQuizList.Visible = true;
                    pnlTeacherQuizPreview.Visible = false;
                    pnlTakeQuizForm.Visible = false;
                    pnlQuizResults.Visible = false;
                    break;
                case "Modules":
                    liModules.Attributes["class"] = "active";
                    pnlModules.Visible = true;
                    break;
                case "Assignments":
                    liAssignments.Attributes["class"] = "active";
                    pnlAssignments.Visible = true;
                    break;
                case "Gradebook":
                    liGradebook.Attributes["class"] = "active";
                    pnlGradebook.Visible = true;
                    break;
                case "UserManagement":
                    liUserManagement.Attributes["class"] = "active teacher-only-control";
                    pnlUserManagement.Visible = true;
                    break;
                default:
                    liAnnouncements.Attributes["class"] = "active";
                    pnlAnnouncements.Visible = true;
                    break;
            }
        }

        protected void btnCancelQuiz_Click(object sender, EventArgs e)
        {
            pnlTakeQuizForm.Visible = false;
            pnlQuizList.Visible = true;
        }

        protected void btnBackToQuizzes_Click(object sender, EventArgs e)
        {
            pnlQuizResults.Visible = false;
            pnlTakeQuizForm.Visible = false;
            pnlTeacherQuizPreview.Visible = false;
            pnlQuizList.Visible = true;
        }
    }

    public class CourseAnnouncementModel
    {
        public int AnnouncementID { get; set; }
        public string Title { get; set; }
        public string Author { get; set; }
        public string PostDate { get; set; }
        public string Body { get; set; }
    }
}