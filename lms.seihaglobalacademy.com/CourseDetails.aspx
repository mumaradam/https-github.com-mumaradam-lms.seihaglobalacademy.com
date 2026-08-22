<%@ Page Title="Course Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CourseDetails.aspx.cs" Inherits="lms.seihaglobalacademy.com.CourseDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="course-layout-wrapper">
        <!-- Left Sub-Navigation Panel -->
        <div class="course-nav-panel">
            <div class="course-nav-header">
                <asp:Label ID="lblCourseTitle" runat="server" Text="Loading Course..."></asp:Label>
            </div>
            <ul class="course-menu-list">
                <li id="liAnnouncements" runat="server" class="active">
                    <asp:LinkButton ID="btnNavAnnouncements" runat="server" OnClick="btnNav_Click" CommandArgument="Announcements">
                        <i class="material-icons-outlined">campaign</i> Announcements
                    </asp:LinkButton>
                </li>
                <li id="liQuizzes" runat="server">
                    <asp:LinkButton ID="btnNavQuizzes" runat="server" OnClick="btnNav_Click" CommandArgument="Quizzes">
                        <i class="material-icons-outlined">assignment_turned_in</i> Tests & Quizzes
                    </asp:LinkButton>
                </li>
                <li id="liModules" runat="server">
                    <asp:LinkButton ID="btnNavModules" runat="server" OnClick="btnNav_Click" CommandArgument="Modules">
                        <i class="material-icons-outlined">view_module</i> Modules & Units
                    </asp:LinkButton>
                </li>
                <li id="liAssignments" runat="server">
                    <asp:LinkButton ID="btnNavAssignments" runat="server" OnClick="btnNav_Click" CommandArgument="Assignments">
                        <i class="material-icons-outlined">assignment</i> Assignments
                    </asp:LinkButton>
                </li>
                <li id="liGradebook" runat="server">
                    <asp:LinkButton ID="btnNavGradebook" runat="server" OnClick="btnNav_Click" CommandArgument="Gradebook">
                        <i class="material-icons-outlined">grade</i> Gradebook
                    </asp:LinkButton>
                </li>
                <li id="liUserManagement" runat="server" class="teacher-only-control">
                    <asp:LinkButton ID="btnNavUserManagement" runat="server" OnClick="btnNav_Click" CommandArgument="UserManagement">
                        <i class="material-icons-outlined">people</i> User Management
                    </asp:LinkButton>
                </li>
            </ul>
        </div>

        <!-- Right Main Workspace Content Panel -->
        <div class="course-content-panel">
            
            <!-- SECTION 1: ANNOUNCEMENTS PANEL -->
            <asp:Panel ID="pnlAnnouncements" runat="server" Visible="true">
                <div class="workspace-header">
                    <div class="workspace-title">Announcements</div>
                    <asp:PlaceHolder ID="phNewAnnouncementBtn" runat="server">
                        <asp:LinkButton ID="btnOpenAnnouncementModal" runat="server" CssClass="btn-primary-action teacher-only-control" OnClientClick="openModal('announcementModal'); return false;">
                            <i class="material-icons-outlined" style="font-size: 18px;">add</i> New Announcement
                        </asp:LinkButton>
                    </asp:PlaceHolder>
                </div>

                <asp:Repeater ID="rptAnnouncements" runat="server" OnItemCommand="rptAnnouncements_ItemCommand" OnItemDataBound="rptAnnouncements_ItemDataBound">
                    <ItemTemplate>
                        <div class="feed-card" style="position: relative;">
                            <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                                <div>
                                    <div class="feed-card-title">📌 <%# Eval("Title") %></div>
                                    <div class="feed-card-meta">Posted by <%# Eval("Author") %> • <%# Eval("PostDate") %></div>
                                </div>
                                <asp:PlaceHolder ID="phTeacherAnnouncementActions" runat="server">
                                    <div class="teacher-only-control" style="display: flex; gap: 8px;">
                                        <asp:LinkButton ID="btnEditAnnouncement" runat="server" CommandName="EditAnnouncement" CommandArgument='<%# Eval("AnnouncementID") %>' Style="color: #4f46e5; text-decoration: none;" ToolTip="Edit Post">
                                            <i class="material-icons-outlined" style="font-size: 20px;">edit</i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnDeleteAnnouncement" runat="server" CommandName="DeleteAnnouncement" CommandArgument='<%# Eval("AnnouncementID") %>' Style="color: #ef4444; text-decoration: none;" ToolTip="Delete Post" OnClientClick="return confirm('Are you sure you want to delete this announcement?');">
                                            <i class="material-icons-outlined" style="font-size: 20px;">delete</i>
                                        </asp:LinkButton>
                                    </div>
                                </asp:PlaceHolder>
                            </div>
                            <p style="font-size: 13.5px; color: var(--text-light); margin-top: 10px; line-height: 1.5;"><%# Eval("Body") %></p>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </asp:Panel>

            <!-- SECTION 2: TESTS & QUIZZES PANEL -->
            <asp:Panel ID="pnlQuizzes" runat="server" Visible="false">
                <div class="workspace-header">
                    <div class="workspace-title">Tests & Quizzes</div>
                    <asp:LinkButton ID="btnOpenQuizModal" runat="server" CssClass="btn-primary-action teacher-only-control" OnClientClick="openModal('quizFormModal'); return false;">
                        <i class="material-icons-outlined" style="font-size: 18px;">add</i> Create Google Form Quiz
                    </asp:LinkButton>
                </div>

                <asp:Panel ID="pnlQuizList" runat="server">
                    <asp:Repeater ID="rptQuizzes" runat="server" OnItemCommand="rptQuizzes_ItemCommand" OnItemDataBound="rptQuizzes_ItemDataBound">
                        <ItemTemplate>
                            <div class="quiz-item-row">
                                <div>
                                    <div class="quiz-info-title">
                                        <i class="material-icons-outlined" style="font-size: 16px; vertical-align: middle;">assignment</i> 
                                        <%# Eval("Title") %>
                                    </div>
                                    <div class="quiz-info-sub">Due: <%# Eval("DueDate") %> | Time Limit: <%# Eval("TimeLimit") %> mins</div>
                                </div>
                                <div>
                                    <asp:LinkButton ID="btnActionQuiz" runat="server" CommandName="ActionQuiz" CommandArgument='<%# Container.ItemIndex %>' CssClass="btn-primary-action">
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </asp:Panel>

                <asp:Panel ID="pnlTeacherQuizPreview" runat="server" Visible="false" Style="max-width: 680px; margin: 0 auto;">
                    <div style="background: #4f46e5; height: 10px; border-radius: 8px 8px 0 0;"></div>
                    <div class="feed-card" style="border-top: none; border-radius: 0 0 8px 8px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <h2 style="margin: 0 0 4px 0;"><asp:Label ID="lblTeacherPreviewTitle" runat="server"></asp:Label></h2>
                            <span class="badge-status" style="background: #e0e7ff; color: #3730a3;">Teacher Answer Key Preview</span>
                        </div>
                        <asp:Button ID="btnBackFromPreview" runat="server" Text="Back to Quizzes" CssClass="btn-primary-action" OnClick="btnBackToQuizzes_Click" Style="background: #6b7280;" />
                    </div>

                    <asp:Repeater ID="rptTeacherPreviewQuestions" runat="server">
                        <ItemTemplate>
                            <div class="feed-card" style="border-left: 4px solid #4f46e5;">
                                <div style="font-weight: 600; font-size: 15px; margin-bottom: 8px;">
                                    <%# Container.ItemIndex + 1 %>. <%# Eval("QuestionText") %>
                                </div>
                                <div style="font-size: 13px; color: var(--text-muted); display: grid; grid-template-columns: 1fr 1fr; gap: 6px; margin-top: 8px;">
                                    <div>A. <%# Eval("OptionA") %></div>
                                    <div>B. <%# Eval("OptionB") %></div>
                                    <div>C. <%# Eval("OptionC") %></div>
                                    <div>D. <%# Eval("OptionD") %></div>
                                </div>
                                <div style="margin-top: 10px; font-size: 13px; font-weight: 600; color: #059669;">
                                    ✔ Correct Answer Key: Option <%# Eval("CorrectAnswer") %>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </asp:Panel>

                <asp:Panel ID="pnlTakeQuizForm" runat="server" Visible="false" Style="max-width: 680px; margin: 0 auto;">
                    <div style="background: #2563eb; height: 10px; border-radius: 8px 8px 0 0;"></div>
                    <div class="feed-card" style="border-top: none; border-radius: 0 0 8px 8px; margin-bottom: 20px;">
                        <h2 style="margin: 0 0 8px 0;"><asp:Label ID="lblActiveQuizTitle" runat="server"></asp:Label></h2>
                        <div style="color: var(--text-muted); font-size: 13px;">Please complete all questions below and click Submit.</div>
                    </div>

                    <asp:Repeater ID="rptFormQuestions" runat="server" OnItemDataBound="rptFormQuestions_ItemDataBound">
                        <ItemTemplate>
                            <div class="feed-card">
                                <div style="font-weight: 600; font-size: 15px; margin-bottom: 12px;">
                                    <%# Container.ItemIndex + 1 %>. <%# Eval("QuestionText") %> <span style="color: #ef4444;">*</span>
                                </div>

                                <asp:RadioButtonList ID="rblOptions" runat="server" CssClass="form-options-list" Style="margin-left: 8px; font-size: 13.5px; line-height: 1.8;">
                                </asp:RadioButtonList>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 20px;">
                        <asp:Button ID="btnSubmitQuiz" runat="server" Text="Submit Quiz" CssClass="btn-primary-action" OnClick="btnSubmitQuiz_Click" Style="padding: 10px 24px; font-size: 14px;" />
                        <asp:LinkButton ID="btnCancelQuiz" runat="server" OnClick="btnCancelQuiz_Click" Style="color: var(--text-muted); text-decoration: none; font-size: 13.5px;">Cancel</asp:LinkButton>
                    </div>
                </asp:Panel>

                <asp:Panel ID="pnlQuizResults" runat="server" Visible="false" Style="max-width: 680px; margin: 0 auto;">
                    <div style="background: #059669; height: 10px; border-radius: 8px 8px 0 0;"></div>
                    <div class="feed-card" style="border-top: none; border-radius: 0 0 8px 8px; margin-bottom: 20px; text-align: center; padding: 24px;">
                        <i class="material-icons-outlined" style="font-size: 48px; color: #059669; margin-bottom: 8px;">check_circle</i>
                        <h2 style="margin: 0 0 8px 0;">Quiz Submitted Successfully!</h2>
                        <div style="font-size: 24px; font-weight: 700; color: var(--text-light); margin: 12px 0;">
                            Your Score: <asp:Label ID="lblQuizScore" runat="server" Text="0 / 0"></asp:Label> 
                            (<asp:Label ID="lblQuizPercentage" runat="server" Text="0%"></asp:Label>)
                        </div>
                        <p style="color: var(--text-muted); font-size: 13.5px; margin: 0;">Your responses have been auto-graded and saved to your course record.</p>
                    </div>

                    <asp:Repeater ID="rptResultBreakdown" runat="server">
                        <ItemTemplate>
                            <div class="feed-card" style='<%# (bool)Eval("IsCorrect") ? "border-left: 4px solid #059669;" : "border-left: 4px solid #ef4444;" %>'>
                                <div style="font-weight: 600; font-size: 14.5px; margin-bottom: 8px;">
                                    <%# Container.ItemIndex + 1 %>. <%# Eval("QuestionText") %>
                                </div>
                                <div style="font-size: 13px; color: var(--text-muted);">
                                    Your Answer: <strong><%# Eval("SelectedAnswer") %></strong> 
                                    <%# (bool)Eval("IsCorrect") ? "<span style='color:#059669; font-weight:600;'> (Correct)</span>" : "<span style='color:#ef4444; font-weight:600;'> (Incorrect - Correct: " + Eval("CorrectAnswer") + ")</span>" %>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>

                    <div style="text-align: center; margin-top: 20px;">
                        <asp:Button ID="btnBackToQuizzes" runat="server" Text="Return to Tests & Quizzes" CssClass="btn-primary-action" OnClick="btnBackToQuizzes_Click" Style="padding: 10px 20px;" />
                    </div>
                </asp:Panel>
            </asp:Panel>

            <!-- SECTION 3: MODULES & UNITS PANEL -->
            <asp:Panel ID="pnlModules" runat="server" Visible="false">
                <div class="workspace-header">
                    <div class="workspace-title">Modules & Units</div>
                </div>
                <div class="modules-grid">
                    <div class="unit-card">
                        <div class="unit-card-banner unit-1">Unit 1: Hello</div>
                        <div class="unit-card-body">6 Lessons • Speaking & Practice</div>
                    </div>
                    <div class="unit-card">
                        <div class="unit-card-banner unit-2">Unit 2: Vacations</div>
                        <div class="unit-card-body">6 Lessons • Listening & Comprehension</div>
                    </div>
                    <div class="unit-card">
                        <div class="unit-card-banner unit-3">Unit 3: Friends</div>
                        <div class="unit-card-body">6 Lessons • Vocabulary & Grammar</div>
                    </div>
                    <div class="unit-card">
                        <div class="unit-card-banner unit-4">Unit 4: Cities</div>
                        <div class="unit-card-body">6 Lessons • Reading & Writing</div>
                    </div>
                </div>
            </asp:Panel>

            <!-- SECTION 4: ASSIGNMENTS PANEL -->
            <asp:Panel ID="pnlAssignments" runat="server" Visible="false">
                <div class="workspace-header">
                    <div class="workspace-title">Assignments</div>
                    <asp:LinkButton ID="btnOpenAssignmentModal" runat="server" CssClass="btn-primary-action teacher-only-control" OnClientClick="openModal('assignmentModal'); return false;">
                        <i class="material-icons-outlined" style="font-size: 18px;">add</i> Create Assignment
                    </asp:LinkButton>
                </div>
                <asp:Repeater ID="rptAssignments" runat="server">
                    <ItemTemplate>
                        <div class="quiz-item-row">
                            <div>
                                <div class="quiz-info-title"><i class="material-icons-outlined" style="font-size: 16px; vertical-align: middle;">assignment</i> <%# Eval("AssignmentName") %></div>
                                <div class="quiz-info-sub">Due: <%# Eval("EndDateTime") %> | Grading: <%# Eval("ManualGrading") %></div>
                            </div>
                            <div><span class="badge-status"><%# Eval("Completed") %></span></div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </asp:Panel>

            <!-- SECTION 5: GRADEBOOK PANEL -->
            <asp:Panel ID="pnlGradebook" runat="server" Visible="false">
                <div class="workspace-header">
                    <div class="workspace-title">Gradebook</div>
                </div>
                <table class="lms-table">
                    <thead><tr><th>Student Name</th><th>Unit 1 Quiz</th><th>Midterm Speaking</th><th>Total Grade</th></tr></thead>
                    <tbody>
                        <tr><td>Kazumi Sakai</td><td>48 / 50</td><td>92 / 100</td><td>93.3%</td></tr>
                        <tr><td>Mary Ann Saito</td><td>45 / 50</td><td>88 / 100</td><td>88.6%</td></tr>
                    </tbody>
                </table>
            </asp:Panel>

            <!-- SECTION 6: USER MANAGEMENT PANEL -->
            <asp:Panel ID="pnlUserManagement" runat="server" Visible="false">
                <div class="workspace-header">
                    <div class="workspace-title">User Management</div>
                </div>
                <table class="lms-table">
                    <thead><tr><th>Name</th><th>Role</th><th>Created On</th><th>Status</th></tr></thead>
                    <tbody>
                        <tr><td>Kazumi Sakai</td><td>Student</td><td>07/Jun/2026</td><td><span class="badge-status">Active</span></td></tr>
                        <tr><td>Mary Ann Saito</td><td>Student</td><td>08/May/2026</td><td><span class="badge-status">Active</span></td></tr>
                        <tr><td>SENPI Seiha</td><td>Instructor</td><td>14/Feb/2022</td><td><span class="badge-status">Instructor</span></td></tr>
                    </tbody>
                </table>
            </asp:Panel>

        </div>
    </div>

    <!-- CREATE ANNOUNCEMENT MODAL -->
    <div id="announcementModal" class="lms-modal-overlay">
        <div class="lms-modal-card">
            <div class="lms-modal-header">
                <h3>Post Announcement</h3>
                <button type="button" class="modal-close-btn" onclick="closeModal('announcementModal');">&times;</button>
            </div>
            <div class="lms-modal-body">
                <div class="form-group">
                    <label>Title <span class="required-star">*</span></label>
                    <asp:TextBox ID="txtAnnouncementTitle" runat="server" CssClass="form-control" placeholder="e.g. Welcome to Unit 1!"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Message <span class="required-star">*</span></label>
                    <asp:TextBox ID="txtAnnouncementBody" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" placeholder="Write your announcement here..."></asp:TextBox>
                </div>
            </div>
            <div class="lms-modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal('announcementModal');">Cancel</button>
                <asp:Button ID="btnPostAnnouncement" runat="server" Text="Post Announcement" CssClass="btn-submit" OnClick="btnPostAnnouncement_Click" />
            </div>
        </div>
    </div>

    <!-- EDIT ANNOUNCEMENT MODAL -->
    <div id="editAnnouncementModal" class="lms-modal-overlay">
        <div class="lms-modal-card">
            <div class="lms-modal-header">
                <h3>Edit Announcement</h3>
                <button type="button" class="modal-close-btn" onclick="closeModal('editAnnouncementModal');">&times;</button>
            </div>
            <div class="lms-modal-body">
                <asp:HiddenField ID="hfEditAnnouncementID" runat="server" />
                <div class="form-group">
                    <label>Title <span class="required-star">*</span></label>
                    <asp:TextBox ID="txtEditAnnouncementTitle" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Message <span class="required-star">*</span></label>
                    <asp:TextBox ID="txtEditAnnouncementBody" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="lms-modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal('editAnnouncementModal');">Cancel</button>
                <asp:Button ID="btnUpdateAnnouncement" runat="server" Text="Update Post" CssClass="btn-submit" OnClick="btnUpdateAnnouncement_Click" />
            </div>
        </div>
    </div>

    <!-- DYNAMIC GOOGLE FORM STYLE QUIZ MODAL -->
    <div id="quizFormModal" class="lms-modal-overlay">
        <div class="lms-modal-card" style="max-width: 680px; max-height: 85vh; overflow-y: auto;">
            <div class="lms-modal-header">
                <h3>Create Google Form-style Quiz</h3>
                <button type="button" class="modal-close-btn" onclick="closeModal('quizFormModal');">&times;</button>
            </div>
            <div class="lms-modal-body">
                <div class="form-group">
                    <label>Quiz Title <span class="required-star">*</span></label>
                    <asp:TextBox ID="txtFormQuizTitle" runat="server" CssClass="form-control" placeholder="e.g. Unit 1 Vocabulary Test"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Time Limit (Minutes)</label>
                    <asp:TextBox ID="txtFormTimeLimit" runat="server" CssClass="form-control" placeholder="20"></asp:TextBox>
                </div>

                <hr style="border: 0; border-top: 1px solid #e5e7eb; margin: 20px 0;" />

                <div id="questionsContainer"></div>

                <button type="button" class="btn-primary-action" onclick="addQuestionCard();" style="background: #f3f4f6; color: #1f2937; border: 1px dashed #9ca3af; width: 100%; justify-content: center; margin-top: 10px;">
                    <i class="material-icons-outlined" style="font-size: 18px;">add_circle_outline</i> Add Question
                </button>

                <asp:HiddenField ID="hfQuizJsonData" runat="server" ClientIDMode="Static" />
            </div>
            <div class="lms-modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal('quizFormModal');">Cancel</button>
                <asp:Button ID="btnSaveFormQuiz" runat="server" Text="Publish Quiz" CssClass="btn-submit" OnClientClick="return prepareQuizJson();" OnClick="btnSaveFormQuiz_Click" />
            </div>
        </div>
    </div>

    <!-- ASSIGNMENT MODAL -->
    <div id="assignmentModal" class="lms-modal-overlay">
        <div class="lms-modal-card">
            <div class="lms-modal-header">
                <h3>Create Assignment</h3>
                <button type="button" class="modal-close-btn" onclick="closeModal('assignmentModal');">&times;</button>
            </div>
            <div class="lms-modal-body">
                <div class="form-group">
                    <label>Assignment Title <span class="required-star">*</span></label>
                    <asp:TextBox ID="txtAssignmentTitle" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>End Date & Time</label>
                    <asp:TextBox ID="txtAssignmentDueDate" runat="server" CssClass="form-control" placeholder="Aug 30, 2026 11:59 PM"></asp:TextBox>
                </div>
            </div>
            <div class="lms-modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal('assignmentModal');">Cancel</button>
                <asp:Button ID="btnSaveAssignment" runat="server" Text="Create Assignment" CssClass="btn-submit" OnClick="btnSaveAssignment_Click" />
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function openModal(id) {
            var modal = document.getElementById(id);
            if (modal) modal.classList.add("show");
        }
        function closeModal(id) {
            var modal = document.getElementById(id);
            if (modal) modal.classList.remove("show");
        }

        let questionCounter = 0;

        function addQuestionCard() {
            questionCounter++;
            const container = document.getElementById('questionsContainer');
            if (!container) return;

            const card = document.createElement('div');
            card.className = 'feed-card question-builder-card';
            card.id = 'qCard_' + questionCounter;

            card.innerHTML = `
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                    <strong>Question ${questionCounter}</strong>
                    <button type="button" onclick="removeQuestionCard(${questionCounter})" style="background: none; border: none; color: #ef4444; cursor: pointer; font-weight: 600;">Remove</button>
                </div>
                <div class="form-group" style="margin-bottom: 10px;">
                    <input type="text" class="form-control q-text" placeholder="Question prompt..." />
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-bottom: 10px;">
                    <input type="text" class="form-control opt-a" placeholder="Option A" />
                    <input type="text" class="form-control opt-b" placeholder="Option B" />
                    <input type="text" class="form-control opt-c" placeholder="Option C" />
                    <input type="text" class="form-control opt-d" placeholder="Option D" />
                </div>
                <div style="font-size: 13px;">
                    <label><strong>Correct Choice:</strong></label>
                    <select class="form-control correct-opt" style="width: 120px; display: inline-block; margin-left: 8px;">
                        <option value="A">Option A</option>
                        <option value="B">Option B</option>
                        <option value="C">Option C</option>
                        <option value="D">Option D</option>
                    </select>
                </div>
            `;
            container.appendChild(card);
        }

        function removeQuestionCard(id) {
            const card = document.getElementById('qCard_' + id);
            if (card) card.remove();
        }

        function prepareQuizJson() {
            const cards = document.querySelectorAll('.question-builder-card');
            const questions = [];

            cards.forEach(card => {
                const text = card.querySelector('.q-text').value.trim();
                const optA = card.querySelector('.opt-a').value.trim();
                const optB = card.querySelector('.opt-b').value.trim();
                const optC = card.querySelector('.opt-c').value.trim();
                const optD = card.querySelector('.opt-d').value.trim();
                const correct = card.querySelector('.correct-opt').value;

                if (text && optA) {
                    questions.push({
                        QuestionText: text,
                        OptionA: optA,
                        OptionB: optB || "Option B",
                        OptionC: optC || "Option C",
                        OptionD: optD || "Option D",
                        CorrectAnswer: correct
                    });
                }
            });

            if (questions.length === 0) {
                alert("Please add at least one complete question.");
                return false;
            }

            document.getElementById('hfQuizJsonData').value = JSON.stringify(questions);
            return true;
        }

        document.addEventListener('DOMContentLoaded', function () {
            const container = document.getElementById('questionsContainer');
            if (container && container.children.length === 0) {
                addQuestionCard();
            }
        });
    </script>

</asp:Content>