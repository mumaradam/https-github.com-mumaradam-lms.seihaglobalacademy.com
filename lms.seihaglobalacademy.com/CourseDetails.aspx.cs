using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
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

                // Check query string parameters passed from Dashboard redirect
                string targetTab = Request.QueryString["tab"];
                string targetAssignmentId = Request.QueryString["assignmentId"];

                if (!string.IsNullOrEmpty(targetTab))
                {
                    SwitchTab(targetTab, targetAssignmentId);
                }
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
            BindModules();
        }

        // ==========================================
        // TAB NAVIGATION & DEEP LINKING
        // ==========================================
        private void SwitchTab(string target, string assignmentIdStr = null)
        {
            // Reset all sub-navigation active states and workspace panels
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
                case "Assignments":
                    liAssignments.Attributes["class"] = "active";
                    pnlAssignments.Visible = true;

                    // Auto-open specific assignment details if assignmentId is present in URL
                    if (!string.IsNullOrEmpty(assignmentIdStr) && int.TryParse(assignmentIdStr, out int assignmentId))
                    {
                        OpenAssignmentDetailView(assignmentId);
                    }
                    else
                    {
                        pnlAssignmentDetail.Visible = false;
                        rptAssignments.Visible = true;
                    }
                    break;

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

        protected void btnNav_Click(object sender, EventArgs e)
        {
            var btn = (LinkButton)sender;
            string target = btn.CommandArgument;
            SwitchTab(target);
        }

        // ==========================================
        // 1. ANNOUNCEMENTS
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
        // 2. QUIZZES
        // ==========================================
        private List<GoogleFormQuizModel> GetQuizzesFromDb()
        {
            var quizzes = new List<GoogleFormQuizModel>();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string quizSql = "SELECT QuizID, Title, OpenDate, CloseDate, TimeLimit FROM dbo.Quizzes ORDER BY QuizID DESC";
                SqlCommand quizCmd = new SqlCommand(quizSql, conn);
                SqlDataReader dr = quizCmd.ExecuteReader();

                var tempQuizzes = new List<Tuple<int, string, DateTime, DateTime, string>>();
                while (dr.Read())
                {
                    DateTime openDt = dr["OpenDate"] != DBNull.Value ? Convert.ToDateTime(dr["OpenDate"]) : DateTime.Now;
                    DateTime closeDt = dr["CloseDate"] != DBNull.Value ? Convert.ToDateTime(dr["CloseDate"]) : DateTime.Now.AddDays(7);

                    tempQuizzes.Add(new Tuple<int, string, DateTime, DateTime, string>(
                        Convert.ToInt32(dr["QuizID"]),
                        dr["Title"].ToString(),
                        openDt,
                        closeDt,
                        dr["TimeLimit"].ToString()
                    ));
                }
                dr.Close();

                foreach (var q in tempQuizzes)
                {
                    var quizModel = new GoogleFormQuizModel
                    {
                        QuizID = q.Item1,
                        Title = q.Item2,
                        OpenDate = q.Item3.ToString("MMM dd, yyyy hh:mm tt"),
                        CloseDate = q.Item4.ToString("MMM dd, yyyy hh:mm tt"),
                        RawOpenDate = q.Item3,
                        RawCloseDate = q.Item4,
                        TimeLimit = q.Item5,
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

        protected void rptQuizzes_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var quiz = (GoogleFormQuizModel)e.Item.DataItem;
                var btnAction = (LinkButton)e.Item.FindControl("btnActionQuiz");
                var phTeacherActions = (PlaceHolder)e.Item.FindControl("phTeacherQuizActions");

                if (phTeacherActions != null)
                {
                    phTeacherActions.Visible = !IsStudentView();
                }

                if (btnAction != null && quiz != null)
                {
                    if (IsStudentView())
                    {
                        DateTime now = DateTime.Now;
                        if (now < quiz.RawOpenDate)
                        {
                            btnAction.Text = "Not Open Yet";
                            btnAction.Enabled = false;
                            btnAction.Style["background"] = "#6b7280";
                        }
                        else if (now > quiz.RawCloseDate)
                        {
                            btnAction.Text = "Closed";
                            btnAction.Enabled = false;
                            btnAction.Style["background"] = "#9ca3af";
                        }
                        else
                        {
                            btnAction.Text = "Take Quiz";
                            btnAction.Enabled = true;
                            btnAction.Style["background"] = "#059669";
                        }
                    }
                    else
                    {
                        btnAction.Text = "Preview Quiz";
                        btnAction.Enabled = true;
                        btnAction.Style["background"] = "#4f46e5";
                    }
                }
            }
        }

        protected void rptQuizzes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int quizId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "DeleteQuiz")
            {
                if (IsStudentView()) return;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string delQSql = "DELETE FROM dbo.Questions WHERE QuizID = @QuizID";
                    SqlCommand delQCmd = new SqlCommand(delQSql, conn);
                    delQCmd.Parameters.AddWithValue("@QuizID", quizId);
                    delQCmd.ExecuteNonQuery();

                    string delSql = "DELETE FROM dbo.Quizzes WHERE QuizID = @QuizID";
                    SqlCommand delCmd = new SqlCommand(delSql, conn);
                    delCmd.Parameters.AddWithValue("@QuizID", quizId);
                    delCmd.ExecuteNonQuery();
                }

                BindQuizzes();
            }
            else if (e.CommandName == "EditQuiz")
            {
                if (IsStudentView()) return;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string sql = "SELECT QuizID, Title, OpenDate, CloseDate, TimeLimit FROM dbo.Quizzes WHERE QuizID = @QuizID";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@QuizID", quizId);
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        hfEditQuizID.Value = dr["QuizID"].ToString();
                        txtFormQuizTitle.Text = dr["Title"].ToString();
                        txtFormTimeLimit.Text = dr["TimeLimit"].ToString();

                        if (dr["OpenDate"] != DBNull.Value)
                            txtFormOpenDate.Text = Convert.ToDateTime(dr["OpenDate"]).ToString("yyyy-MM-ddTHH:mm");
                        if (dr["CloseDate"] != DBNull.Value)
                            txtFormCloseDate.Text = Convert.ToDateTime(dr["CloseDate"]).ToString("yyyy-MM-ddTHH:mm");
                    }
                    dr.Close();

                    var qList = new List<QuestionModel>();
                    string qSql = "SELECT QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectAnswer FROM dbo.Questions WHERE QuizID = @QuizID";
                    SqlCommand qCmd = new SqlCommand(qSql, conn);
                    qCmd.Parameters.AddWithValue("@QuizID", quizId);
                    SqlDataReader qDr = qCmd.ExecuteReader();
                    while (qDr.Read())
                    {
                        qList.Add(new QuestionModel
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

                    JavaScriptSerializer serializer = new JavaScriptSerializer();
                    hfQuizJsonData.Value = serializer.Serialize(qList);
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "PopulateAndOpenModal", "populateEditQuizModal();", true);
            }
            else if (e.CommandName == "ActionQuiz")
            {
                var list = GetQuizzesFromDb();
                var quiz = list.Find(q => q.QuizID == quizId);

                if (quiz != null)
                {
                    Session[ActiveQuizIndexKey] = quizId;

                    pnlQuizList.Visible = false;
                    pnlQuizResults.Visible = false;

                    if (IsStudentView())
                    {
                        lblActiveQuizTitle.Text = quiz.Title;
                        hfQuizTimeLimitMinutes.Value = string.IsNullOrEmpty(quiz.TimeLimit) ? "15" : quiz.TimeLimit;
                        rptFormQuestions.DataSource = quiz.Questions;
                        rptFormQuestions.DataBind();
                        pnlTakeQuizForm.Visible = true;
                        pnlTeacherQuizPreview.Visible = false;

                        ScriptManager.RegisterStartupScript(this, GetType(), "StartQuizTimer", "startQuizTimer();", true);
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

        protected void btnSaveFormQuiz_Click(object sender, EventArgs e)
        {
            if (IsStudentView()) return;

            string title = txtFormQuizTitle.Text.Trim();
            string jsonPayload = hfQuizJsonData.Value;
            DateTime openDt = string.IsNullOrEmpty(txtFormOpenDate.Text) ? DateTime.Now : Convert.ToDateTime(txtFormOpenDate.Text);
            DateTime closeDt = string.IsNullOrEmpty(txtFormCloseDate.Text) ? DateTime.Now.AddDays(7) : Convert.ToDateTime(txtFormCloseDate.Text);
            string timeLimit = string.IsNullOrEmpty(txtFormTimeLimit.Text) ? "15" : txtFormTimeLimit.Text.Trim();

            if (!string.IsNullOrEmpty(title) && !string.IsNullOrEmpty(jsonPayload))
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer();
                List<QuestionModel> questions = serializer.Deserialize<List<QuestionModel>>(jsonPayload);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    int quizId;

                    if (!string.IsNullOrEmpty(hfEditQuizID.Value) && int.TryParse(hfEditQuizID.Value, out quizId))
                    {
                        string updateQuizSql = "UPDATE dbo.Quizzes SET Title = @Title, OpenDate = @OpenDate, CloseDate = @CloseDate, DueDate = @DueDate, TimeLimit = @TimeLimit WHERE QuizID = @QuizID";
                        SqlCommand cmd = new SqlCommand(updateQuizSql, conn);
                        cmd.Parameters.AddWithValue("@Title", title);
                        cmd.Parameters.AddWithValue("@OpenDate", openDt);
                        cmd.Parameters.AddWithValue("@CloseDate", closeDt);
                        cmd.Parameters.AddWithValue("@DueDate", closeDt);
                        cmd.Parameters.AddWithValue("@TimeLimit", timeLimit);
                        cmd.Parameters.AddWithValue("@QuizID", quizId);
                        cmd.ExecuteNonQuery();

                        string delQ = "DELETE FROM dbo.Questions WHERE QuizID = @QuizID";
                        SqlCommand delCmd = new SqlCommand(delQ, conn);
                        delCmd.Parameters.AddWithValue("@QuizID", quizId);
                        delCmd.ExecuteNonQuery();
                    }
                    else
                    {
                        string insertQuizSql = "INSERT INTO dbo.Quizzes (Title, OpenDate, CloseDate, DueDate, TimeLimit) VALUES (@Title, @OpenDate, @CloseDate, @DueDate, @TimeLimit); SELECT SCOPE_IDENTITY();";
                        SqlCommand cmd = new SqlCommand(insertQuizSql, conn);
                        cmd.Parameters.AddWithValue("@Title", title);
                        cmd.Parameters.AddWithValue("@OpenDate", openDt);
                        cmd.Parameters.AddWithValue("@CloseDate", closeDt);
                        cmd.Parameters.AddWithValue("@DueDate", closeDt);
                        cmd.Parameters.AddWithValue("@TimeLimit", timeLimit);

                        quizId = Convert.ToInt32(cmd.ExecuteScalar());
                    }

                    foreach (var q in questions)
                    {
                        string insertQSql = @"INSERT INTO dbo.Questions (QuizID, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectAnswer) 
                                              VALUES (@QuizID, @QuestionText, @OptionA, @OptionB, @OptionC, @OptionD, @CorrectAnswer)";
                        SqlCommand qCmd = new SqlCommand(insertQSql, conn);
                        qCmd.Parameters.AddWithValue("@QuizID", quizId);
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
                txtFormOpenDate.Text = "";
                txtFormCloseDate.Text = "";
                txtFormTimeLimit.Text = "";
                hfEditQuizID.Value = "";
                hfQuizJsonData.Value = "";

                BindQuizzes();
                ScriptManager.RegisterStartupScript(this, GetType(), "CloseQuizModal", "closeModal('quizFormModal');", true);
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
            int activeQuizId = Session[ActiveQuizIndexKey] != null ? (int)Session[ActiveQuizIndexKey] : 0;
            var list = GetQuizzesFromDb();
            var activeQuiz = list.Find(q => q.QuizID == activeQuizId);

            if (activeQuiz == null) return;

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
        // 3. MODULES & UNITS
        // ==========================================
        private void BindModules()
        {
            phNewModuleBtn.Visible = !IsStudentView();

            var list = new List<CourseModuleModel>();
            string courseIdStr = Request.QueryString["courseId"];
            int.TryParse(courseIdStr, out int currentCourseId);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT ModuleID, UnitTitle, LessonCount, FocusArea FROM dbo.Modules WHERE CourseID = @CourseID OR @CourseID = 0 ORDER BY ModuleID ASC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@CourseID", currentCourseId);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    list.Add(new CourseModuleModel
                    {
                        ModuleID = Convert.ToInt32(dr["ModuleID"]),
                        UnitTitle = dr["UnitTitle"].ToString(),
                        LessonCount = Convert.ToInt32(dr["LessonCount"]),
                        FocusArea = dr["FocusArea"].ToString()
                    });
                }
            }

            rptModules.DataSource = list;
            rptModules.DataBind();
        }

        public string GetContentTypeIcon(string type)
        {
            switch (type)
            {
                case "Video": return "play_circle_outline";
                case "Document": return "description";
                case "Image": return "image";
                case "Quiz": return "assignment_turned_in";
                case "Assignment": return "assignment";
                default: return "article";
            }
        }

        protected void rptModules_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "SelectModule")
            {
                int moduleId = Convert.ToInt32(e.CommandArgument);
                hfActiveModuleID.Value = moduleId.ToString();

                LoadModuleDetails(moduleId);
            }
        }

        private void LoadModuleDetails(int moduleId)
        {
            int currentStudentId = Session["LMS_StudentID"] != null ? Convert.ToInt32(Session["LMS_StudentID"]) : 1;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string modSql = "SELECT UnitTitle, FocusArea FROM dbo.Modules WHERE ModuleID = @ModuleID";
                SqlCommand modCmd = new SqlCommand(modSql, conn);
                modCmd.Parameters.AddWithValue("@ModuleID", moduleId);
                SqlDataReader dr = modCmd.ExecuteReader();
                if (dr.Read())
                {
                    lblActiveUnitTitle.Text = dr["UnitTitle"].ToString();
                    lblActiveUnitFocus.Text = dr["FocusArea"].ToString();
                }
                dr.Close();

                var rawLessons = new List<dynamic>();
                string lessonSql = @"SELECT LessonID, LessonTitle, ContentType, ContentDetails, ISNULL(SequenceOrder, LessonID) AS SequenceOrder 
                                     FROM dbo.Lessons 
                                     WHERE ModuleID = @ModuleID 
                                     ORDER BY SequenceOrder ASC, LessonID ASC";

                SqlCommand lessonCmd = new SqlCommand(lessonSql, conn);
                lessonCmd.Parameters.AddWithValue("@ModuleID", moduleId);
                SqlDataReader lDr = lessonCmd.ExecuteReader();
                while (lDr.Read())
                {
                    rawLessons.Add(new
                    {
                        LessonID = Convert.ToInt32(lDr["LessonID"]),
                        LessonTitle = lDr["LessonTitle"].ToString(),
                        ContentType = lDr["ContentType"].ToString(),
                        ContentDetails = lDr["ContentDetails"].ToString(),
                        SequenceOrder = Convert.ToInt32(lDr["SequenceOrder"])
                    });
                }
                lDr.Close();

                var lessonsWithProgression = new List<dynamic>();
                bool previousLessonCompleted = true;

                foreach (var lesson in rawLessons)
                {
                    string checkSql = "SELECT COUNT(1) FROM dbo.LessonCompletions WHERE StudentID = @StudentID AND LessonID = @LessonID";
                    SqlCommand checkCmd = new SqlCommand(checkSql, conn);
                    checkCmd.Parameters.AddWithValue("@StudentID", currentStudentId);
                    checkCmd.Parameters.AddWithValue("@LessonID", lesson.LessonID);
                    bool isCompleted = Convert.ToInt32(checkCmd.ExecuteScalar()) > 0;

                    bool isUnlocked = !IsStudentView() || previousLessonCompleted;

                    lessonsWithProgression.Add(new
                    {
                        LessonID = lesson.LessonID,
                        LessonTitle = lesson.LessonTitle,
                        ContentType = lesson.ContentType,
                        ContentDetails = lesson.ContentDetails,
                        IsCompleted = isCompleted,
                        IsUnlocked = isUnlocked
                    });

                    previousLessonCompleted = isCompleted;
                }

                rptLessons.DataSource = lessonsWithProgression;
                rptLessons.DataBind();
            }

            phTeacherAddLessonBtn.Visible = !IsStudentView();
            pnlModulesGrid.Visible = false;
            pnlModuleAccordion.Visible = true;
            btnBackToModulesGrid.Visible = true;
        }

        protected void rptLessons_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var phTeacherActions = (PlaceHolder)e.Item.FindControl("phTeacherLessonActions");
                var phStudentActions = (PlaceHolder)e.Item.FindControl("phStudentViewActions");

                if (phTeacherActions != null)
                {
                    phTeacherActions.Visible = !IsStudentView();
                }

                if (phStudentActions != null)
                {
                    phStudentActions.Visible = IsStudentView();
                }
            }
        }

        protected void rptLessons_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int lessonId = Convert.ToInt32(e.CommandArgument);
            int moduleId = Convert.ToInt32(hfActiveModuleID.Value);

            if (e.CommandName == "MarkComplete")
            {
                int studentId = Session["LMS_StudentID"] != null ? Convert.ToInt32(Session["LMS_StudentID"]) : 1;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = @"IF NOT EXISTS (SELECT 1 FROM dbo.LessonCompletions WHERE StudentID = @StudentID AND LessonID = @LessonID)
                                   BEGIN
                                       INSERT INTO dbo.LessonCompletions (StudentID, LessonID) VALUES (@StudentID, @LessonID);
                                   END";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@StudentID", studentId);
                    cmd.Parameters.AddWithValue("@LessonID", lessonId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                LoadModuleDetails(moduleId);
            }
            else if (e.CommandName == "DeleteLesson")
            {
                if (IsStudentView())
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "UnauthorizedAlert", "alert('Access Denied: Students cannot modify content.');", true);
                    return;
                }

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string deleteSql = "DELETE FROM dbo.Lessons WHERE LessonID = @LessonID";
                    SqlCommand cmd = new SqlCommand(deleteSql, conn);
                    cmd.Parameters.AddWithValue("@LessonID", lessonId);
                    cmd.ExecuteNonQuery();

                    string updateSql = "UPDATE dbo.Modules SET LessonCount = CASE WHEN LessonCount > 0 THEN LessonCount - 1 ELSE 0 END WHERE ModuleID = @ModuleID";
                    SqlCommand updateCmd = new SqlCommand(updateSql, conn);
                    updateCmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    updateCmd.ExecuteNonQuery();
                }

                LoadModuleDetails(moduleId);
            }
            else if (e.CommandName == "EditLesson")
            {
                if (IsStudentView())
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "UnauthorizedAlert", "alert('Access Denied: Students cannot modify content.');", true);
                    return;
                }

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "SELECT LessonID, LessonTitle, ContentType, ContentDetails FROM dbo.Lessons WHERE LessonID = @LessonID";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@LessonID", lessonId);
                    conn.Open();
                    SqlDataReader dr = cmd.ExecuteReader();
                    if (dr.Read())
                    {
                        hfEditLessonID.Value = dr["LessonID"].ToString();
                        txtEditLessonTitle.Text = dr["LessonTitle"].ToString();

                        string cType = dr["ContentType"].ToString();
                        if (ddlEditContentType.Items.FindByValue(cType) != null)
                        {
                            ddlEditContentType.SelectedValue = cType;
                        }

                        txtEditContentDetails.Text = dr["ContentDetails"].ToString();
                    }
                }
                ScriptManager.RegisterStartupScript(this, GetType(), "OpenEditLessonModal", "openModal('editLessonModal');", true);
            }
        }

        protected void btnUpdateLesson_Click(object sender, EventArgs e)
        {
            if (IsStudentView())
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "UnauthorizedAlert", "alert('Access Denied.');", true);
                return;
            }

            if (!string.IsNullOrEmpty(hfEditLessonID.Value) && !string.IsNullOrEmpty(txtEditLessonTitle.Text.Trim()))
            {
                int lessonId = Convert.ToInt32(hfEditLessonID.Value);
                int moduleId = Convert.ToInt32(hfActiveModuleID.Value);
                string contentDetails = txtEditContentDetails.Text.Trim();

                if (fileEditContentUpload.HasFile)
                {
                    try
                    {
                        string filename = Path.GetFileName(fileEditContentUpload.FileName);
                        string uniqueFileName = Guid.NewGuid().ToString("N").Substring(0, 8) + "_" + filename;

                        string uploadFolder = Server.MapPath("~/Uploads/Lessons/");
                        if (!Directory.Exists(uploadFolder))
                        {
                            Directory.CreateDirectory(uploadFolder);
                        }

                        string savePath = Path.Combine(uploadFolder, uniqueFileName);
                        fileEditContentUpload.SaveAs(savePath);

                        contentDetails = "~/Uploads/Lessons/" + uniqueFileName;
                    }
                    catch (Exception ex)
                    {
                        string cleanMsg = ex.Message.Replace("'", "\\'");
                        ScriptManager.RegisterStartupScript(this, GetType(), "UploadError", $"alert('File Upload Error: {cleanMsg}');", true);
                        return;
                    }
                }

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "UPDATE dbo.Lessons SET LessonTitle = @LessonTitle, ContentType = @ContentType, ContentDetails = @ContentDetails WHERE LessonID = @LessonID";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@LessonTitle", txtEditLessonTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@ContentType", ddlEditContentType.SelectedValue);
                    cmd.Parameters.AddWithValue("@ContentDetails", string.IsNullOrEmpty(contentDetails) ? "No details provided" : contentDetails);
                    cmd.Parameters.AddWithValue("@LessonID", lessonId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "CloseEditLessonModal", "closeModal('editLessonModal');", true);
                LoadModuleDetails(moduleId);
            }
        }

        protected void btnBackToModulesGrid_Click(object sender, EventArgs e)
        {
            pnlModuleAccordion.Visible = false;
            btnBackToModulesGrid.Visible = false;
            pnlModulesGrid.Visible = true;
            BindModules();
        }

        protected void btnSaveModule_Click(object sender, EventArgs e)
        {
            if (IsStudentView())
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "UnauthorizedAlert", "alert('Access Denied: Students cannot create modules.');", true);
                return;
            }

            if (!string.IsNullOrEmpty(txtUnitTitle.Text.Trim()))
            {
                string courseIdStr = Request.QueryString["courseId"];
                int.TryParse(courseIdStr, out int currentCourseId);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "INSERT INTO dbo.Modules (CourseID, UnitTitle, LessonCount, FocusArea) VALUES (@CourseID, @UnitTitle, @LessonCount, @FocusArea)";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@CourseID", currentCourseId);
                    cmd.Parameters.AddWithValue("@UnitTitle", txtUnitTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@LessonCount", string.IsNullOrEmpty(txtLessonCount.Text) ? 0 : Convert.ToInt32(txtLessonCount.Text.Trim()));
                    cmd.Parameters.AddWithValue("@FocusArea", string.IsNullOrEmpty(txtFocusArea.Text) ? "General Practice" : txtFocusArea.Text.Trim());

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                txtUnitTitle.Text = "";
                txtLessonCount.Text = "";
                txtFocusArea.Text = "";

                BindModules();
                ScriptManager.RegisterStartupScript(this, GetType(), "CloseModuleModal", "closeModal('moduleModal');", true);
            }
        }

        protected void btnSaveLesson_Click(object sender, EventArgs e)
        {
            if (IsStudentView())
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "UnauthorizedAlert", "alert('Access Denied.');", true);
                return;
            }

            if (!string.IsNullOrEmpty(txtLessonTitle.Text.Trim()) && !string.IsNullOrEmpty(hfActiveModuleID.Value))
            {
                int moduleId = Convert.ToInt32(hfActiveModuleID.Value);
                string contentDetails = txtContentDetails.Text.Trim();

                if (fileContentUpload.HasFile)
                {
                    try
                    {
                        string filename = Path.GetFileName(fileContentUpload.FileName);
                        string uniqueFileName = Guid.NewGuid().ToString("N").Substring(0, 8) + "_" + filename;

                        string uploadFolder = Server.MapPath("~/Uploads/Lessons/");
                        if (!Directory.Exists(uploadFolder))
                        {
                            Directory.CreateDirectory(uploadFolder);
                        }

                        string savePath = Path.Combine(uploadFolder, uniqueFileName);
                        fileContentUpload.SaveAs(savePath);

                        contentDetails = "~/Uploads/Lessons/" + uniqueFileName;
                    }
                    catch (Exception ex)
                    {
                        string cleanMsg = ex.Message.Replace("'", "\\'");
                        ScriptManager.RegisterStartupScript(this, GetType(), "UploadError", $"alert('File Upload Error: {cleanMsg}');", true);
                        return;
                    }
                }

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "INSERT INTO dbo.Lessons (ModuleID, LessonTitle, ContentType, ContentDetails) VALUES (@ModuleID, @LessonTitle, @ContentType, @ContentDetails)";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    cmd.Parameters.AddWithValue("@LessonTitle", txtLessonTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@ContentType", ddlContentType.SelectedValue);
                    cmd.Parameters.AddWithValue("@ContentDetails", string.IsNullOrEmpty(contentDetails) ? "No details provided" : contentDetails);

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    string updateSql = "UPDATE dbo.Modules SET LessonCount = LessonCount + 1 WHERE ModuleID = @ModuleID";
                    SqlCommand updateCmd = new SqlCommand(updateSql, conn);
                    updateCmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    updateCmd.ExecuteNonQuery();
                }

                txtLessonTitle.Text = "";
                txtContentDetails.Text = "";

                LoadModuleDetails(moduleId);
                ScriptManager.RegisterStartupScript(this, GetType(), "CloseLessonModal", "closeModal('addLessonModal');", true);
            }
        }

        // ==========================================
        // 4. ASSIGNMENTS
        // ==========================================
        private void BindAssignments()
        {
            btnOpenAssignmentModal.Visible = !IsStudentView();

            var list = new List<AssignmentModel>();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT AssignmentID, AssignmentName, CourseName, 
                                      FORMAT(OpenDate, 'MMM dd, yyyy hh:mm tt') AS OpenDateFormatted,
                                      FORMAT(CloseDate, 'MMM dd, yyyy hh:mm tt') AS CloseDateFormatted,
                                      OpenDate, CloseDate, ISNULL(MaxPoints, 100) AS MaxPoints 
                               FROM dbo.Assignments 
                               ORDER BY AssignmentID DESC";

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
                        OpenDate = dr["OpenDateFormatted"].ToString(),
                        EndDateTime = dr["CloseDateFormatted"].ToString(),
                        RawOpenDate = dr["OpenDate"] != DBNull.Value ? Convert.ToDateTime(dr["OpenDate"]) : DateTime.Now,
                        RawCloseDate = dr["CloseDate"] != DBNull.Value ? Convert.ToDateTime(dr["CloseDate"]) : DateTime.Now.AddDays(7),
                        MaxPoints = Convert.ToInt32(dr["MaxPoints"])
                    });
                }
            }
            rptAssignments.DataSource = list;
            rptAssignments.DataBind();
        }

        protected void rptAssignments_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var model = (AssignmentModel)e.Item.DataItem;
                var lblStatus = (Label)e.Item.FindControl("lblAssignmentStatus");

                if (lblStatus != null && model != null)
                {
                    DateTime now = DateTime.Now;
                    if (now < model.RawOpenDate)
                    {
                        lblStatus.Text = "Not Open";
                        lblStatus.Style["background"] = "#6b7280";
                        lblStatus.Style["color"] = "#ffffff";
                    }
                    else if (now > model.RawCloseDate)
                    {
                        lblStatus.Text = "Closed";
                        lblStatus.Style["background"] = "#ef4444";
                        lblStatus.Style["color"] = "#ffffff";
                    }
                    else
                    {
                        lblStatus.Text = "Open";
                        lblStatus.Style["background"] = "#059669";
                        lblStatus.Style["color"] = "#ffffff";
                    }
                }
            }
        }

        protected void rptAssignments_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "ViewAssignment")
            {
                int assignmentId = Convert.ToInt32(e.CommandArgument);
                OpenAssignmentDetailView(assignmentId);
            }
        }

        private void OpenAssignmentDetailView(int assignmentId)
        {
            hfActiveAssignmentID.Value = assignmentId.ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT AssignmentName, OpenDate, CloseDate, MaxPoints, Instructions FROM dbo.Assignments WHERE AssignmentID = @ID";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@ID", assignmentId);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                if (dr.Read())
                {
                    lblDetailAssignmentTitle.Text = dr["AssignmentName"].ToString();
                    lblDetailOpenDate.Text = dr["OpenDate"] != DBNull.Value ? Convert.ToDateTime(dr["OpenDate"]).ToString("MMM dd, yyyy hh:mm tt") : "N/A";
                    lblDetailDueDate.Text = dr["CloseDate"] != DBNull.Value ? Convert.ToDateTime(dr["CloseDate"]).ToString("MMM dd, yyyy hh:mm tt") : "N/A";
                    lblDetailMaxPoints.Text = dr["MaxPoints"].ToString();
                    lblDetailInstructions.Text = string.IsNullOrEmpty(dr["Instructions"].ToString()) ? "No specific instructions provided." : dr["Instructions"].ToString();
                }
            }

            rptAssignments.Visible = false;
            btnOpenAssignmentModal.Visible = false;
            pnlAssignmentDetail.Visible = true;

            if (IsStudentView())
            {
                pnlStudentSubmission.Visible = true;
                pnlTeacherSubmissions.Visible = false;
            }
            else
            {
                pnlStudentSubmission.Visible = false;
                pnlTeacherSubmissions.Visible = true;
                BindSubmissions(assignmentId);
            }
        }

        private void BindSubmissions(int assignmentId)
        {
            var list = new List<dynamic>();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT StudentName, FORMAT(SubmittedDate, 'MMM dd, yyyy hh:mm tt') AS SubmittedDateFormatted, FilePath, SubmissionText, Grade FROM dbo.AssignmentSubmissions WHERE AssignmentID = @ID ORDER BY SubmissionID DESC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@ID", assignmentId);
                conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();
                while (dr.Read())
                {
                    list.Add(new
                    {
                        StudentName = dr["StudentName"].ToString(),
                        SubmittedDate = dr["SubmittedDateFormatted"].ToString(),
                        FilePath = dr["FilePath"].ToString(),
                        SubmissionText = dr["SubmissionText"].ToString(),
                        Grade = dr["Grade"].ToString()
                    });
                }
            }
            rptSubmissions.DataSource = list;
            rptSubmissions.DataBind();
        }

        protected void btnSubmitAssignmentWork_Click(object sender, EventArgs e)
        {
            int assignmentId = Convert.ToInt32(hfActiveAssignmentID.Value);
            string filePath = "";

            if (fileSubmissionUpload.HasFile)
            {
                string folder = Server.MapPath("~/Uploads/Submissions/");
                if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);

                string uniqueFile = Guid.NewGuid().ToString("N").Substring(0, 8) + "_" + Path.GetFileName(fileSubmissionUpload.FileName);
                fileSubmissionUpload.SaveAs(Path.Combine(folder, uniqueFile));
                filePath = "~/Uploads/Submissions/" + uniqueFile;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "INSERT INTO dbo.AssignmentSubmissions (AssignmentID, StudentName, SubmissionText, FilePath) VALUES (@AID, @Student, @Text, @File)";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@AID", assignmentId);
                cmd.Parameters.AddWithValue("@Student", "Student User");
                cmd.Parameters.AddWithValue("@Text", txtSubmissionNotes.Text.Trim());
                cmd.Parameters.AddWithValue("@File", filePath);
                conn.Open();
                cmd.ExecuteNonQuery();
            }

            txtSubmissionNotes.Text = "";
            ScriptManager.RegisterStartupScript(this, GetType(), "SubmitSuccess", "alert('Assignment submitted successfully!');", true);
        }

        protected void btnBackToAssignments_Click(object sender, EventArgs e)
        {
            pnlAssignmentDetail.Visible = false;
            rptAssignments.Visible = true;
            btnOpenAssignmentModal.Visible = !IsStudentView();
            BindAssignments();
        }

        protected void btnSaveAssignment_Click(object sender, EventArgs e)
        {
            if (IsStudentView())
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "UnauthorizedAlert", "alert('Access Denied: Students cannot create assignments.');", true);
                return;
            }

            if (!string.IsNullOrEmpty(txtAssignmentTitle.Text.Trim()))
            {
                DateTime openDt = string.IsNullOrEmpty(txtAssignmentStartDate.Text) ? DateTime.Now : Convert.ToDateTime(txtAssignmentStartDate.Text);
                DateTime closeDt = string.IsNullOrEmpty(txtAssignmentDueDate.Text) ? DateTime.Now.AddDays(7) : Convert.ToDateTime(txtAssignmentDueDate.Text);
                int maxPts = string.IsNullOrEmpty(txtMaxPoints.Text) ? 100 : Convert.ToInt32(txtMaxPoints.Text);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = @"INSERT INTO dbo.Assignments 
                                   (AssignmentName, CourseName, OpenDate, EndDateTime, CloseDate, MaxPoints, Instructions, ManualGrading, Completed)
                                   VALUES 
                                   (@AssignmentName, @CourseName, @OpenDate, @CloseDate, @CloseDate, @MaxPoints, @Instructions, @ManualGrading, @Completed)";

                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@AssignmentName", txtAssignmentTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@CourseName", lblCourseTitle.Text);
                    cmd.Parameters.AddWithValue("@OpenDate", openDt);
                    cmd.Parameters.AddWithValue("@CloseDate", closeDt);
                    cmd.Parameters.AddWithValue("@MaxPoints", maxPts);
                    cmd.Parameters.AddWithValue("@Instructions", txtAssignmentInstructions.Text.Trim());

                    bool isManualGrading = false;
                    cmd.Parameters.AddWithValue("@ManualGrading", isManualGrading);

                    bool isCompleted = false;
                    cmd.Parameters.AddWithValue("@Completed", isCompleted);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }

                txtAssignmentTitle.Text = "";
                txtAssignmentStartDate.Text = "";
                txtAssignmentDueDate.Text = "";
                txtAssignmentInstructions.Text = "";

                BindAssignments();
                ScriptManager.RegisterStartupScript(this, GetType(), "CloseAssignmentModal", "closeModal('assignmentModal');", true);
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
}