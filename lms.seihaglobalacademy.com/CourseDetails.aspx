<%@ Page Title="Course Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CourseDetails.aspx.cs" Inherits="lms.seihaglobalacademy.com.CourseDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Google Material Icons CDN -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet" />
    <style type="text/css">
        /* Mode Indicator Banner */
        .mode-banner-student {
            background-color: #fef3c7;
            color: #92400e;
            border: 1px solid #fcd34d;
            padding: 10px 16px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 13.5px;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .mode-banner-teacher {
            background-color: #e0e7ff;
            color: #3730a3;
            border: 1px solid #c7d2fe;
            padding: 10px 16px;
            border-radius: 8px;
            font-weight: 600;
            font-size: 13.5px;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Responsive Table & Grading Fixes */
        .lms-table-container {
            width: 100%;
            overflow-x: auto;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            margin-top: 12px;
        }

        .lms-table {
            width: 100%;
            border-collapse: collapse;
            table-layout: auto;
            background: #ffffff;
        }

        .lms-table th {
            background-color: #f9fafb;
            color: #374151;
            font-weight: 600;
            font-size: 13px;
            padding: 10px 12px;
            border-bottom: 1px solid #e5e7eb;
            text-align: left;
        }

        .lms-table td {
            padding: 10px 12px;
            border-bottom: 1px solid #f3f4f6;
            vertical-align: middle;
            font-size: 13.5px;
            color: #1f2937;
        }

        /* Specific Column Widths */
        .col-student  { width: 14%; min-width: 110px; }
        .col-date     { width: 12%; min-width: 100px; }
        .col-file     { width: 22%; min-width: 220px; }
        .col-notes    { width: 16%; min-width: 130px; }
        .col-grade    { width: 10%; min-width: 80px; }
        .col-feedback { width: 16%; min-width: 130px; }
        .col-actions  { width: 10%; min-width: 110px; text-align: center; }

        /* Form Inputs Inside Table */
        .input-grade {
            width: 100% !important;
            max-width: 70px;
            text-align: center;
            padding: 6px !important;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 13px;
        }

        .input-feedback {
            width: 100% !important;
            padding: 6px 8px !important;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 13px;
        }

        /* Button Action Group Layout */
        .action-btn-group {
            display: flex;
            gap: 6px;
            justify-content: center;
            align-items: center;
        }

        .btn-table-save {
            background-color: #059669;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            transition: background 0.15s;
        }

        .btn-table-save:hover {
            background-color: #047857;
        }

        .btn-table-delete {
            background-color: #ef4444;
            color: white;
            border: none;
            padding: 6px 12px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 12px;
            font-weight: 600;
            transition: background 0.15s;
        }

        .btn-table-delete:hover {
            background-color: #dc2626;
        }

        /* Floating Actions for Module Cards */
        .module-card-actions {
            position: absolute;
            top: 10px;
            right: 10px;
            display: flex;
            gap: 6px;
            background: rgba(0, 0, 0, 0.4);
            padding: 4px 8px;
            border-radius: 6px;
            z-index: 10;
        }

        .module-card-actions a {
            color: #ffffff !important;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            cursor: pointer;
        }

        .modules-grid-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }

        .module-card-item {
            width: 250px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            overflow: hidden;
            margin-bottom: 20px;
            position: relative;
        }

        /* DARK MODE OVERRIDES FOR ALL MODALS */
        .dark .lms-modal-card,
        .dark-mode .lms-modal-card,
        [data-theme='dark'] .lms-modal-card,
        body[class*='dark'] .lms-modal-card {
            background-color: #1e293b !important;
            border: 1px solid #334155 !important;
            color: #ffffff !important;
        }

        .dark .lms-modal-card h3, .dark .lms-modal-card label,
        .dark-mode .lms-modal-card h3, .dark-mode .lms-modal-card label,
        [data-theme='dark'] .lms-modal-card h3, [data-theme='dark'] .lms-modal-card label,
        body[class*='dark'] .lms-modal-card h3, body[class*='dark'] .lms-modal-card label {
            color: #ffffff !important;
        }

        .dark .lms-modal-card .form-control,
        .dark-mode .lms-modal-card .form-control,
        [data-theme='dark'] .lms-modal-card .form-control,
        body[class*='dark'] .lms-modal-card .form-control {
            background-color: #0f172a !important;
            border: 1px solid #334155 !important;
            color: #ffffff !important;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- Mode Indicator Banner -->
    <asp:Panel ID="pnlModeBanner" runat="server" CssClass="mode-banner-teacher">
        <i class="material-icons-outlined" style="font-size: 20px;">info</i>
        <asp:Label ID="lblModeStatus" runat="server" Text="TEACHER MODE — Full administrative access active."></asp:Label>
    </asp:Panel>

    <div id="divMainWrapper" runat="server" class="course-layout-wrapper">
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
                    <asp:LinkButton ID="btnOpenQuizModal" runat="server" CssClass="btn-primary-action teacher-only-control" OnClientClick="resetQuizModal(); openModal('quizFormModal'); return false;">
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
                                    <div class="quiz-info-sub">
                                        Open: <%# Eval("OpenDate") %> | Close: <%# Eval("CloseDate") %> | Time Limit: <%# Eval("TimeLimit") %> mins
                                    </div>
                                </div>
                                <div style="display: flex; align-items: center; gap: 10px;">
                                    <asp:LinkButton ID="btnActionQuiz" runat="server" CommandName="ActionQuiz" CommandArgument='<%# Eval("QuizID") %>' CssClass="btn-primary-action">
                                    </asp:LinkButton>

                                    <asp:PlaceHolder ID="phTeacherQuizActions" runat="server">
                                        <div class="teacher-only-control" style="display: flex; gap: 6px; margin-left: 8px;">
                                            <asp:LinkButton ID="btnEditQuiz" runat="server" CommandName="EditQuiz" CommandArgument='<%# Eval("QuizID") %>' Style="color: #60a5fa; text-decoration: none;" ToolTip="Edit Quiz">
                                                <i class="material-icons-outlined" style="font-size: 18px;">edit</i>
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="btnDeleteQuiz" runat="server" CommandName="DeleteQuiz" CommandArgument='<%# Eval("QuizID") %>' Style="color: #ef4444; text-decoration: none;" ToolTip="Delete Quiz" OnClientClick="return confirm('Are you sure you want to delete this quiz?');">
                                                <i class="material-icons-outlined" style="font-size: 18px;">delete</i>
                                            </asp:LinkButton>
                                        </div>
                                    </asp:PlaceHolder>
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
                    <div class="feed-card" style="border-top: none; border-radius: 0 0 8px 8px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center;">
                        <div>
                            <h2 style="margin: 0 0 8px 0;"><asp:Label ID="lblActiveQuizTitle" runat="server"></asp:Label></h2>
                            <div style="color: var(--text-muted); font-size: 13px;">Please complete all questions below and click Submit.</div>
                        </div>
                        <div style="background: #1e293b; color: #f8fafc; padding: 10px 16px; border-radius: 8px; text-align: center; border: 1px solid #334155;">
                            <div style="font-size: 11px; text-transform: uppercase; color: #94a3b8; font-weight: 600;">Time Remaining</div>
                            <div id="quizTimer" style="font-size: 20px; font-weight: 700; color: #38bdf8;">00:00</div>
                        </div>
                    </div>

                    <asp:HiddenField ID="hfQuizTimeLimitMinutes" runat="server" ClientIDMode="Static" />

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
                        <asp:Button ID="btnSubmitQuiz" runat="server" ClientIDMode="Static" Text="Submit Quiz" CssClass="btn-primary-action" OnClick="btnSubmitQuiz_Click" Style="padding: 10px 24px; font-size: 14px;" />
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
                    <div style="display: flex; gap: 10px;">
                        <asp:Button ID="btnBackToModulesGrid" runat="server" Text="← Back to All Units" CssClass="btn-primary-action" OnClick="btnBackToModulesGrid_Click" Visible="false" Style="background: #6b7280;" />
                        <asp:PlaceHolder ID="phNewModuleBtn" runat="server">
                            <asp:LinkButton ID="btnOpenModuleModal" runat="server" CssClass="btn-primary-action teacher-only-control" OnClientClick="openModal('moduleModal'); return false;">
                                <i class="material-icons-outlined" style="font-size: 18px;">add</i> New Module
                            </asp:LinkButton>
                        </asp:PlaceHolder>
                    </div>
                </div>

                <!-- VIEW 1: MODULE CARDS GRID -->
                <asp:Panel ID="pnlModulesGrid" runat="server" Visible="true">
                    <div class="modules-grid-container">
                        <asp:Repeater ID="rptModules" runat="server" OnItemCommand="rptModules_ItemCommand" OnItemDataBound="rptModules_ItemDataBound">
                            <ItemTemplate>
                                <div class="module-card-item">
                                    
                                    <!-- Floating Edit / Delete Actions (Teacher Only) -->
                                    <asp:PlaceHolder ID="phTeacherModuleActions" runat="server">
                                        <div class="module-card-actions teacher-only-control">
                                            <asp:LinkButton ID="btnEditModule" runat="server" CommandName="EditModule" CommandArgument='<%# Eval("ModuleID") %>' ToolTip="Edit Module">
                                                <i class="material-icons-outlined" style="font-size: 18px;">edit</i>
                                            </asp:LinkButton>
                                            <asp:LinkButton ID="btnDeleteModule" runat="server" CommandName="DeleteModule" CommandArgument='<%# Eval("ModuleID") %>' OnClientClick="return confirm('Deleting this module will also remove all its content items. Continue?');" ToolTip="Delete Module">
                                                <i class="material-icons-outlined" style="font-size: 18px;">delete</i>
                                            </asp:LinkButton>
                                        </div>
                                    </asp:PlaceHolder>

                                    <!-- Main Module Card Content -->
                                    <asp:LinkButton ID="btnSelectModule" runat="server" CommandName="SelectModule" CommandArgument='<%# Eval("ModuleID") %>' Style="text-decoration: none; color: inherit; display: block;">
                                        <div style="height: 100px; background-color: #2563eb; padding: 16px; box-sizing: border-box; display: flex; align-items: flex-end;">
                                            <h3 style="color: #ffffff; margin: 0; font-size: 18px; font-weight: 700;"><%# Eval("UnitTitle") %></h3>
                                        </div>
                                        <div style="padding: 14px 16px;">
                                            <div style="font-size: 13px; color: #6b7280;"><%# Eval("LessonCount") %> Lessons • <%# Eval("FocusArea") %></div>
                                            <div style="font-size: 12px; color: #2563eb; margin-top: 10px; font-weight: 600;">Click to view content →</div>
                                        </div>
                                    </asp:LinkButton>

                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </asp:Panel>

                <!-- VIEW 2: DRILL-DOWN ACCORDION LESSON VIEW -->
                <asp:Panel ID="pnlModuleAccordion" runat="server" Visible="false">
                    <div class="feed-card" style="border-left: 4px solid #2563eb; margin-bottom: 20px;">
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <div>
                                <h2 style="margin: 0 0 6px 0;"><asp:Label ID="lblActiveUnitTitle" runat="server"></asp:Label></h2>
                                <div style="font-size: 13px; color: var(--text-muted);"><asp:Label ID="lblActiveUnitFocus" runat="server"></asp:Label></div>
                            </div>
                            <asp:PlaceHolder ID="phTeacherAddLessonBtn" runat="server">
                                <asp:LinkButton ID="btnOpenLessonModal" runat="server" CssClass="btn-primary-action teacher-only-control" OnClientClick="openModal('addLessonModal'); return false;" Style="font-size: 13px;">
                                    <i class="material-icons-outlined" style="font-size: 16px;">add</i> Add Content Item
                                </asp:LinkButton>
                            </asp:PlaceHolder>
                        </div>
                    </div>

                    <div class="lessons-accordion-list">
                        <asp:Repeater ID="rptLessons" runat="server" OnItemCommand="rptLessons_ItemCommand" OnItemDataBound="rptLessons_ItemDataBound">
                            <ItemTemplate>
                                <div class="feed-card" style='<%# (bool)Eval("IsUnlocked") ? "margin-bottom: 12px; display: flex; align-items: center; justify-content: space-between; background: #ffffff; border: 1px solid #e5e7eb; padding: 14px 16px; border-radius: 8px;" : "margin-bottom: 12px; display: flex; align-items: center; justify-content: space-between; background: #f3f4f6; border: 1px solid #e5e7eb; padding: 14px 16px; border-radius: 8px; opacity: 0.6;" %>'>
                                    
                                    <div style="display: flex; align-items: center; gap: 14px;">
                                        <i class="material-icons-outlined" style='<%# (bool)Eval("IsUnlocked") ? "font-size: 24px; color: #2563eb;" : "font-size: 24px; color: #9ca3af;" %>'>
                                            <%# (bool)Eval("IsUnlocked") ? GetContentTypeIcon(Eval("ContentType").ToString()) : "lock" %>
                                        </i>
                                        <div>
                                            <div style='<%# (bool)Eval("IsUnlocked") ? "font-weight: 600; font-size: 15px; color: #111827;" : "font-weight: 600; font-size: 15px; color: #6b7280;" %>'>
                                                <%# Eval("LessonTitle") %>
                                            </div>
                                            <div style="font-size: 12.5px; color: #6b7280; margin-top: 2px;">
                                                <%# (bool)Eval("IsUnlocked") 
                                                    ? (Eval("ContentDetails").ToString().StartsWith("~/Uploads/") 
                                                        ? "<a href='" + ResolveUrl(Eval("ContentDetails").ToString()) + "' target='_blank' style='color:#2563eb; text-decoration:underline;'>Download Attached File</a>" 
                                                        : Eval("ContentDetails"))
                                                    : "<span style='color: #ef4444;'>Locked — Complete the previous item to unlock</span>" %>
                                            </div>
                                        </div>
                                    </div>

                                    <div style="display: flex; align-items: center; gap: 10px;">
                                        <asp:PlaceHolder ID="phStudentViewActions" runat="server">
                                            <asp:Panel ID="pnlCompletedBadge" runat="server" Visible='<%# (bool)Eval("IsCompleted") %>'>
                                                <span class="badge-status" style="background: #10b981; color: white; padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 600;">Completed</span>
                                            </asp:Panel>

                                            <asp:LinkButton ID="btnMarkComplete" runat="server" 
                                                CommandName="MarkComplete" 
                                                CommandArgument='<%# Eval("LessonID") %>' 
                                                CssClass="btn-primary-action" 
                                                Visible='<%# !(bool)Eval("IsCompleted") && (bool)Eval("IsUnlocked") %>' 
                                                Style="background: #2563eb; color: #ffffff; padding: 6px 14px; text-decoration: none; border-radius: 6px; font-size: 13px; font-weight: 600;">
                                                Mark as Complete
                                            </asp:LinkButton>

                                            <asp:Panel ID="pnlLockedBadge" runat="server" Visible='<%# !(bool)Eval("IsCompleted") && !(bool)Eval("IsUnlocked") %>'>
                                                <span class="badge-status" style="background: #9ca3af; color: white; padding: 6px 12px; border-radius: 6px; font-size: 12px; font-weight: 600;">Locked</span>
                                            </asp:Panel>
                                        </asp:PlaceHolder>

                                        <asp:PlaceHolder ID="phTeacherLessonActions" runat="server">
                                            <div class="teacher-only-control" style="display: flex; gap: 6px; margin-left: 10px;">
                                                <asp:LinkButton ID="btnEditLesson" runat="server" CommandName="EditLesson" CommandArgument='<%# Eval("LessonID") %>' Style="color: #2563eb; text-decoration: none;" ToolTip="Edit Lesson">
                                                    <i class="material-icons-outlined" style="font-size: 20px;">edit</i>
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="btnDeleteLesson" runat="server" CommandName="DeleteLesson" CommandArgument='<%# Eval("LessonID") %>' Style="color: #ef4444; text-decoration: none;" ToolTip="Delete Lesson" OnClientClick="return confirm('Are you sure you want to delete this lesson?');">
                                                    <i class="material-icons-outlined" style="font-size: 20px;">delete</i>
                                                </asp:LinkButton>
                                            </div>
                                        </asp:PlaceHolder>
                                    </div>

                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </asp:Panel>
            </asp:Panel>

            <!-- SECTION 4: ENHANCED ASSIGNMENTS PANEL -->
            <asp:Panel ID="pnlAssignments" runat="server" Visible="false">
                <div class="workspace-header">
                    <div class="workspace-title">Assignments</div>
                    <asp:LinkButton ID="btnOpenAssignmentModal" runat="server" CssClass="btn-primary-action teacher-only-control" OnClientClick="openModal('assignmentModal'); return false;">
                        <i class="material-icons-outlined" style="font-size: 18px;">add</i> Create Assignment
                    </asp:LinkButton>
                </div>

                <asp:Repeater ID="rptAssignments" runat="server" OnItemCommand="rptAssignments_ItemCommand" OnItemDataBound="rptAssignments_ItemDataBound">
                    <ItemTemplate>
                        <div class="quiz-item-row">
                            <div>
                                <div class="quiz-info-title">
                                    <i class="material-icons-outlined" style="font-size: 16px; vertical-align: middle;">assignment</i> 
                                    <%# Eval("AssignmentName") %>
                                </div>
                                <div class="quiz-info-sub">
                                    Open: <%# Eval("OpenDate") %> | Due: <%# Eval("EndDateTime") %> | Points: <%# Eval("MaxPoints") %>
                                </div>
                            </div>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <asp:Label ID="lblAssignmentStatus" runat="server" CssClass="badge-status"></asp:Label>
                                <asp:LinkButton ID="btnViewAssignment" runat="server" CssClass="btn-primary-action" CommandName="ViewAssignment" CommandArgument='<%# Eval("AssignmentID") %>'>
                                    View Details
                                </asp:LinkButton>

                                <!-- Teacher Actions: Edit & Delete -->
                                <asp:PlaceHolder ID="phTeacherAssignmentActions" runat="server">
                                    <div class="teacher-only-control" style="display: flex; gap: 6px; margin-left: 4px;">
                                        <asp:LinkButton ID="btnEditAssignment" runat="server" CommandName="EditAssignment" CommandArgument='<%# Eval("AssignmentID") %>' Style="color: #60a5fa; text-decoration: none;" ToolTip="Edit Assignment">
                                            <i class="material-icons-outlined" style="font-size: 18px;">edit</i>
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnDeleteAssignment" runat="server" CommandName="DeleteAssignment" CommandArgument='<%# Eval("AssignmentID") %>' Style="color: #ef4444; text-decoration: none;" ToolTip="Delete Assignment" OnClientClick="return confirm('Are you sure you want to delete this assignment and all associated student submissions?');">
                                            <i class="material-icons-outlined" style="font-size: 18px;">delete</i>
                                        </asp:LinkButton>
                                    </div>
                                </asp:PlaceHolder>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>

                <!-- ASSIGNMENT DETAIL VIEW PANEL -->
                <asp:Panel ID="pnlAssignmentDetail" runat="server" Visible="false" Style="max-width: 760px; margin: 0 auto;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                        <asp:Button ID="btnBackToAssignments" runat="server" Text="← Back to Assignments" CssClass="btn-primary-action" OnClick="btnBackToAssignments_Click" Style="background: #6b7280;" />
                        <asp:HiddenField ID="hfActiveAssignmentID" runat="server" />
                    </div>

                    <div class="feed-card" style="border-left: 4px solid #2563eb; margin-bottom: 20px;">
                        <h2 style="margin: 0 0 8px 0;"><asp:Label ID="lblDetailAssignmentTitle" runat="server"></asp:Label></h2>
                        <div style="font-size: 13px; color: var(--text-muted); margin-bottom: 12px;">
                            Open: <asp:Label ID="lblDetailOpenDate" runat="server"></asp:Label> | 
                            Due: <asp:Label ID="lblDetailDueDate" runat="server"></asp:Label> | 
                            Max Points: <asp:Label ID="lblDetailMaxPoints" runat="server"></asp:Label>
                        </div>
                        <div style="font-size: 14px; color: var(--text-light); line-height: 1.6; padding-top: 10px; border-top: 1px solid #e5e7eb;">
                            <strong>Instructions:</strong>
                            <p><asp:Label ID="lblDetailInstructions" runat="server"></asp:Label></p>
                        </div>
                    </div>

                    <!-- STUDENT SUBMISSION FORM & GRADE RESULT CARD -->
                    <asp:Panel ID="pnlStudentSubmission" runat="server">
                        <!-- STUDENT GRADE & FEEDBACK DISPLAY -->
                        <asp:Panel ID="pnlStudentFeedbackCard" runat="server" CssClass="feed-card" Style="margin-bottom: 20px; border-left: 4px solid #059669; background: #f0fdf4;">
                            <h3 style="margin: 0 0 10px 0; color: #166534; font-size: 16px; display: flex; align-items: center; gap: 6px;">
                                <i class="material-icons-outlined" style="font-size: 20px;">verified</i> Grade & Teacher Feedback
                            </h3>
                            <div style="font-size: 15px; font-weight: 700; color: #15803d; margin-bottom: 6px;">
                                <asp:Label ID="lblStudentGradeDisplay" runat="server" Text="Status: Not Graded Yet"></asp:Label>
                            </div>
                            <div style="font-size: 13.5px; color: #166534; line-height: 1.5;">
                                <asp:Label ID="lblStudentFeedbackDisplay" runat="server" Text="No feedback provided yet."></asp:Label>
                            </div>
                        </asp:Panel>

                        <!-- STUDENT SUBMISSION FORM -->
                        <div class="feed-card">
                            <h3 style="margin-top: 0;">Submit Your Work</h3>
                            <div class="form-group" style="margin-top: 12px;">
                                <label>Text Response / Notes</label>
                                <asp:TextBox ID="txtSubmissionNotes" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="Write response here..."></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label>Upload File or Video (PDF, DOCX, ZIP, MP4, WEBM, MOV)</label>
                                <asp:FileUpload ID="fileSubmissionUpload" runat="server" CssClass="form-control" Style="padding: 6px;" />
                            </div>
                            <asp:Button ID="btnSubmitAssignmentWork" runat="server" Text="Submit Assignment" CssClass="btn-primary-action" OnClick="btnSubmitAssignmentWork_Click" Style="background: #059669;" />
                        </div>
                    </asp:Panel>

                    <!-- TEACHER SUBMISSIONS VIEW & MANUAL GRADING TABLE WITH VIDEO PLAYER -->
                    <asp:Panel ID="pnlTeacherSubmissions" runat="server" CssClass="feed-card" Visible="false">
                        <h3 style="margin-top: 0; margin-bottom: 12px;">Submitted Student Work</h3>
                        <div class="lms-table-container">
                            <asp:Repeater ID="rptSubmissions" runat="server" OnItemCommand="rptSubmissions_ItemCommand">
                                <HeaderTemplate>
                                    <table class="lms-table">
                                        <thead>
                                            <tr>
                                                <th class="col-student">Student</th>
                                                <th class="col-date">Date</th>
                                                <th class="col-file">Attachment / Video</th>
                                                <th class="col-notes">Notes</th>
                                                <th class="col-grade">Grade</th>
                                                <th class="col-feedback">Feedback</th>
                                                <th class="col-actions">Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr>
                                        <td class="col-student"><strong><%# Eval("StudentName") %></strong></td>
                                        <td class="col-date" style="color: #6b7280; font-size: 12px;"><%# Eval("SubmittedDate") %></td>
                                        <td class="col-file">
                                            <%# !string.IsNullOrEmpty(Convert.ToString(Eval("FilePath"))) ? 
                                                (
                                                    Convert.ToString(Eval("FilePath")).ToLower().EndsWith(".mp4") || 
                                                    Convert.ToString(Eval("FilePath")).ToLower().EndsWith(".webm") || 
                                                    Convert.ToString(Eval("FilePath")).ToLower().EndsWith(".mov") || 
                                                    Convert.ToString(Eval("FilePath")).ToLower().EndsWith(".avi") ||
                                                    Convert.ToString(Eval("FilePath")).ToLower().EndsWith(".mkv") ?
                                                    "<video width='220' height='130' controls controlsList='nodownload' style='border-radius:6px; background:#000; display:block;'><source src='" + ResolveUrl(Eval("FilePath").ToString()) + "'>Your browser does not support HTML5 video.</video>" :
                                                    "<a href='" + ResolveUrl(Eval("FilePath").ToString()) + "' target='_blank' style='color:#2563eb; font-weight:500; text-decoration:underline;'>Download Attached File</a>"
                                                ) : "<span style='color:#9ca3af;'>No File</span>" 
                                            %>
                                        </td>
                                        <td class="col-notes" style="color: #374151; max-width: 180px; word-break: break-word;"><%# Eval("SubmissionText") %></td>
                                        <td class="col-grade">
                                            <asp:TextBox ID="txtGrade" runat="server" Text='<%# Eval("Grade") %>' CssClass="input-grade" placeholder="Pts"></asp:TextBox>
                                        </td>
                                        <td class="col-feedback">
                                            <asp:TextBox ID="txtFeedback" runat="server" Text='<%# Eval("Feedback") %>' CssClass="input-feedback" placeholder="Feedback..."></asp:TextBox>
                                        </td>
                                        <td class="col-actions">
                                            <div class="action-btn-group">
                                                <asp:Button ID="btnSaveGrade" runat="server" CommandName="GradeSubmission" CommandArgument='<%# Eval("SubmissionID") %>' Text="Save" CssClass="btn-table-save" />
                                                <asp:Button ID="btnDeleteSubmission" runat="server" CommandName="DeleteSubmission" CommandArgument='<%# Eval("SubmissionID") %>' Text="Delete" CssClass="btn-table-delete" OnClientClick="return confirm('Are you sure you want to delete this submission record?');" />
                                            </div>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                        </tbody>
                                    </table>
                                </FooterTemplate>
                            </asp:Repeater>
                        </div>
                    </asp:Panel>
                </asp:Panel>
            </asp:Panel>

            <!-- SECTION 5: GRADEBOOK PANEL -->
            <asp:Panel ID="pnlGradebook" runat="server" Visible="false">
                <div class="workspace-header">
                    <div class="workspace-title">Gradebook</div>
                    <asp:Button ID="btnExportGradebook" runat="server" Text="Export CSV" CssClass="btn-primary-action" OnClick="btnExportGradebook_Click" Style="background: #4b5563;" />
                </div>

                <asp:GridView ID="gvGradebook" runat="server" AutoGenerateColumns="False" CssClass="lms-table" GridLines="None">
                    <HeaderStyle BackColor="#f9fafb" ForeColor="#374151" Font-Bold="true" />
                    <Columns>
                        <asp:BoundField DataField="StudentName" HeaderText="Student Name" />
                        <asp:BoundField DataField="QuizAverage" HeaderText="Quiz Avg (%)" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="AssignmentAverage" HeaderText="Assignment Avg (%)" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="OverallGrade" HeaderText="Overall Grade (%)" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center" ItemStyle-Font-Bold="true" />
                    </Columns>
                    <EmptyDataTemplate>
                        <div style="padding: 20px; text-align: center; color: #6b7280;">No grade records found for this course.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </asp:Panel>

            <!-- SECTION 6: USER MANAGEMENT & ENROLLMENTS PANEL -->
            <asp:Panel ID="pnlUserManagement" runat="server" Visible="false">
                <div class="workspace-header">
                    <div class="workspace-title">User Management & Enrollments</div>
                    <asp:LinkButton ID="btnOpenAddStudentModal" runat="server" CssClass="btn-primary-action" OnClientClick="openModal('addStudentModal'); return false;">
                        <i class="material-icons-outlined" style="font-size: 18px;">person_add</i> Enroll Student
                    </asp:LinkButton>
                </div>

                <!-- Pending Approval Requests Table -->
                <h4 style="margin: 16px 0 8px 0; font-size: 15px;">Pending Approval Requests</h4>
                <asp:GridView ID="gvPendingEnrollments" runat="server" AutoGenerateColumns="False" CssClass="lms-table" GridLines="None" OnRowCommand="gvPendingEnrollments_RowCommand">
                    <HeaderStyle BackColor="#f9fafb" ForeColor="#374151" Font-Bold="true" />
                    <Columns>
                        <asp:BoundField DataField="StudentName" HeaderText="Student Name" />
                        <asp:BoundField DataField="RequestedDate" HeaderText="Requested On" DataFormatString="{0:MMM dd, yyyy}" />
                        <asp:TemplateField HeaderText="Actions" ItemStyle-HorizontalAlign="Right">
                            <ItemTemplate>
                                <asp:Button ID="btnApprove" runat="server" CommandName="ApproveStudent" CommandArgument='<%# Eval("EnrollmentID") %>' Text="Accept" CssClass="btn-submit" Style="background: #059669; padding: 4px 12px; font-size: 12px;" />
                                <asp:Button ID="btnReject" runat="server" CommandName="RejectStudent" CommandArgument='<%# Eval("EnrollmentID") %>' Text="Reject" CssClass="btn-cancel" Style="padding: 4px 12px; font-size: 12px;" />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div style="padding: 12px; text-align: center; color: #9ca3af; font-size: 13px;">No pending enrollment requests.</div>
                    </EmptyDataTemplate>
                </asp:GridView>

                <!-- Active Enrolled Roster Table -->
                <h4 style="margin: 24px 0 8px 0; font-size: 15px;">Active Roster</h4>
                <asp:GridView ID="gvActiveStudents" runat="server" AutoGenerateColumns="False" CssClass="lms-table" GridLines="None">
                    <HeaderStyle BackColor="#f9fafb" ForeColor="#374151" Font-Bold="true" />
                    <Columns>
                        <asp:BoundField DataField="StudentName" HeaderText="Student Name" />
                        <asp:BoundField DataField="ApprovedDate" HeaderText="Enrolled Date" DataFormatString="{0:MMM dd, yyyy}" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class="badge-status" style="background: #10b981; color: white;">Active</span>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div style="padding: 12px; text-align: center; color: #9ca3af; font-size: 13px;">No active students in this course.</div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </asp:Panel>

        </div>
    </div>

    <!-- EDIT MODULE MODAL (TEACHER SIDE) -->
    <div id="editModuleModal" class="lms-modal-overlay">
        <div class="lms-modal-card">
            <div class="lms-modal-header">
                <h3>Edit Module / Unit</h3>
                <button type="button" class="modal-close-btn" onclick="closeModal('editModuleModal');">&times;</button>
            </div>
            <div class="lms-modal-body">
                <asp:HiddenField ID="hfEditModuleID" runat="server" ClientIDMode="Static" />
                <div class="form-group">
                    <label>Unit Title <span class="required-star">*</span></label>
                    <asp:TextBox ID="txtEditUnitTitle" runat="server" ClientIDMode="Static" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Focus Area</label>
                    <asp:TextBox ID="txtEditFocusArea" runat="server" ClientIDMode="Static" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="lms-modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal('editModuleModal');">Cancel</button>
                <asp:Button ID="btnUpdateModule" runat="server" Text="Update Module" CssClass="btn-submit" OnClick="btnUpdateModule_Click" />
            </div>
        </div>
    </div>

    <!-- DIRECT ENROLLMENT MODAL -->
    <div id="addStudentModal" class="lms-modal-overlay">
        <div class="lms-modal-card">
            <div class="lms-modal-header">
                <h3>Enroll Student to Course</h3>
                <button type="button" class="modal-close-btn" onclick="closeModal('addStudentModal');">&times;</button>
            </div>
            <div class="lms-modal-body">
                <div class="form-group">
                    <label>Select Student <span class="required-star">*</span></label>
                    <asp:DropDownList ID="ddlAvailableStudents" runat="server" CssClass="form-control"></asp:DropDownList>
                </div>
            </div>
            <div class="lms-modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal('addStudentModal');">Cancel</button>
                <asp:Button ID="btnDirectEnroll" runat="server" Text="Enroll Student" CssClass="btn-submit" OnClick="btnDirectEnroll_Click" />
            </div>
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

    <!-- CREATE MODULE MODAL -->
    <div id="moduleModal" class="lms-modal-overlay">
        <div class="lms-modal-card">
            <div class="lms-modal-header">
                <h3>Create New Module / Unit</h3>
                <button type="button" class="modal-close-btn" onclick="closeModal('moduleModal');">&times;</button>
            </div>
            <div class="lms-modal-body">
                <div class="form-group">
                    <label>Unit Title <span class="required-star">*</span></label>
                    <asp:TextBox ID="txtUnitTitle" runat="server" CssClass="form-control" placeholder="e.g. Unit 1: Hello"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Number of Lessons</label>
                    <asp:TextBox ID="txtLessonCount" runat="server" TextMode="Number" CssClass="form-control" placeholder="6"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Focus Area</label>
                    <asp:TextBox ID="txtFocusArea" runat="server" CssClass="form-control" placeholder="e.g. Speaking & Practice"></asp:TextBox>
                </div>
            </div>
            <div class="lms-modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal('moduleModal');">Cancel</button>
                <asp:Button ID="btnSaveModule" runat="server" Text="Create Module" CssClass="btn-submit" OnClick="btnSaveModule_Click" />
            </div>
        </div>
    </div>

    <!-- ADD LESSON / CONTENT MODAL -->
    <div id="addLessonModal" class="lms-modal-overlay">
        <div class="lms-modal-card">
            <div class="lms-modal-header">
                <h3>Add Content Item to Unit</h3>
                <button type="button" class="modal-close-btn" onclick="closeModal('addLessonModal');">&times;</button>
            </div>
            <div class="lms-modal-body">
                <asp:HiddenField ID="hfActiveModuleID" runat="server" />
                <div class="form-group">
                    <label>Lesson Title <span class="required-star">*</span></label>
                    <asp:TextBox ID="txtLessonTitle" runat="server" CssClass="form-control" placeholder="e.g. Chapter 1 Vocabulary Video"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Content Type</label>
                    <asp:DropDownList ID="ddlContentType" runat="server" CssClass="form-control">
                        <asp:ListItem Value="Reading">Reading / Text Instructions</asp:ListItem>
                        <asp:ListItem Value="Document">Document (PDF / Word / PPT)</asp:ListItem>
                        <asp:ListItem Value="Video">Video Resource</asp:ListItem>
                        <asp:ListItem Value="Image">Image / Graphic</asp:ListItem>
                        <asp:ListItem Value="Quiz">Practice Quiz</asp:ListItem>
                        <asp:ListItem Value="Assignment">Homework Assignment</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>Upload File (PDF, DOCX, PPTX, MP4, PNG, JPG)</label>
                    <asp:FileUpload ID="fileContentUpload" runat="server" CssClass="form-control" Style="padding: 6px;" />
                </div>
                <div class="form-group">
                    <label>Or Details / External Link URL</label>
                    <asp:TextBox ID="txtContentDetails" runat="server" CssClass="form-control" placeholder="e.g. Read pages 12-18 or paste video link"></asp:TextBox>
                </div>
            </div>
            <div class="lms-modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal('addLessonModal');">Cancel</button>
                <asp:Button ID="btnSaveLesson" runat="server" Text="Add Item" CssClass="btn-submit" OnClick="btnSaveLesson_Click" />
            </div>
        </div>
    </div>

    <!-- EDIT LESSON / CONTENT MODAL -->
    <div id="editLessonModal" class="lms-modal-overlay">
        <div class="lms-modal-card">
            <div class="lms-modal-header">
                <h3>Edit Content Item</h3>
                <button type="button" class="modal-close-btn" onclick="closeModal('editLessonModal');">&times;</button>
            </div>
            <div class="lms-modal-body">
                <asp:HiddenField ID="hfEditLessonID" runat="server" />
                <div class="form-group">
                    <label>Lesson Title <span class="required-star">*</span></label>
                    <asp:TextBox ID="txtEditLessonTitle" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Content Type</label>
                    <asp:DropDownList ID="ddlEditContentType" runat="server" CssClass="form-control">
                        <asp:ListItem Value="Reading">Reading / Text Instructions</asp:ListItem>
                        <asp:ListItem Value="Document">Document (PDF / Word / PPT)</asp:ListItem>
                        <asp:ListItem Value="Video">Video Resource</asp:ListItem>
                        <asp:ListItem Value="Image">Image / Graphic</asp:ListItem>
                        <asp:ListItem Value="Quiz">Practice Quiz</asp:ListItem>
                        <asp:ListItem Value="Assignment">Homework Assignment</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label>Replace File (Optional)</label>
                    <asp:FileUpload ID="fileEditContentUpload" runat="server" CssClass="form-control" Style="padding: 6px;" />
                </div>
                <div class="form-group">
                    <label>Details / External Link URL</label>
                    <asp:TextBox ID="txtEditContentDetails" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="lms-modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal('editLessonModal');">Cancel</button>
                <asp:Button ID="btnUpdateLesson" runat="server" Text="Update Item" CssClass="btn-submit" OnClick="btnUpdateLesson_Click" />
            </div>
        </div>
    </div>

    <!-- DYNAMIC GOOGLE FORM STYLE QUIZ MODAL (CREATE / EDIT) -->
    <div id="quizFormModal" class="lms-modal-overlay">
        <div class="lms-modal-card" style="max-width: 680px; max-height: 85vh; overflow-y: auto;">
            <div class="lms-modal-header">
                <h3><span id="quizModalHeaderTitle">Create Google Form-style Quiz</span></h3>
                <button type="button" class="modal-close-btn" onclick="closeModal('quizFormModal');">&times;</button>
            </div>
            <div class="lms-modal-body">
                <asp:HiddenField ID="hfEditQuizID" runat="server" ClientIDMode="Static" />
                <div class="form-group">
                    <label>Quiz Title <span class="required-star">*</span></label>
                    <asp:TextBox ID="txtFormQuizTitle" runat="server" ClientIDMode="Static" CssClass="form-control" placeholder="e.g. Unit 1 Vocabulary Test"></asp:TextBox>
                </div>
                
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                    <div class="form-group">
                        <label>Open Date & Time <span class="required-star">*</span></label>
                        <asp:TextBox ID="txtFormOpenDate" runat="server" ClientIDMode="Static" TextMode="DateTimeLocal" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Close Date & Time <span class="required-star">*</span></label>
                        <asp:TextBox ID="txtFormCloseDate" runat="server" ClientIDMode="Static" TextMode="DateTimeLocal" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label>Time Limit (Minutes)</label>
                    <asp:TextBox ID="txtFormTimeLimit" runat="server" ClientIDMode="Static" CssClass="form-control" placeholder="15"></asp:TextBox>
                </div>

                <hr style="border: 0; border-top: 1px solid #e5e7eb; margin: 20px 0;" />

                <div id="questionsContainer"></div>

                <button type="button" class="btn-primary-action" onclick="addQuestionCard(null);" style="background: #f3f4f6; color: #1f2937; border: 1px dashed #9ca3af; width: 100%; justify-content: center; margin-top: 10px;">
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

    <!-- ENHANCED CREATE ASSIGNMENT MODAL -->
    <div id="assignmentModal" class="lms-modal-overlay">
        <div class="lms-modal-card" style="max-width: 520px;">
            <div class="lms-modal-header">
                <h3>Create Assignment</h3>
                <button type="button" class="modal-close-btn" onclick="closeModal('assignmentModal');">&times;</button>
            </div>
            <div class="lms-modal-body">
                <div class="form-group">
                    <label>Assignment Title <span class="required-star">*</span></label>
                    <asp:TextBox ID="txtAssignmentTitle" runat="server" CssClass="form-control" placeholder="e.g. Unit 1 Essay"></asp:TextBox>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                    <div class="form-group">
                        <label>Start Date & Time <span class="required-star">*</span></label>
                        <asp:TextBox ID="txtAssignmentStartDate" runat="server" TextMode="DateTimeLocal" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Due Date & Time <span class="required-star">*</span></label>
                        <asp:TextBox ID="txtAssignmentDueDate" runat="server" TextMode="DateTimeLocal" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label>Maximum Points</label>
                    <asp:TextBox ID="txtMaxPoints" runat="server" TextMode="Number" CssClass="form-control" Text="100"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Instructions / Prompt</label>
                    <asp:TextBox ID="txtAssignmentInstructions" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="Enter submission guidelines..."></asp:TextBox>
                </div>
            </div>
            <div class="lms-modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal('assignmentModal');">Cancel</button>
                <asp:Button ID="btnSaveAssignment" runat="server" Text="Create Assignment" CssClass="btn-submit" OnClick="btnSaveAssignment_Click" />
            </div>
        </div>
    </div>

    <!-- EDIT ASSIGNMENT MODAL -->
    <div id="editAssignmentModal" class="lms-modal-overlay">
        <div class="lms-modal-card" style="max-width: 520px;">
            <div class="lms-modal-header">
                <h3>Edit Assignment</h3>
                <button type="button" class="modal-close-btn" onclick="closeModal('editAssignmentModal');">&times;</button>
            </div>
            <div class="lms-modal-body">
                <asp:HiddenField ID="hfEditAssignmentID" runat="server" />
                <div class="form-group">
                    <label>Assignment Title <span class="required-star">*</span></label>
                    <asp:TextBox ID="txtEditAssignmentTitle" runat="server" CssClass="form-control"></asp:TextBox>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                    <div class="form-group">
                        <label>Start Date & Time <span class="required-star">*</span></label>
                        <asp:TextBox ID="txtEditAssignmentStartDate" runat="server" TextMode="DateTimeLocal" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label>Due Date & Time <span class="required-star">*</span></label>
                        <asp:TextBox ID="txtEditAssignmentDueDate" runat="server" TextMode="DateTimeLocal" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label>Maximum Points</label>
                    <asp:TextBox ID="txtEditMaxPoints" runat="server" TextMode="Number" CssClass="form-control"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label>Instructions / Prompt</label>
                    <asp:TextBox ID="txtEditAssignmentInstructions" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="lms-modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal('editAssignmentModal');">Cancel</button>
                <asp:Button ID="btnUpdateAssignment" runat="server" Text="Update Assignment" CssClass="btn-submit" OnClick="btnUpdateAssignment_Click" />
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function openModal(id = "") {
            var modal = document.getElementById(id);
            if (modal) modal.classList.add("show");
        }

        function closeModal(id = "") {
            var modal = document.getElementById(id);
            if (modal) modal.classList.remove("show");
        }
        let questionCounter = 0;
        
        /** @type {any} */
        var quizTimerInterval = 0;

        function startQuizTimer() {
            var timerDisplay = document.getElementById('quizTimer');
            var hfMinutes = document.getElementById('hfQuizTimeLimitMinutes');

            if (!timerDisplay || !hfMinutes) return;

            var totalMinutes = parseInt(Object(hfMinutes).value) || 15;
            var totalSeconds = totalMinutes * 60;

            if (quizTimerInterval !== 0) clearInterval(quizTimerInterval);

            quizTimerInterval = setInterval(function () {
                var minutes = Math.floor(totalSeconds / 60);
                var seconds = totalSeconds % 60;

                var strMinutes = minutes < 10 ? '0' + minutes : minutes.toString();
                var strSeconds = seconds < 10 ? '0' + seconds : seconds.toString();

                if (timerDisplay) {
                    timerDisplay.textContent = strMinutes + ':' + strSeconds;

                    if (totalSeconds <= 300) {
                        timerDisplay.style.color = '#f59e0b';
                    }
                    if (totalSeconds <= 60) {
                        timerDisplay.style.color = '#ef4444';
                    }
                }

                if (--totalSeconds < 0) {
                    if (quizTimerInterval !== 0) clearInterval(quizTimerInterval);
                    alert('Time is up! Your quiz will now be submitted automatically.');
                    var submitBtn = document.getElementById('btnSubmitQuiz');
                    if (submitBtn) submitBtn.click();
                }
            }, 1000);
        }

        function resetQuizModal() {
            var hfEditQuizID = document.getElementById('hfEditQuizID');
            var txtFormQuizTitle = document.getElementById('txtFormQuizTitle');
            var txtFormOpenDate = document.getElementById('txtFormOpenDate');
            var txtFormCloseDate = document.getElementById('txtFormCloseDate');
            var txtFormTimeLimit = document.getElementById('txtFormTimeLimit');
            var headerTitle = document.getElementById('quizModalHeaderTitle');

            if (hfEditQuizID) Object(hfEditQuizID).value = '';
            if (txtFormQuizTitle) Object(txtFormQuizTitle).value = '';
            if (txtFormOpenDate) Object(txtFormOpenDate).value = '';
            if (txtFormCloseDate) Object(txtFormCloseDate).value = '';
            if (txtFormTimeLimit) Object(txtFormTimeLimit).value = '';
            if (headerTitle) headerTitle.innerText = 'Create Google Form-style Quiz';

            const container = document.getElementById('questionsContainer');
            if (container) container.innerHTML = '';
            questionCounter = 0;
            addQuestionCard(null);
        }

        function populateEditQuizModal() {
            var headerTitle = document.getElementById('quizModalHeaderTitle');
            if (headerTitle) headerTitle.innerText = 'Edit Quiz & Questions';

            const container = document.getElementById('questionsContainer');
            if (!container) return;
            container.innerHTML = '';
            questionCounter = 0;

            var hfQuizJson = document.getElementById('hfQuizJsonData');
            const jsonVal = hfQuizJson ? Object(hfQuizJson).value : '';

            if (jsonVal) {
                try {
                    const questions = JSON.parse(jsonVal);
                    questions.forEach(function (q = null) {
                        addQuestionCard(q);
                    });
                } catch (e) {
                    addQuestionCard(null);
                }
            } else {
                addQuestionCard(null);
            }
            openModal('quizFormModal');
        }

        /** @param {any} data */
        function addQuestionCard(data = null) {
            questionCounter++;
            const container = document.getElementById('questionsContainer');
            if (!container) return;

            const card = document.createElement('div');
            card.className = 'feed-card question-builder-card';
            card.id = 'qCard_' + questionCounter;

            const qText = data && Object(data).QuestionText ? Object(data).QuestionText : '';
            const optA = data && Object(data).OptionA ? Object(data).OptionA : '';
            const optB = data && Object(data).OptionB ? Object(data).OptionB : '';
            const optC = data && Object(data).OptionC ? Object(data).OptionC : '';
            const optD = data && Object(data).OptionD ? Object(data).OptionD : '';
            const correct = data && Object(data).CorrectAnswer ? Object(data).CorrectAnswer : 'A';

            card.innerHTML = `
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                    <strong>Question ${questionCounter}</strong>
                    <button type="button" onclick="removeQuestionCard(${questionCounter})" style="background: none; border: none; color: #ef4444; cursor: pointer; font-weight: 600;">Remove</button>
                </div>
                <div class="form-group" style="margin-bottom: 10px;">
                    <input type="text" class="form-control q-text" placeholder="Question prompt..." value="${qText}" />
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-bottom: 10px;">
                    <input type="text" class="form-control opt-a" placeholder="Option A" value="${optA}" />
                    <input type="text" class="form-control opt-b" placeholder="Option B" value="${optB}" />
                    <input type="text" class="form-control opt-c" placeholder="Option C" value="${optC}" />
                    <input type="text" class="form-control opt-d" placeholder="Option D" value="${optD}" />
                </div>
                <div style="font-size: 13px;">
                    <label><strong>Correct Choice:</strong></label>
                    <select class="form-control correct-opt" style="width: 120px; display: inline-block; margin-left: 8px;">
                        <option value="A" ${correct === 'A' ? 'selected' : ''}>Option A</option>
                        <option value="B" ${correct === 'B' ? 'selected' : ''}>Option B</option>
                        <option value="C" ${correct === 'C' ? 'selected' : ''}>Option C</option>
                        <option value="D" ${correct === 'D' ? 'selected' : ''}>Option D</option>
                    </select>
                </div>
            `;
            container.appendChild(card);
        }

        /** @param {number} id */
        function removeQuestionCard(id = 0) {
            const card = document.getElementById('qCard_' + id);
            if (card) card.remove();
        }

        function prepareQuizJson() {
            const cards = document.querySelectorAll('.question-builder-card');

            var questions = [Object({ QuestionText: '', OptionA: '', OptionB: '', OptionC: '', OptionD: '', CorrectAnswer: '' })];
            questions.pop();

            cards.forEach(function (card) {
                const qInput = card.querySelector('.q-text');
                const optAInput = card.querySelector('.opt-a');
                const optBInput = card.querySelector('.opt-b');
                const optCInput = card.querySelector('.opt-c');
                const optDInput = card.querySelector('.opt-d');
                const correctSelect = card.querySelector('.correct-opt');

                const text = qInput ? Object(qInput).value.trim() : '';
                const optA = optAInput ? Object(optAInput).value.trim() : '';
                const optB = optBInput ? Object(optBInput).value.trim() : '';
                const optC = optCInput ? Object(optCInput).value.trim() : '';
                const optD = optDInput ? Object(optDInput).value.trim() : '';
                const correct = correctSelect ? Object(correctSelect).value : 'A';

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

            var hfQuizJson = document.getElementById('hfQuizJsonData');
            if (hfQuizJson) {
                Object(hfQuizJson).value = JSON.stringify(questions);
            }
            return true;
        }

        document.addEventListener('DOMContentLoaded', function () {
            const container = document.getElementById('questionsContainer');
            if (container && container.children.length === 0) {
                addQuestionCard(null);
            }
        });
    </script>

</asp:Content>