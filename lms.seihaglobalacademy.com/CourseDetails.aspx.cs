using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace lms.seihaglobalacademy.com
{
    public partial class CourseDetails : System.Web.UI.Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["SGA_LMSDB"].ConnectionString;
        private const string ActiveQuizIndexKey = "LMS_Demo_ActiveQuizIndex";

        private int CurrentCourseID
        {
            get
            {
                if (int.TryParse(Request.QueryString["courseId"], out int id))
                    return id;
                return 0;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            UpdateTeacherBannerVisibility();

            if (!IsPostBack)
            {
                InitializeCourseContext();
                BindAll();

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

        #region FILE UPLOADS, PATH & AUDIT LOGGING HELPERS

        private string SanitizeFolderName(string name)
        {
            if (string.IsNullOrWhiteSpace(name)) return "General";

            char[] invalidChars = Path.GetInvalidFileNameChars();
            foreach (char c in invalidChars)
            {
                name = name.Replace(c.ToString(), "");
            }

            return name.Trim().Replace(" ", "_");
        }

        private string GetTargetUploadDirectory(string moduleTitle, string subFolder)
        {
            string courseFolder = "Course_" + (CurrentCourseID > 0 ? CurrentCourseID.ToString() : "Default");
            if (!string.IsNullOrEmpty(lblCourseTitle.Text) && lblCourseTitle.Text != "Sample Course")
            {
                courseFolder = SanitizeFolderName(lblCourseTitle.Text);
            }

            string sanitizedModule = string.IsNullOrEmpty(moduleTitle) ? "General" : SanitizeFolderName(moduleTitle);

            string relativePath = $"~/Uploads/Courses/{courseFolder}/Modules/{sanitizedModule}/{subFolder}/";
            string physicalPath = Server.MapPath(relativePath);

            if (!Directory.Exists(physicalPath))
            {
                Directory.CreateDirectory(physicalPath);
            }

            return relativePath;
        }

        private string GetModuleTitleById(int moduleId)
        {
            if (moduleId <= 0) return "General";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT UnitTitle FROM dbo.Modules WHERE ModuleID = @ModuleID";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                    {
                        return result.ToString();
                    }
                }
            }
            return "General";
        }

        public string GetFileUrl(string storedPath)
        {
            if (string.IsNullOrEmpty(storedPath)) return "#";

            try
            {
                string mappedPath = Server.MapPath(storedPath);
                if (File.Exists(mappedPath))
                {
                    return ResolveUrl(storedPath);
                }

                string fileName = Path.GetFileName(storedPath);
                string legacyPath = $"~/Uploads/Lessons/{fileName}";
                if (File.Exists(Server.MapPath(legacyPath)))
                {
                    return ResolveUrl(legacyPath);
                }

                string legacySubPath = $"~/Uploads/Submissions/{fileName}";
                if (File.Exists(Server.MapPath(legacySubPath)))
                {
                    return ResolveUrl(legacySubPath);
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("GetFileUrl Resolution Exception: " + ex.Message);
            }

            return ResolveUrl(storedPath);
        }

        private void LogFileAudit(string filePath, string actionType, string category)
        {
            if (string.IsNullOrEmpty(filePath)) return;

            int userId = Session["UserID"] != null ? Convert.ToInt32(Session["UserID"]) : 0;
            string userName = IsStudentView() ? "Student User" : (Session["UserName"] != null ? Session["UserName"].ToString() : "Teacher / Admin");

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string checkSql = "IF OBJECT_ID('dbo.FileAuditLogs', 'U') IS NOT NULL " +
                                      "INSERT INTO dbo.FileAuditLogs (FilePath, ActionType, Category, CourseID, UserID, PerformedBy, ActionDate) " +
                                      "VALUES (@FilePath, @ActionType, @Category, @CourseID, @UserID, @PerformedBy, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(checkSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@FilePath", filePath);
                        cmd.Parameters.AddWithValue("@ActionType", actionType);
                        cmd.Parameters.AddWithValue("@Category", category);
                        cmd.Parameters.AddWithValue("@CourseID", CurrentCourseID);
                        cmd.Parameters.AddWithValue("@UserID", userId);
                        cmd.Parameters.AddWithValue("@PerformedBy", userName);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Trace.TraceError("File Audit Log Error: " + ex.Message);
            }
        }

        #endregion

        private void InitializeCourseContext()
        {
            if (CurrentCourseID > 0)
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "SELECT CourseName FROM dbo.Courses WHERE CourseID = @CourseID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", CurrentCourseID);
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != null && result != DBNull.Value)
                        {
                            lblCourseTitle.Text = result.ToString();
                            return;
                        }
                    }
                }
            }

            lblCourseTitle.Text = "Sample Course";
        }

        private void BindAll()
        {
            UpdateTeacherBannerVisibility();

            BindAnnouncements();
            BindQuizzes();
            BindAssignments();
            BindModules();
        }

        private void UpdateTeacherBannerVisibility()
        {
            bool showTeacherBanner = !IsStudentView();

            if (phTeacherBanner != null)
            {
                phTeacherBanner.Visible = showTeacherBanner;
            }
            else
            {
                Control found = FindControlRecursive(this, "phTeacherBanner");
                if (found != null)
                {
                    found.Visible = showTeacherBanner;
                }
            }
        }

        private Control FindControlRecursive(Control root, string id)
        {
            if (root.ID == id) return root;
            foreach (Control c in root.Controls)
            {
                Control t = FindControlRecursive(c, id);
                if (t != null) return t;
            }
            return null;
        }

        private void SwitchTab(string target, string assignmentIdStr = null)
        {
            UpdateTeacherBannerVisibility();

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
                    BindGradebook();
                    break;

                case "UserManagement":
                    liUserManagement.Attributes["class"] = "active teacher-only-control";
                    pnlUserManagement.Visible = true;
                    BindUserManagement();
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
                string sql = "SELECT AnnouncementID, Title, Author, FORMAT(PostDate, 'MMM dd, yyyy') AS PostDateFormatted, Body FROM dbo.Announcements WHERE CourseID = @CourseID ORDER BY AnnouncementID DESC";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseID", CurrentCourseID);

                    conn.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
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

            string title = txtAnnouncementTitle.Text.Trim();
            string rawBody = hfAnnouncementBody.Value;
            string bodyHtml = HttpUtility.UrlDecode(rawBody);

            if (!string.IsNullOrEmpty(title) && !string.IsNullOrEmpty(bodyHtml))
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string sql = "INSERT INTO dbo.Announcements (CourseID, Title, Author, Body) VALUES (@CourseID, @Title, @Author, @Body)";
                        using (SqlCommand cmd = new SqlCommand(sql, conn))
                        {
                            cmd.Parameters.AddWithValue("@CourseID", CurrentCourseID);
                            cmd.Parameters.AddWithValue("@Title", title);
                            cmd.Parameters.AddWithValue("@Author", "Teacher / Admin");
                            cmd.Parameters.AddWithValue("@Body", bodyHtml);

                            conn.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }

                    txtAnnouncementTitle.Text = "";
                    hfAnnouncementBody.Value = "";

                    BindAnnouncements();
                    ScriptManager.RegisterStartupScript(this, GetType(), "CloseAnnounceModal", "closeModal('announcementModal');", true);
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Trace.TraceError("Post Announcement Error: " + ex.Message);
                    ScriptManager.RegisterStartupScript(this, GetType(), "SqlErrorAlert", "alert('An error occurred while saving the announcement.');", true);
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
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@ID", announcementId);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                BindAnnouncements();
            }
            else if (e.CommandName == "EditAnnouncement")
            {
                string bodyContent = "";
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "SELECT AnnouncementID, Title, Body FROM dbo.Announcements WHERE AnnouncementID = @ID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@ID", announcementId);
                        conn.Open();
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                hfEditAnnouncementID.Value = dr["AnnouncementID"].ToString();
                                txtEditAnnouncementTitle.Text = dr["Title"].ToString();
                                bodyContent = dr["Body"].ToString();
                            }
                        }
                    }
                }

                string encodedBodyHtml = HttpUtility.UrlDecode(bodyContent);
                string script = $"loadQuillEditContent('{encodedBodyHtml}'); openModal('editAnnouncementModal');";
                ScriptManager.RegisterStartupScript(this, GetType(), "OpenEditQuillModal", script, true);
            }
        }

        protected void btnUpdateAnnouncement_Click(object sender, EventArgs e)
        {
            if (IsStudentView())
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "UnauthorizedAlert", "alert('Access Denied: Students cannot update announcements.');", true);
                return;
            }

            string announcementId = hfEditAnnouncementID.Value;
            string title = txtEditAnnouncementTitle.Text.Trim();
            string rawBody = hfEditAnnouncementBody.Value;
            string bodyHtml = HttpUtility.UrlDecode(rawBody);

            if (!string.IsNullOrEmpty(announcementId) && !string.IsNullOrEmpty(title) && !string.IsNullOrEmpty(bodyHtml))
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "UPDATE dbo.Announcements SET Title = @Title, Body = @Body WHERE AnnouncementID = @ID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Title", title);
                        cmd.Parameters.AddWithValue("@Body", bodyHtml);
                        cmd.Parameters.AddWithValue("@ID", Convert.ToInt32(announcementId));
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "CloseEditModal", "closeModal('editAnnouncementModal');", true);
                BindAnnouncements();
            }
        }

        // ==========================================
        // 2. QUIZZES & 7 EXAM STYLES SUPPORT
        // ==========================================
        private List<GoogleFormQuizModel> GetQuizzesFromDb()
        {
            var quizzes = new List<GoogleFormQuizModel>();
            var quizMap = new Dictionary<int, GoogleFormQuizModel>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string quizSql = "SELECT QuizID, Title, OpenDate, CloseDate, TimeLimit, ISNULL(Instructions, '') AS Instructions FROM dbo.Quizzes WHERE CourseID = @CourseID ORDER BY QuizID DESC";
                using (SqlCommand quizCmd = new SqlCommand(quizSql, conn))
                {
                    quizCmd.Parameters.AddWithValue("@CourseID", CurrentCourseID);

                    using (SqlDataReader dr = quizCmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            int id = Convert.ToInt32(dr["QuizID"]);
                            DateTime openDt = dr["OpenDate"] != DBNull.Value ? Convert.ToDateTime(dr["OpenDate"]) : DateTime.Now;
                            DateTime closeDt = dr["CloseDate"] != DBNull.Value ? Convert.ToDateTime(dr["CloseDate"]) : DateTime.Now.AddDays(7);

                            var qModel = new GoogleFormQuizModel
                            {
                                QuizID = id,
                                Title = dr["Title"].ToString(),
                                OpenDate = openDt.ToString("MMM dd, yyyy hh:mm tt"),
                                CloseDate = closeDt.ToString("MMM dd, yyyy hh:mm tt"),
                                RawOpenDate = openDt,
                                RawCloseDate = closeDt,
                                TimeLimit = dr["TimeLimit"].ToString(),
                                Instructions = dr["Instructions"].ToString(),
                                Questions = new List<QuestionModel>()
                            };

                            quizzes.Add(qModel);
                            quizMap[id] = qModel;
                        }
                    }
                }

                if (!quizzes.Any()) return quizzes;

                string qSql = @"SELECT q.QuizID, ISNULL(q.QuestionType, 'Multiple Choice') AS QuestionType, 
                                       q.QuestionText, q.OptionA, q.OptionB, q.OptionC, q.OptionD, q.CorrectAnswer, 
                                       ISNULL(q.CorrectTextAnswer,'') AS CorrectTextAnswer, 
                                       ISNULL(q.EnumerationAnswers,'') AS EnumerationAnswers, 
                                       ISNULL(q.MatchingPairsJson,'') AS MatchingPairsJson, 
                                       ISNULL(q.ImagePath,'') AS ImagePath, ISNULL(q.AudioPath,'') AS AudioPath 
                                FROM dbo.Questions q
                                INNER JOIN dbo.Quizzes qz ON q.QuizID = qz.QuizID
                                WHERE qz.CourseID = @CourseID";

                using (SqlCommand qCmd = new SqlCommand(qSql, conn))
                {
                    qCmd.Parameters.AddWithValue("@CourseID", CurrentCourseID);

                    using (SqlDataReader qDr = qCmd.ExecuteReader())
                    {
                        while (qDr.Read())
                        {
                            int qId = Convert.ToInt32(qDr["QuizID"]);
                            if (quizMap.ContainsKey(qId))
                            {
                                quizMap[qId].Questions.Add(new QuestionModel
                                {
                                    QuestionType = qDr["QuestionType"].ToString(),
                                    QuestionText = qDr["QuestionText"].ToString(),
                                    OptionA = qDr["OptionA"].ToString(),
                                    OptionB = qDr["OptionB"].ToString(),
                                    OptionC = qDr["OptionC"].ToString(),
                                    OptionD = qDr["OptionD"].ToString(),
                                    CorrectAnswer = qDr["CorrectAnswer"].ToString(),
                                    CorrectTextAnswer = qDr["CorrectTextAnswer"].ToString(),
                                    EnumerationAnswers = qDr["EnumerationAnswers"].ToString(),
                                    MatchingPairsJson = qDr["MatchingPairsJson"].ToString(),
                                    ImagePath = qDr["ImagePath"].ToString(),
                                    AudioPath = qDr["AudioPath"].ToString()
                                });
                            }
                        }
                    }
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
                    using (SqlCommand delQCmd = new SqlCommand(delQSql, conn))
                    {
                        delQCmd.Parameters.AddWithValue("@QuizID", quizId);
                        delQCmd.ExecuteNonQuery();
                    }

                    string delSql = "DELETE FROM dbo.Quizzes WHERE QuizID = @QuizID";
                    using (SqlCommand delCmd = new SqlCommand(delSql, conn))
                    {
                        delCmd.Parameters.AddWithValue("@QuizID", quizId);
                        delCmd.ExecuteNonQuery();
                    }
                }

                BindQuizzes();
            }
            else if (e.CommandName == "EditQuiz")
            {
                if (IsStudentView()) return;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string sql = "SELECT QuizID, Title, OpenDate, CloseDate, TimeLimit, ISNULL(Instructions, '') AS Instructions FROM dbo.Quizzes WHERE QuizID = @QuizID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@QuizID", quizId);

                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                hfEditQuizID.Value = dr["QuizID"].ToString();
                                txtFormQuizTitle.Text = dr["Title"].ToString();
                                txtFormTimeLimit.Text = dr["TimeLimit"].ToString();
                                txtFormInstructions.Text = dr["Instructions"].ToString();

                                if (dr["OpenDate"] != DBNull.Value)
                                    txtFormOpenDate.Text = Convert.ToDateTime(dr["OpenDate"]).ToString("yyyy-MM-ddTHH:mm");
                                if (dr["CloseDate"] != DBNull.Value)
                                    txtFormCloseDate.Text = Convert.ToDateTime(dr["CloseDate"]).ToString("yyyy-MM-ddTHH:mm");
                            }
                        }
                    }

                    var qList = new List<QuestionModel>();
                    string qSql = @"SELECT ISNULL(QuestionType, 'Multiple Choice') AS QuestionType, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectAnswer, 
                                           ISNULL(CorrectTextAnswer,'') AS CorrectTextAnswer, ISNULL(EnumerationAnswers,'') AS EnumerationAnswers, ISNULL(MatchingPairsJson,'') AS MatchingPairsJson,
                                           ISNULL(ImagePath,'') AS ImagePath, ISNULL(AudioPath,'') AS AudioPath 
                                    FROM dbo.Questions WHERE QuizID = @QuizID";
                    using (SqlCommand qCmd = new SqlCommand(qSql, conn))
                    {
                        qCmd.Parameters.AddWithValue("@QuizID", quizId);

                        using (SqlDataReader qDr = qCmd.ExecuteReader())
                        {
                            while (qDr.Read())
                            {
                                qList.Add(new QuestionModel
                                {
                                    QuestionType = qDr["QuestionType"].ToString(),
                                    QuestionText = qDr["QuestionText"].ToString(),
                                    OptionA = qDr["OptionA"].ToString(),
                                    OptionB = qDr["OptionB"].ToString(),
                                    OptionC = qDr["OptionC"].ToString(),
                                    OptionD = qDr["OptionD"].ToString(),
                                    CorrectAnswer = qDr["CorrectAnswer"].ToString(),
                                    CorrectTextAnswer = qDr["CorrectTextAnswer"].ToString(),
                                    EnumerationAnswers = qDr["EnumerationAnswers"].ToString(),
                                    MatchingPairsJson = qDr["MatchingPairsJson"].ToString(),
                                    ImagePath = qDr["ImagePath"].ToString(),
                                    AudioPath = qDr["AudioPath"].ToString(),
                                    Instructions = txtFormInstructions.Text.Trim()
                                });
                            }
                        }
                    }

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

                    string displayInstructions = string.IsNullOrWhiteSpace(quiz.Instructions)
                        ? "Please complete all questions below and click Submit."
                        : quiz.Instructions;

                    if (IsStudentView())
                    {
                        lblActiveQuizTitle.Text = quiz.Title;
                        lblActiveQuizInstructions.Text = displayInstructions;
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
                        lblTeacherPreviewInstructions.Text = displayInstructions;
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
            string instructions = txtFormInstructions.Text.Trim();

            if (!string.IsNullOrEmpty(title) && !string.IsNullOrEmpty(jsonPayload))
            {
                JavaScriptSerializer serializer = new JavaScriptSerializer { MaxJsonLength = 104857600 };
                List<QuestionModel> questions = serializer.Deserialize<List<QuestionModel>>(jsonPayload);

                string relativeUploadDir = GetTargetUploadDirectory("QuizMedia", "Quizzes");
                string uploadFolder = Server.MapPath(relativeUploadDir);

                for (int qi = 0; qi < questions.Count; qi++)
                {
                    var q = questions[qi];

                    if (!string.IsNullOrEmpty(q.ImagePath) && q.ImagePath.StartsWith("data:image/"))
                    {
                        try
                        {
                            int commaIdx = q.ImagePath.IndexOf(',');
                            string header = q.ImagePath.Substring(0, commaIdx);
                            string base64Data = q.ImagePath.Substring(commaIdx + 1);

                            string ext = ".png";
                            if (header.Contains("jpeg") || header.Contains("jpg")) ext = ".jpg";
                            else if (header.Contains("gif")) ext = ".gif";
                            else if (header.Contains("webp")) ext = ".webp";

                            string fileName = "qimg_" + Guid.NewGuid().ToString("N").Substring(0, 10) + ext;
                            string savePath = Path.Combine(uploadFolder, fileName);
                            byte[] bytes = Convert.FromBase64String(base64Data);
                            File.WriteAllBytes(savePath, bytes);

                            q.ImagePath = relativeUploadDir + fileName;
                            LogFileAudit(q.ImagePath, "UPLOADED", "QuizMedia");
                        }
                        catch (Exception ex)
                        {
                            System.Diagnostics.Trace.TraceError("Quiz Image decode failure: " + ex.Message);
                            q.ImagePath = "";
                        }
                    }

                    if (!string.IsNullOrEmpty(q.AudioPath) && q.AudioPath.StartsWith("data:audio/"))
                    {
                        try
                        {
                            int commaIdx = q.AudioPath.IndexOf(',');
                            string header = q.AudioPath.Substring(0, commaIdx);
                            string base64Data = q.AudioPath.Substring(commaIdx + 1);

                            string ext = ".mp3";
                            if (header.Contains("ogg")) ext = ".ogg";
                            else if (header.Contains("wav")) ext = ".wav";

                            string fileName = "qaudio_" + Guid.NewGuid().ToString("N").Substring(0, 10) + ext;
                            string savePath = Path.Combine(uploadFolder, fileName);
                            byte[] bytes = Convert.FromBase64String(base64Data);
                            File.WriteAllBytes(savePath, bytes);

                            q.AudioPath = relativeUploadDir + fileName;
                            LogFileAudit(q.AudioPath, "UPLOADED", "QuizMedia");
                        }
                        catch (Exception ex)
                        {
                            System.Diagnostics.Trace.TraceError("Quiz Audio decode failure: " + ex.Message);
                            q.AudioPath = "";
                        }
                    }

                    questions[qi] = q;
                }

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    int quizId;

                    if (!string.IsNullOrEmpty(hfEditQuizID.Value) && int.TryParse(hfEditQuizID.Value, out quizId))
                    {
                        string updateQuizSql = "UPDATE dbo.Quizzes SET Title = @Title, OpenDate = @OpenDate, CloseDate = @CloseDate, DueDate = @DueDate, TimeLimit = @TimeLimit, Instructions = @Instructions WHERE QuizID = @QuizID";
                        using (SqlCommand cmd = new SqlCommand(updateQuizSql, conn))
                        {
                            cmd.Parameters.AddWithValue("@Title", title);
                            cmd.Parameters.AddWithValue("@OpenDate", openDt);
                            cmd.Parameters.AddWithValue("@CloseDate", closeDt);
                            cmd.Parameters.AddWithValue("@DueDate", closeDt);
                            cmd.Parameters.AddWithValue("@TimeLimit", timeLimit);
                            cmd.Parameters.AddWithValue("@Instructions", instructions);
                            cmd.Parameters.AddWithValue("@QuizID", quizId);
                            cmd.ExecuteNonQuery();
                        }

                        string delQ = "DELETE FROM dbo.Questions WHERE QuizID = @QuizID";
                        using (SqlCommand delCmd = new SqlCommand(delQ, conn))
                        {
                            delCmd.Parameters.AddWithValue("@QuizID", quizId);
                            delCmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        string insertQuizSql = "INSERT INTO dbo.Quizzes (CourseID, Title, OpenDate, CloseDate, DueDate, TimeLimit, Instructions) VALUES (@CourseID, @Title, @OpenDate, @CloseDate, @DueDate, @TimeLimit, @Instructions); SELECT SCOPE_IDENTITY();";
                        using (SqlCommand cmd = new SqlCommand(insertQuizSql, conn))
                        {
                            cmd.Parameters.AddWithValue("@CourseID", CurrentCourseID);
                            cmd.Parameters.AddWithValue("@Title", title);
                            cmd.Parameters.AddWithValue("@OpenDate", openDt);
                            cmd.Parameters.AddWithValue("@CloseDate", closeDt);
                            cmd.Parameters.AddWithValue("@DueDate", closeDt);
                            cmd.Parameters.AddWithValue("@TimeLimit", timeLimit);
                            cmd.Parameters.AddWithValue("@Instructions", instructions);

                            quizId = Convert.ToInt32(cmd.ExecuteScalar());
                        }
                    }

                    foreach (var q in questions)
                    {
                        string insertQSql = @"INSERT INTO dbo.Questions 
                            (QuizID, QuestionType, QuestionText, OptionA, OptionB, OptionC, OptionD, CorrectAnswer, CorrectTextAnswer, EnumerationAnswers, MatchingPairsJson, ImagePath, AudioPath) 
                            VALUES 
                            (@QuizID, @QuestionType, @QuestionText, @OptionA, @OptionB, @OptionC, @OptionD, @CorrectAnswer, @CorrectTextAnswer, @EnumerationAnswers, @MatchingPairsJson, @ImagePath, @AudioPath)";

                        using (SqlCommand qCmd = new SqlCommand(insertQSql, conn))
                        {
                            qCmd.Parameters.AddWithValue("@QuizID", quizId);
                            qCmd.Parameters.AddWithValue("@QuestionType", q.QuestionType ?? "Multiple Choice");
                            qCmd.Parameters.AddWithValue("@QuestionText", q.QuestionText);
                            qCmd.Parameters.AddWithValue("@OptionA", q.OptionA ?? "");
                            qCmd.Parameters.AddWithValue("@OptionB", q.OptionB ?? "");
                            qCmd.Parameters.AddWithValue("@OptionC", q.OptionC ?? "");
                            qCmd.Parameters.AddWithValue("@OptionD", q.OptionD ?? "");
                            qCmd.Parameters.AddWithValue("@CorrectAnswer", q.CorrectAnswer ?? "");
                            qCmd.Parameters.AddWithValue("@CorrectTextAnswer", q.CorrectTextAnswer ?? "");
                            qCmd.Parameters.AddWithValue("@EnumerationAnswers", q.EnumerationAnswers ?? "");
                            qCmd.Parameters.AddWithValue("@MatchingPairsJson", q.MatchingPairsJson ?? "");
                            qCmd.Parameters.AddWithValue("@ImagePath", string.IsNullOrEmpty(q.ImagePath) ? (object)DBNull.Value : q.ImagePath);
                            qCmd.Parameters.AddWithValue("@AudioPath", string.IsNullOrEmpty(q.AudioPath) ? (object)DBNull.Value : q.AudioPath);
                            qCmd.ExecuteNonQuery();
                        }
                    }
                }

                txtFormQuizTitle.Text = "";
                txtFormOpenDate.Text = "";
                txtFormCloseDate.Text = "";
                txtFormTimeLimit.Text = "";
                txtFormInstructions.Text = "";
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
                var txtShortAnswer = (TextBox)e.Item.FindControl("txtShortAnswer");
                var txtEssayAnswer = (TextBox)e.Item.FindControl("txtEssayAnswer");

                if (q == null) return;

                string type = string.IsNullOrEmpty(q.QuestionType) ? "Multiple Choice" : q.QuestionType;

                if (type == "Multiple Choice")
                {
                    if (rblOptions != null)
                    {
                        rblOptions.Visible = true;
                        rblOptions.Items.Clear();
                        if (!string.IsNullOrWhiteSpace(q.OptionA)) rblOptions.Items.Add(new ListItem(" A: " + q.OptionA, "A"));
                        if (!string.IsNullOrWhiteSpace(q.OptionB)) rblOptions.Items.Add(new ListItem(" B: " + q.OptionB, "B"));
                        if (!string.IsNullOrWhiteSpace(q.OptionC) && !q.OptionC.Equals("Option C", StringComparison.OrdinalIgnoreCase)) rblOptions.Items.Add(new ListItem(" C: " + q.OptionC, "C"));
                        if (!string.IsNullOrWhiteSpace(q.OptionD) && !q.OptionD.Equals("Option D", StringComparison.OrdinalIgnoreCase)) rblOptions.Items.Add(new ListItem(" D: " + q.OptionD, "D"));
                    }
                }
                else if (type == "TrueOrFalse")
                {
                    if (rblOptions != null)
                    {
                        rblOptions.Visible = true;
                        rblOptions.Items.Clear();
                        rblOptions.Items.Add(new ListItem(" True", "True"));
                        rblOptions.Items.Add(new ListItem(" False", "False"));
                    }
                }
                else if (type == "Identification" || type == "FillInBlank" || type == "Enumeration" || type == "Matching")
                {
                    if (txtShortAnswer != null) txtShortAnswer.Visible = true;
                }
                else if (type == "Essay")
                {
                    if (txtEssayAnswer != null) txtEssayAnswer.Visible = true;
                }

                var phAudio = (PlaceHolder)e.Item.FindControl("phQuizAudio");
                var litAudio = (Literal)e.Item.FindControl("litQuizAudio");
                if (phAudio != null && !string.IsNullOrEmpty(q.AudioPath))
                {
                    string audioSrc = GetFileUrl(q.AudioPath);
                    phAudio.Visible = true;
                    if (litAudio != null)
                        litAudio.Text = string.Format("<audio controls style=\"width:100%;\"><source src=\"{0}\" />Your browser does not support the audio element.</audio>", audioSrc);
                }

                var phImage = (PlaceHolder)e.Item.FindControl("phQuizImage");
                var imgCtrl = (Image)e.Item.FindControl("imgQuizQuestion");
                if (phImage != null && !string.IsNullOrEmpty(q.ImagePath))
                {
                    phImage.Visible = true;
                    if (imgCtrl != null)
                        imgCtrl.ImageUrl = GetFileUrl(q.ImagePath);
                }
            }
        }

        protected void rptTeacherPreviewQuestions_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var q = (QuestionModel)e.Item.DataItem;
                if (q == null) return;

                var phAudio = (PlaceHolder)e.Item.FindControl("phTeacherAudio");
                var litAudio = (Literal)e.Item.FindControl("litTeacherAudio");
                if (phAudio != null && !string.IsNullOrEmpty(q.AudioPath))
                {
                    string audioSrc = GetFileUrl(q.AudioPath);
                    phAudio.Visible = true;
                    if (litAudio != null)
                        litAudio.Text = string.Format("<audio controls style=\"flex:1;height:36px;\"><source src=\"{0}\" />Your browser does not support the audio element.</audio>", audioSrc);
                }

                var phImage = (PlaceHolder)e.Item.FindControl("phTeacherImage");
                var imgCtrl = (Image)e.Item.FindControl("imgTeacherQuestion");
                if (phImage != null && !string.IsNullOrEmpty(q.ImagePath))
                {
                    phImage.Visible = true;
                    if (imgCtrl != null)
                        imgCtrl.ImageUrl = GetFileUrl(q.ImagePath);
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
                var q = activeQuiz.Questions[i];

                string type = string.IsNullOrEmpty(q.QuestionType) ? "Multiple Choice" : q.QuestionType;
                string selected = "";
                string correctKey = q.CorrectAnswer;
                bool isCorrect = false;

                if (type == "Multiple Choice" || type == "TrueOrFalse")
                {
                    var rbl = (RadioButtonList)item.FindControl("rblOptions");
                    selected = rbl != null ? rbl.SelectedValue : "";
                    if (string.IsNullOrEmpty(selected) && rbl != null)
                    {
                        string postedKey = rbl.UniqueID;
                        if (!string.IsNullOrEmpty(postedKey) && Request.Form[postedKey] != null)
                        {
                            selected = Request.Form[postedKey];
                        }
                    }
                    isCorrect = selected.Equals(correctKey, StringComparison.OrdinalIgnoreCase);
                }
                else if (type == "Identification" || type == "FillInBlank")
                {
                    var txt = (TextBox)item.FindControl("txtShortAnswer");
                    selected = txt != null ? txt.Text.Trim() : "";
                    correctKey = q.CorrectTextAnswer;
                    isCorrect = selected.Equals(correctKey, StringComparison.OrdinalIgnoreCase);
                }
                else if (type == "Enumeration")
                {
                    var txt = (TextBox)item.FindControl("txtShortAnswer");
                    selected = txt != null ? txt.Text.Trim() : "";
                    correctKey = q.EnumerationAnswers;

                    var allowedAnswers = (correctKey ?? "").Split(',').Select(a => a.Trim().ToLower()).ToList();
                    isCorrect = allowedAnswers.Contains(selected.ToLower());
                }
                else if (type == "Matching")
                {
                    var txt = (TextBox)item.FindControl("txtShortAnswer");
                    selected = txt != null ? txt.Text.Trim() : "";
                    correctKey = q.MatchingPairsJson;
                    isCorrect = false; // Flagged for teacher inspection or structured JSON matching
                }
                else if (type == "Essay")
                {
                    var txt = (TextBox)item.FindControl("txtEssayAnswer");
                    selected = txt != null ? txt.Text.Trim() : "";
                    correctKey = "Requires Manual Teacher Grading";
                    isCorrect = false;
                }

                if (string.IsNullOrEmpty(selected)) selected = "Not Answered";
                if (isCorrect) correctCount++;

                resultList.Add(new QuestionResultModel
                {
                    QuestionText = q.QuestionText,
                    SelectedAnswer = selected,
                    CorrectAnswer = correctKey,
                    IsCorrect = isCorrect
                });
            }

            double pct = totalQuestions > 0 ? ((double)correctCount / totalQuestions) * 100 : 0;
            lblQuizScore.Text = correctCount + " / " + totalQuestions;
            lblQuizPercentage.Text = Math.Round(pct, 1) + "%";

            int studentId = Session["LMS_StudentID"] != null ? Convert.ToInt32(Session["LMS_StudentID"]) : (Session["UserID"] != null ? Convert.ToInt32(Session["UserID"]) : 1);
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string saveQuizSubSql = @"
                    INSERT INTO dbo.QuizSubmissions (QuizID, StudentID, Score, TotalQuestions, SubmittedDate)
                    VALUES (@QuizID, @StudentID, @Score, @TotalQuestions, GETDATE())";

                using (SqlCommand qCmd = new SqlCommand(saveQuizSubSql, conn))
                {
                    qCmd.Parameters.AddWithValue("@QuizID", activeQuizId);
                    qCmd.Parameters.AddWithValue("@StudentID", studentId);
                    qCmd.Parameters.AddWithValue("@Score", correctCount);
                    qCmd.Parameters.AddWithValue("@TotalQuestions", totalQuestions);

                    conn.Open();
                    qCmd.ExecuteNonQuery();
                }
            }

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

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT ModuleID, UnitTitle, LessonCount, FocusArea FROM dbo.Modules WHERE CourseID = @CourseID ORDER BY ModuleID ASC";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseID", CurrentCourseID);
                    conn.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
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
                }
            }

            rptModules.DataSource = list;
            rptModules.DataBind();
        }

        protected void rptModules_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var phTeacherActions = (PlaceHolder)e.Item.FindControl("phTeacherModuleActions");
                if (phTeacherActions != null)
                {
                    phTeacherActions.Visible = !IsStudentView();
                }
            }
        }

        public string GetContentTypeIcon(string contentType)
        {
            if (string.IsNullOrEmpty(contentType)) return "description";
            switch (contentType.Trim().ToLower())
            {
                case "video": return "play_circle_outline";
                case "document": return "description";
                case "reading": return "menu_book";
                case "image": return "image";
                case "quiz": return "assignment_turned_in";
                case "assignment": return "assignment";
                default: return "article";
            }
        }

        protected void rptModules_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int moduleId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "SelectModule")
            {
                hfActiveModuleID.Value = moduleId.ToString();
                LoadModuleDetails(moduleId);
            }
            else if (e.CommandName == "EditModule")
            {
                if (IsStudentView()) return;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "SELECT ModuleID, UnitTitle, FocusArea FROM dbo.Modules WHERE ModuleID = @ModuleID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@ModuleID", moduleId);
                        conn.Open();
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
                            if (dr.Read())
                            {
                                hfEditModuleID.Value = dr["ModuleID"].ToString();
                                txtEditUnitTitle.Text = dr["UnitTitle"].ToString();
                                txtEditFocusArea.Text = dr["FocusArea"].ToString();
                            }
                        }
                    }
                }
                ScriptManager.RegisterStartupScript(this, GetType(), "OpenEditModuleModal", "openModal('editModuleModal');", true);
            }
            else if (e.CommandName == "DeleteModule")
            {
                if (IsStudentView()) return;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    string delLessonsSql = "DELETE FROM dbo.Lessons WHERE ModuleID = @ModuleID";
                    using (SqlCommand delLessonsCmd = new SqlCommand(delLessonsSql, conn))
                    {
                        delLessonsCmd.Parameters.AddWithValue("@ModuleID", moduleId);
                        delLessonsCmd.ExecuteNonQuery();
                    }

                    string delModSql = "DELETE FROM dbo.Modules WHERE ModuleID = @ModuleID";
                    using (SqlCommand delModCmd = new SqlCommand(delModSql, conn))
                    {
                        delModCmd.Parameters.AddWithValue("@ModuleID", moduleId);
                        delModCmd.ExecuteNonQuery();
                    }
                }

                BindModules();
            }
        }

        protected void btnUpdateModule_Click(object sender, EventArgs e)
        {
            if (IsStudentView()) return;

            if (!string.IsNullOrEmpty(hfEditModuleID.Value) && !string.IsNullOrEmpty(txtEditUnitTitle.Text.Trim()))
            {
                int moduleId = Convert.ToInt32(hfEditModuleID.Value);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "UPDATE dbo.Modules SET UnitTitle = @UnitTitle, FocusArea = @FocusArea WHERE ModuleID = @ModuleID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@UnitTitle", txtEditUnitTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@FocusArea", txtEditFocusArea.Text.Trim());
                        cmd.Parameters.AddWithValue("@ModuleID", moduleId);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                BindModules();
                ScriptManager.RegisterStartupScript(this, GetType(), "CloseEditModuleModal", "closeModal('editModuleModal');", true);
            }
        }

        private void LoadModuleDetails(int moduleId)
        {
            int currentStudentId = Session["LMS_StudentID"] != null ? Convert.ToInt32(Session["LMS_StudentID"]) : (Session["UserID"] != null ? Convert.ToInt32(Session["UserID"]) : 1);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string modSql = "SELECT UnitTitle, FocusArea FROM dbo.Modules WHERE ModuleID = @ModuleID";
                using (SqlCommand modCmd = new SqlCommand(modSql, conn))
                {
                    modCmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    using (SqlDataReader dr = modCmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            lblActiveUnitTitle.Text = dr["UnitTitle"].ToString();
                            lblActiveUnitFocus.Text = dr["FocusArea"].ToString();
                        }
                    }
                }

                var rawLessons = new List<dynamic>();
                string lessonSql = @"SELECT LessonID, LessonTitle, ContentType, ContentDetails, ISNULL(SequenceOrder, LessonID) AS SequenceOrder 
                                     FROM dbo.Lessons 
                                     WHERE ModuleID = @ModuleID 
                                     ORDER BY SequenceOrder ASC, LessonID ASC";

                using (SqlCommand lessonCmd = new SqlCommand(lessonSql, conn))
                {
                    lessonCmd.Parameters.AddWithValue("@ModuleID", moduleId);
                    using (SqlDataReader lDr = lessonCmd.ExecuteReader())
                    {
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
                    }
                }

                HashSet<int> completedLessonIds = new HashSet<int>();
                string checkSql = @"SELECT lc.LessonID FROM dbo.LessonCompletions lc
                                    INNER JOIN dbo.Lessons l ON lc.LessonID = l.LessonID
                                    WHERE lc.StudentID = @StudentID AND l.ModuleID = @ModuleID";
                using (SqlCommand checkCmd = new SqlCommand(checkSql, conn))
                {
                    checkCmd.Parameters.AddWithValue("@StudentID", currentStudentId);
                    checkCmd.Parameters.AddWithValue("@ModuleID", moduleId);

                    using (SqlDataReader cDr = checkCmd.ExecuteReader())
                    {
                        while (cDr.Read())
                        {
                            completedLessonIds.Add(Convert.ToInt32(cDr["LessonID"]));
                        }
                    }
                }

                var lessonsWithProgression = new List<dynamic>();
                bool previousLessonCompleted = true;

                foreach (var lesson in rawLessons)
                {
                    bool isCompleted = completedLessonIds.Contains((int)lesson.LessonID);
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
                int studentId = Session["LMS_StudentID"] != null ? Convert.ToInt32(Session["LMS_StudentID"]) : (Session["UserID"] != null ? Convert.ToInt32(Session["UserID"]) : 1);

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = @"IF NOT EXISTS (SELECT 1 FROM dbo.LessonCompletions WHERE StudentID = @StudentID AND LessonID = @LessonID)
                                   BEGIN
                                       INSERT INTO dbo.LessonCompletions (StudentID, LessonID) VALUES (@StudentID, @LessonID);
                                   END";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        cmd.Parameters.AddWithValue("@LessonID", lessonId);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
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

                    string getPathSql = "SELECT ContentDetails FROM dbo.Lessons WHERE LessonID = @LessonID";
                    using (SqlCommand getCmd = new SqlCommand(getPathSql, conn))
                    {
                        getCmd.Parameters.AddWithValue("@LessonID", lessonId);
                        object pathObj = getCmd.ExecuteScalar();
                        if (pathObj != null && pathObj.ToString().StartsWith("~/Uploads/"))
                        {
                            LogFileAudit(pathObj.ToString(), "DELETED", "Lesson");
                        }
                    }

                    string deleteSql = "DELETE FROM dbo.Lessons WHERE LessonID = @LessonID";
                    using (SqlCommand cmd = new SqlCommand(deleteSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@LessonID", lessonId);
                        cmd.ExecuteNonQuery();
                    }

                    string updateSql = "UPDATE dbo.Modules SET LessonCount = CASE WHEN LessonCount > 0 THEN LessonCount - 1 ELSE 0 END WHERE ModuleID = @ModuleID";
                    using (SqlCommand updateCmd = new SqlCommand(updateSql, conn))
                    {
                        updateCmd.Parameters.AddWithValue("@ModuleID", moduleId);
                        updateCmd.ExecuteNonQuery();
                    }
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
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@LessonID", lessonId);
                        conn.Open();
                        using (SqlDataReader dr = cmd.ExecuteReader())
                        {
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
                        string originalFileName = Path.GetFileName(fileEditContentUpload.FileName);
                        string fileNameWithoutExt = Path.GetFileNameWithoutExtension(originalFileName);
                        string fileExtension = Path.GetExtension(originalFileName);

                        string uniqueFileName = Guid.NewGuid().ToString("N").Substring(0, 8) + "_" + fileNameWithoutExt + fileExtension;

                        string moduleTitle = GetModuleTitleById(moduleId);
                        string relativeUploadDir = GetTargetUploadDirectory(moduleTitle, "Lessons");
                        string uploadFolder = Server.MapPath(relativeUploadDir);

                        string savePath = Path.Combine(uploadFolder, uniqueFileName);
                        fileEditContentUpload.SaveAs(savePath);

                        contentDetails = relativeUploadDir + uniqueFileName;
                        LogFileAudit(contentDetails, "UPLOADED", "Lesson");
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Trace.TraceError("File Upload Error: " + ex.Message);
                        ScriptManager.RegisterStartupScript(this, GetType(), "UploadError", "alert('An error occurred during file upload.');", true);
                        return;
                    }
                }

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "UPDATE dbo.Lessons SET LessonTitle = @LessonTitle, ContentType = @ContentType, ContentDetails = @ContentDetails WHERE LessonID = @LessonID";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@LessonTitle", txtEditLessonTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@ContentType", ddlEditContentType.SelectedValue);
                        cmd.Parameters.AddWithValue("@ContentDetails", string.IsNullOrEmpty(contentDetails) ? "No details provided" : contentDetails);
                        cmd.Parameters.AddWithValue("@LessonID", lessonId);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
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
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "INSERT INTO dbo.Modules (CourseID, UnitTitle, LessonCount, FocusArea) VALUES (@CourseID, @UnitTitle, @LessonCount, @FocusArea)";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", CurrentCourseID);
                        cmd.Parameters.AddWithValue("@UnitTitle", txtUnitTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@LessonCount", string.IsNullOrEmpty(txtLessonCount.Text) ? 0 : Convert.ToInt32(txtLessonCount.Text.Trim()));
                        cmd.Parameters.AddWithValue("@FocusArea", string.IsNullOrEmpty(txtFocusArea.Text) ? "General Practice" : txtFocusArea.Text.Trim());

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
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
                        string originalFileName = Path.GetFileName(fileContentUpload.FileName);
                        string fileNameWithoutExt = Path.GetFileNameWithoutExtension(originalFileName);
                        string fileExtension = Path.GetExtension(originalFileName);

                        string uniqueFileName = Guid.NewGuid().ToString("N").Substring(0, 8) + "_" + fileNameWithoutExt + fileExtension;

                        string moduleTitle = GetModuleTitleById(moduleId);
                        string relativeUploadDir = GetTargetUploadDirectory(moduleTitle, "Lessons");
                        string uploadFolder = Server.MapPath(relativeUploadDir);

                        string savePath = Path.Combine(uploadFolder, uniqueFileName);
                        fileContentUpload.SaveAs(savePath);

                        contentDetails = relativeUploadDir + uniqueFileName;
                        LogFileAudit(contentDetails, "UPLOADED", "Lesson");
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Trace.TraceError("File Upload Error: " + ex.Message);
                        ScriptManager.RegisterStartupScript(this, GetType(), "UploadError", "alert('An error occurred during file upload.');", true);
                        return;
                    }
                }

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "INSERT INTO dbo.Lessons (ModuleID, LessonTitle, ContentType, ContentDetails) VALUES (@ModuleID, @LessonTitle, @ContentType, @ContentDetails)";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@ModuleID", moduleId);
                        cmd.Parameters.AddWithValue("@LessonTitle", txtLessonTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@ContentType", ddlContentType.SelectedValue);
                        cmd.Parameters.AddWithValue("@ContentDetails", string.IsNullOrEmpty(contentDetails) ? "No details provided" : contentDetails);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }

                    string updateSql = "UPDATE dbo.Modules SET LessonCount = LessonCount + 1 WHERE ModuleID = @ModuleID";
                    using (SqlCommand updateCmd = new SqlCommand(updateSql, conn))
                    {
                        updateCmd.Parameters.AddWithValue("@ModuleID", moduleId);
                        updateCmd.ExecuteNonQuery();
                    }
                }

                txtLessonTitle.Text = "";
                txtContentDetails.Text = "";

                LoadModuleDetails(moduleId);
                ScriptManager.RegisterStartupScript(this, GetType(), "CloseLessonModal", "closeModal('addLessonModal');", true);
            }
        }

        // ==========================================
        // 4. ASSIGNMENTS & TEACHER GRADING
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
                               WHERE CourseID = @CourseID
                               ORDER BY AssignmentID DESC";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseID", CurrentCourseID);
                    conn.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
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
            int assignmentId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "ViewAssignment")
            {
                OpenAssignmentDetailView(assignmentId);
            }
            else if (e.CommandName == "EditAssignment")
            {
                if (IsStudentView()) return;
                PopulateEditAssignmentModal(assignmentId);
            }
            else if (e.CommandName == "DeleteAssignment")
            {
                if (IsStudentView()) return;
                DeleteAssignmentRecord(assignmentId);
            }
        }

        private void PopulateEditAssignmentModal(int assignmentId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT AssignmentID, AssignmentName, OpenDate, CloseDate, MaxPoints, Instructions FROM dbo.Assignments WHERE AssignmentID = @ID";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@ID", assignmentId);
                    conn.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            hfEditAssignmentID.Value = dr["AssignmentID"].ToString();
                            txtEditAssignmentTitle.Text = dr["AssignmentName"].ToString();

                            if (dr["OpenDate"] != DBNull.Value)
                                txtEditAssignmentStartDate.Text = Convert.ToDateTime(dr["OpenDate"]).ToString("yyyy-MM-ddTHH:mm");

                            if (dr["CloseDate"] != DBNull.Value)
                                txtEditAssignmentDueDate.Text = Convert.ToDateTime(dr["CloseDate"]).ToString("yyyy-MM-ddTHH:mm");

                            txtEditMaxPoints.Text = dr["MaxPoints"] != DBNull.Value ? dr["MaxPoints"].ToString() : "100";
                            txtEditAssignmentInstructions.Text = dr["Instructions"].ToString();
                        }
                    }
                }
            }
            ScriptManager.RegisterStartupScript(this, GetType(), "OpenEditAssignmentModal", "openModal('editAssignmentModal');", true);
        }

        protected void btnUpdateAssignment_Click(object sender, EventArgs e)
        {
            if (IsStudentView())
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "UnauthorizedAlert", "alert('Access Denied.');", true);
                return;
            }

            if (!string.IsNullOrEmpty(hfEditAssignmentID.Value) && !string.IsNullOrEmpty(txtEditAssignmentTitle.Text.Trim()))
            {
                int assignmentId = Convert.ToInt32(hfEditAssignmentID.Value);
                string title = txtEditAssignmentTitle.Text.Trim();
                DateTime openDate = string.IsNullOrEmpty(txtEditAssignmentStartDate.Text) ? DateTime.Now : Convert.ToDateTime(txtEditAssignmentStartDate.Text);
                DateTime dueDate = string.IsNullOrEmpty(txtEditAssignmentDueDate.Text) ? DateTime.Now.AddDays(7) : Convert.ToDateTime(txtEditAssignmentDueDate.Text);
                int maxPoints = string.IsNullOrEmpty(txtEditMaxPoints.Text) ? 100 : Convert.ToInt32(txtEditMaxPoints.Text);
                string instructions = txtEditAssignmentInstructions.Text.Trim();

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"UPDATE dbo.Assignments 
                                     SET AssignmentName = @Title, OpenDate = @OpenDate, CloseDate = @DueDate, MaxPoints = @MaxPoints, Instructions = @Instructions 
                                     WHERE AssignmentID = @ID";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Title", title);
                        cmd.Parameters.AddWithValue("@OpenDate", openDate);
                        cmd.Parameters.AddWithValue("@DueDate", dueDate);
                        cmd.Parameters.AddWithValue("@MaxPoints", maxPoints);
                        cmd.Parameters.AddWithValue("@Instructions", instructions);
                        cmd.Parameters.AddWithValue("@ID", assignmentId);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "CloseEditAssignment", "closeModal('editAssignmentModal');", true);
                BindAssignments();
            }
        }

        private void DeleteAssignmentRecord(int assignmentId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string getSubFilesSql = "SELECT FilePath FROM dbo.AssignmentSubmissions WHERE AssignmentID = @ID";
                using (SqlCommand getCmd = new SqlCommand(getSubFilesSql, conn))
                {
                    getCmd.Parameters.AddWithValue("@ID", assignmentId);
                    using (SqlDataReader sDr = getCmd.ExecuteReader())
                    {
                        while (sDr.Read())
                        {
                            string fPath = sDr["FilePath"].ToString();
                            if (!string.IsNullOrEmpty(fPath))
                            {
                                LogFileAudit(fPath, "DELETED", "Submission");
                            }
                        }
                    }
                }

                using (SqlCommand cmdSub = new SqlCommand("DELETE FROM dbo.AssignmentSubmissions WHERE AssignmentID = @ID", conn))
                {
                    cmdSub.Parameters.AddWithValue("@ID", assignmentId);
                    cmdSub.ExecuteNonQuery();
                }

                using (SqlCommand cmd = new SqlCommand("DELETE FROM dbo.Assignments WHERE AssignmentID = @ID", conn))
                {
                    cmd.Parameters.AddWithValue("@ID", assignmentId);
                    cmd.ExecuteNonQuery();
                }
            }

            BindAssignments();
        }

        private void OpenAssignmentDetailView(int assignmentId)
        {
            hfActiveAssignmentID.Value = assignmentId.ToString();
            bool isClosed = false;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT AssignmentName, OpenDate, CloseDate, MaxPoints, Instructions FROM dbo.Assignments WHERE AssignmentID = @ID";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@ID", assignmentId);
                    conn.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        if (dr.Read())
                        {
                            lblDetailAssignmentTitle.Text = dr["AssignmentName"].ToString();
                            lblDetailOpenDate.Text = dr["OpenDate"] != DBNull.Value ? Convert.ToDateTime(dr["OpenDate"]).ToString("MMM dd, yyyy hh:mm tt") : "N/A";
                            lblDetailDueDate.Text = dr["CloseDate"] != DBNull.Value ? Convert.ToDateTime(dr["CloseDate"]).ToString("MMM dd, yyyy hh:mm tt") : "N/A";
                            lblDetailMaxPoints.Text = dr["MaxPoints"].ToString();
                            lblDetailInstructions.Text = string.IsNullOrEmpty(dr["Instructions"].ToString()) ? "No specific instructions provided." : dr["Instructions"].ToString();

                            if (dr["CloseDate"] != DBNull.Value)
                            {
                                DateTime closeDate = Convert.ToDateTime(dr["CloseDate"]);
                                if (DateTime.Now > closeDate)
                                {
                                    isClosed = true;
                                }
                            }
                        }
                    }
                }
            }

            rptAssignments.Visible = false;
            btnOpenAssignmentModal.Visible = false;
            pnlAssignmentDetail.Visible = true;

            if (IsStudentView())
            {
                pnlStudentSubmission.Visible = true;
                pnlTeacherSubmissions.Visible = false;

                bool hasSubmitted = false;
                bool isGraded = false;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string studentSubSql = @"SELECT TOP 1 Grade, Feedback 
                                             FROM dbo.AssignmentSubmissions 
                                             WHERE AssignmentID = @AssignmentID AND StudentName = @StudentName 
                                             ORDER BY SubmissionID DESC";

                    using (SqlCommand subCmd = new SqlCommand(studentSubSql, conn))
                    {
                        subCmd.Parameters.AddWithValue("@AssignmentID", assignmentId);
                        subCmd.Parameters.AddWithValue("@StudentName", "Student User");

                        conn.Open();
                        using (SqlDataReader subDr = subCmd.ExecuteReader())
                        {
                            if (subDr.Read())
                            {
                                hasSubmitted = true;
                                object gradeVal = subDr["Grade"];
                                object feedbackVal = subDr["Feedback"];

                                if (gradeVal != DBNull.Value && !string.IsNullOrEmpty(gradeVal.ToString()))
                                {
                                    isGraded = true;
                                    lblStudentGradeDisplay.Text = $"Grade: {gradeVal} / {lblDetailMaxPoints.Text}";
                                }
                                else
                                {
                                    lblStudentGradeDisplay.Text = "Status: Pending Grading";
                                }

                                if (feedbackVal != DBNull.Value && !string.IsNullOrEmpty(feedbackVal.ToString()))
                                {
                                    lblStudentFeedbackDisplay.Text = feedbackVal.ToString();
                                }
                                else
                                {
                                    lblStudentFeedbackDisplay.Text = "No feedback provided yet.";
                                }
                            }
                            else
                            {
                                lblStudentGradeDisplay.Text = isClosed ? "Status: Closed (No Submission)" : "Status: Not Submitted";
                                lblStudentFeedbackDisplay.Text = isClosed
                                    ? "The deadline for this assignment has passed."
                                    : "Submit your work below to receive a grade and feedback.";
                            }
                        }
                    }
                }

                if (isClosed || isGraded)
                {
                    txtSubmissionNotes.Enabled = false;
                    fileSubmissionUpload.Enabled = false;
                    btnSubmitAssignmentWork.Enabled = false;

                    if (isGraded)
                    {
                        btnSubmitAssignmentWork.Text = "Assignment Graded";
                        btnSubmitAssignmentWork.CssClass = "btn btn-secondary";
                    }
                    else
                    {
                        btnSubmitAssignmentWork.Text = "Assignment Closed";
                        btnSubmitAssignmentWork.CssClass = "btn btn-secondary";
                    }
                }
                else
                {
                    txtSubmissionNotes.Enabled = true;
                    fileSubmissionUpload.Enabled = true;
                    btnSubmitAssignmentWork.Enabled = true;
                    btnSubmitAssignmentWork.Text = hasSubmitted ? "Resubmit Assignment" : "Submit Assignment";
                    btnSubmitAssignmentWork.CssClass = "btn-primary-action";
                }
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
                string sql = "SELECT SubmissionID, StudentName, FORMAT(SubmittedDate, 'MMM dd, yyyy hh:mm tt') AS SubmittedDateFormatted, FilePath, SubmissionText, Grade, Feedback FROM dbo.AssignmentSubmissions WHERE AssignmentID = @ID ORDER BY SubmissionID DESC";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@ID", assignmentId);
                    conn.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            list.Add(new
                            {
                                SubmissionID = Convert.ToInt32(dr["SubmissionID"]),
                                StudentName = dr["StudentName"].ToString(),
                                SubmittedDate = dr["SubmittedDateFormatted"].ToString(),
                                FilePath = dr["FilePath"].ToString(),
                                SubmissionText = dr["SubmissionText"].ToString(),
                                Grade = dr["Grade"] != DBNull.Value ? dr["Grade"].ToString() : "",
                                Feedback = dr["Feedback"] != DBNull.Value ? dr["Feedback"].ToString() : ""
                            });
                        }
                    }
                }
            }
            rptSubmissions.DataSource = list;
            rptSubmissions.DataBind();
        }

        protected void rptSubmissions_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (IsStudentView()) return;

            int submissionId = Convert.ToInt32(e.CommandArgument);
            int activeAssignmentId = Convert.ToInt32(hfActiveAssignmentID.Value);

            if (e.CommandName == "GradeSubmission")
            {
                TextBox txtGrade = (TextBox)e.Item.FindControl("txtGrade");
                TextBox txtFeedback = (TextBox)e.Item.FindControl("txtFeedback");

                if (txtGrade != null && double.TryParse(txtGrade.Text.Trim(), out double grade))
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string sql = "UPDATE dbo.AssignmentSubmissions SET Grade = @Grade, Feedback = @Feedback WHERE SubmissionID = @ID";
                        using (SqlCommand cmd = new SqlCommand(sql, conn))
                        {
                            cmd.Parameters.AddWithValue("@Grade", grade);
                            cmd.Parameters.AddWithValue("@Feedback", txtFeedback != null ? txtFeedback.Text.Trim() : "");
                            cmd.Parameters.AddWithValue("@ID", submissionId);
                            conn.Open();
                            cmd.ExecuteNonQuery();
                        }
                    }

                    BindSubmissions(activeAssignmentId);
                    ScriptManager.RegisterStartupScript(this, GetType(), "GradeSaved", "alert('Grade and feedback saved successfully!');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "GradeError", "alert('Please enter a valid numeric grade.');", true);
                }
            }
            else if (e.CommandName == "DeleteSubmission")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    string getFileSql = "SELECT FilePath FROM dbo.AssignmentSubmissions WHERE SubmissionID = @ID";
                    object filePathObj;
                    using (SqlCommand getFileCmd = new SqlCommand(getFileSql, conn))
                    {
                        getFileCmd.Parameters.AddWithValue("@ID", submissionId);
                        filePathObj = getFileCmd.ExecuteScalar();
                    }

                    if (filePathObj != null && filePathObj != DBNull.Value)
                    {
                        string relativePath = filePathObj.ToString();
                        if (!string.IsNullOrEmpty(relativePath))
                        {
                            LogFileAudit(relativePath, "DELETED", "Submission");
                        }
                    }

                    string delSql = "DELETE FROM dbo.AssignmentSubmissions WHERE SubmissionID = @ID";
                    using (SqlCommand delCmd = new SqlCommand(delSql, conn))
                    {
                        delCmd.Parameters.AddWithValue("@ID", submissionId);
                        delCmd.ExecuteNonQuery();
                    }
                }

                BindSubmissions(activeAssignmentId);
                ScriptManager.RegisterStartupScript(this, GetType(), "SubmissionDeleted", "alert('Submission deleted successfully.');", true);
            }
        }

        protected void btnSubmitAssignmentWork_Click(object sender, EventArgs e)
        {
            int assignmentId = Convert.ToInt32(hfActiveAssignmentID.Value);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string checkSql = "SELECT CloseDate FROM dbo.Assignments WHERE AssignmentID = @ID";
                using (SqlCommand checkCmd = new SqlCommand(checkSql, conn))
                {
                    checkCmd.Parameters.AddWithValue("@ID", assignmentId);
                    object closeDateObj = checkCmd.ExecuteScalar();

                    if (closeDateObj != null && closeDateObj != DBNull.Value)
                    {
                        DateTime closeDate = Convert.ToDateTime(closeDateObj);
                        if (DateTime.Now > closeDate)
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "ClosedError", "alert('This assignment is closed. Submissions are no longer accepted.');", true);
                            OpenAssignmentDetailView(assignmentId);
                            return;
                        }
                    }
                }

                string gradeCheckSql = "SELECT TOP 1 Grade FROM dbo.AssignmentSubmissions WHERE AssignmentID = @ID AND StudentName = @StudentName ORDER BY SubmissionID DESC";
                using (SqlCommand gradeCmd = new SqlCommand(gradeCheckSql, conn))
                {
                    gradeCmd.Parameters.AddWithValue("@ID", assignmentId);
                    gradeCmd.Parameters.AddWithValue("@StudentName", "Student User");
                    object gradeObj = gradeCmd.ExecuteScalar();

                    if (gradeObj != null && gradeObj != DBNull.Value && !string.IsNullOrEmpty(gradeObj.ToString()))
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "GradedError", "alert('This assignment has already been graded and cannot be resubmitted.');", true);
                        OpenAssignmentDetailView(assignmentId);
                        return;
                    }
                }
            }

            string filePath = "";

            if (fileSubmissionUpload.HasFile)
            {
                string extension = Path.GetExtension(fileSubmissionUpload.FileName).ToLower();
                string[] allowedExtensions = { ".pdf", ".docx", ".zip", ".mp4", ".webm", ".mov", ".avi", ".mkv" };

                if (Array.IndexOf(allowedExtensions, extension) < 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "FormatError",
                        "alert('Invalid file format. Allowed formats: PDF, DOCX, ZIP, MP4, WEBM, MOV, AVI, MKV.');", true);
                    return;
                }

                if (fileSubmissionUpload.PostedFile.ContentLength > 104857600)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "SizeError",
                        "alert('File size exceeds the maximum allowed 100MB limit.');", true);
                    return;
                }

                string relativeUploadDir = GetTargetUploadDirectory("Assignments", "Submissions");
                string folder = Server.MapPath(relativeUploadDir);

                string originalFileName = Path.GetFileName(fileSubmissionUpload.FileName);
                string fileNameWithoutExt = Path.GetFileNameWithoutExtension(originalFileName);
                string fileExt = Path.GetExtension(originalFileName);

                string uniqueFile = Guid.NewGuid().ToString("N").Substring(0, 8) + "_" + fileNameWithoutExt + fileExt;
                fileSubmissionUpload.SaveAs(Path.Combine(folder, uniqueFile));

                filePath = relativeUploadDir + uniqueFile;
                LogFileAudit(filePath, "UPLOADED", "Submission");
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "INSERT INTO dbo.AssignmentSubmissions (AssignmentID, StudentName, SubmissionText, FilePath) VALUES (@AID, @Student, @Text, @File)";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@AID", assignmentId);
                    cmd.Parameters.AddWithValue("@Student", "Student User");
                    cmd.Parameters.AddWithValue("@Text", txtSubmissionNotes.Text.Trim());
                    cmd.Parameters.AddWithValue("@File", filePath);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            txtSubmissionNotes.Text = "";
            ScriptManager.RegisterStartupScript(this, GetType(), "SubmitSuccess", "alert('Assignment submitted successfully!');", true);
            OpenAssignmentDetailView(assignmentId);
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
                                   (CourseID, AssignmentName, CourseName, OpenDate, CloseDate, MaxPoints, Instructions, ManualGrading, Completed)
                                   VALUES 
                                   (@CourseID, @AssignmentName, @CourseName, @OpenDate, @CloseDate, @MaxPoints, @Instructions, @ManualGrading, @Completed)";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", CurrentCourseID);
                        cmd.Parameters.AddWithValue("@AssignmentName", txtAssignmentTitle.Text.Trim());
                        cmd.Parameters.AddWithValue("@CourseName", lblCourseTitle.Text);
                        cmd.Parameters.AddWithValue("@OpenDate", openDt);
                        cmd.Parameters.AddWithValue("@CloseDate", closeDt);
                        cmd.Parameters.AddWithValue("@MaxPoints", maxPts);
                        cmd.Parameters.AddWithValue("@Instructions", txtAssignmentInstructions.Text.Trim());
                        cmd.Parameters.AddWithValue("@ManualGrading", false);
                        cmd.Parameters.AddWithValue("@Completed", false);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                txtAssignmentTitle.Text = "";
                txtAssignmentStartDate.Text = "";
                txtAssignmentDueDate.Text = "";
                txtAssignmentInstructions.Text = "";

                BindAssignments();
                ScriptManager.RegisterStartupScript(this, GetType(), "CloseAssignmentModal", "closeModal('assignmentModal');", true);
            }
        }

        // ==========================================
        // 5. GRADEBOOK BINDING & EXPORT LOGIC
        // ==========================================
        private void BindGradebook()
        {
            var list = new List<GradebookEntryModel>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
            SELECT 
                s.StudentID,
                s.StudentName,
                ISNULL((SELECT AVG(CAST(sub.Grade AS FLOAT) / NULLIF(a.MaxPoints, 0) * 100) 
                        FROM dbo.AssignmentSubmissions sub 
                        INNER JOIN dbo.Assignments a ON sub.AssignmentID = a.AssignmentID 
                        WHERE sub.StudentName = s.StudentName AND a.CourseID = @CourseID), 0) AS AssignmentAvg,
                ISNULL((SELECT AVG(CAST(qs.Score AS FLOAT) / NULLIF(qs.TotalQuestions, 0) * 100) 
                        FROM dbo.QuizSubmissions qs 
                        INNER JOIN dbo.Quizzes qz ON qs.QuizID = qz.QuizID 
                        WHERE qs.StudentID = s.StudentID AND qz.CourseID = @CourseID), 0) AS QuizAvg
            FROM dbo.Students s
            INNER JOIN dbo.CourseEnrollments e ON s.StudentID = e.StudentID
            WHERE e.CourseID = @CourseID AND e.EnrollmentStatus = 'Active'";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@CourseID", CurrentCourseID);
                    conn.Open();
                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            double assignAvg = Convert.ToDouble(dr["AssignmentAvg"]);
                            double quizAvg = Convert.ToDouble(dr["QuizAvg"]);
                            double overall = Math.Round((assignAvg * 0.5) + (quizAvg * 0.5), 1);

                            list.Add(new GradebookEntryModel
                            {
                                StudentID = Convert.ToInt32(dr["StudentID"]),
                                StudentName = dr["StudentName"].ToString(),
                                AssignmentAverage = Math.Round(assignAvg, 1),
                                QuizAverage = Math.Round(quizAvg, 1),
                                OverallGrade = overall
                            });
                        }
                    }
                }
            }

            gvGradebook.DataSource = list;
            gvGradebook.DataBind();
        }

        protected void btnExportGradebook_Click(object sender, EventArgs e)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=Course_Gradebook.csv");
            Response.Charset = "";
            Response.ContentType = "text/csv";

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.AppendLine("Student Name,Quiz Avg (%),Assignment Avg (%),Overall Grade (%)");

            foreach (GridViewRow row in gvGradebook.Rows)
            {
                if (row.RowType == DataControlRowType.DataRow)
                {
                    string studentName = row.Cells[0].Text.Replace("\"", "\"\"");
                    sb.AppendLine($"\"{studentName}\",{row.Cells[1].Text},{row.Cells[2].Text},{row.Cells[3].Text}");
                }
            }

            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }

        // ==========================================
        // 6. USER MANAGEMENT & SELF-STUDY ENROLLMENT
        // ==========================================
        private void BindUserManagement()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string pendingSql = @"
                    SELECT e.EnrollmentID, s.StudentName, e.RequestedDate 
                    FROM dbo.CourseEnrollments e
                    INNER JOIN dbo.Students s ON e.StudentID = s.StudentID
                    WHERE e.CourseID = @CourseID AND e.EnrollmentStatus = 'Pending'";
                using (SqlCommand pendingCmd = new SqlCommand(pendingSql, conn))
                {
                    pendingCmd.Parameters.AddWithValue("@CourseID", CurrentCourseID);
                    using (SqlDataAdapter da1 = new SqlDataAdapter(pendingCmd))
                    {
                        DataTable dtPending = new DataTable();
                        da1.Fill(dtPending);
                        gvPendingEnrollments.DataSource = dtPending;
                        gvPendingEnrollments.DataBind();
                    }
                }

                string activeSql = @"
                    SELECT s.StudentName, e.ApprovedDate 
                    FROM dbo.CourseEnrollments e
                    INNER JOIN dbo.Students s ON e.StudentID = s.StudentID
                    WHERE e.CourseID = @CourseID AND e.EnrollmentStatus = 'Active'";
                using (SqlCommand activeCmd = new SqlCommand(activeSql, conn))
                {
                    activeCmd.Parameters.AddWithValue("@CourseID", CurrentCourseID);
                    using (SqlDataAdapter da2 = new SqlDataAdapter(activeCmd))
                    {
                        DataTable dtActive = new DataTable();
                        da2.Fill(dtActive);
                        gvActiveStudents.DataSource = dtActive;
                        gvActiveStudents.DataBind();
                    }
                }

                string ddlSql = @"
                    SELECT StudentID, StudentName FROM dbo.Students 
                    WHERE StudentID NOT IN (
                        SELECT StudentID FROM dbo.CourseEnrollments 
                        WHERE CourseID = @CourseID AND EnrollmentStatus = 'Active'
                    )";
                using (SqlCommand ddlCmd = new SqlCommand(ddlSql, conn))
                {
                    ddlCmd.Parameters.AddWithValue("@CourseID", CurrentCourseID);
                    using (SqlDataReader dr = ddlCmd.ExecuteReader())
                    {
                        ddlAvailableStudents.DataSource = dr;
                        ddlAvailableStudents.DataTextField = "StudentName";
                        ddlAvailableStudents.DataValueField = "StudentID";
                        ddlAvailableStudents.DataBind();
                    }
                }
            }
        }

        protected void gvPendingEnrollments_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (IsStudentView()) return;

            int enrollmentId = Convert.ToInt32(e.CommandArgument);
            string newStatus = (e.CommandName == "ApproveStudent") ? "Active" : "Rejected";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "UPDATE dbo.CourseEnrollments SET EnrollmentStatus = @Status, ApprovedDate = GETDATE() WHERE EnrollmentID = @ID";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Status", newStatus);
                    cmd.Parameters.AddWithValue("@ID", enrollmentId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            BindUserManagement();
            BindGradebook();
        }

        protected void btnDirectEnroll_Click(object sender, EventArgs e)
        {
            if (IsStudentView()) return;

            if (ddlAvailableStudents.SelectedValue != null && int.TryParse(ddlAvailableStudents.SelectedValue, out int studentId))
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = @"
                        IF EXISTS (SELECT 1 FROM dbo.CourseEnrollments WHERE CourseID = @CourseID AND StudentID = @StudentID)
                            UPDATE dbo.CourseEnrollments SET EnrollmentStatus = 'Active', ApprovedDate = GETDATE() WHERE CourseID = @CourseID AND StudentID = @StudentID;
                        ELSE
                            INSERT INTO dbo.CourseEnrollments (CourseID, StudentID, EnrollmentStatus, ApprovedDate) VALUES (@CourseID, @StudentID, 'Active', GETDATE());";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@CourseID", CurrentCourseID);
                        cmd.Parameters.AddWithValue("@StudentID", studentId);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                BindUserManagement();
                ScriptManager.RegisterStartupScript(this, GetType(), "CloseAddStudentModal", "closeModal('addStudentModal');", true);
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