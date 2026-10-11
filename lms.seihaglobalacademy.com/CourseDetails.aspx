<%@ Page Title="Course Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CourseDetails.aspx.cs" Inherits="lms.seihaglobalacademy.com.CourseDetails" ResponseEncoding="utf-8" ValidateRequest="false" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Google Material Icons CDN -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet" />
    
    <!-- Quill Rich Text Editor CSS -->
    <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet" />

    <style type="text/css">
        /* QUILL ALIGNMENT & CONTENT FORMATTING FIXES */
        .announcement-body-content .ql-align-center,
        .ql-align-center {
            text-align: center !important;
        }

        .announcement-body-content .ql-align-right,
        .ql-align-right {
            text-align: right !important;
        }

        .announcement-body-content .ql-align-justify,
        .ql-align-justify {
            text-align: justify !important;
        }

        /* DARK MODE TEXT CONTRAST FIXES FOR LESSONS & MODULES */
        .dark .feed-card,
        .dark-mode .feed-card,
        [data-theme='dark'] .feed-card,
        body[class*='dark'] .feed-card,
        .dark .module-card-item,
        .dark-mode .module-card-item,
        [data-theme='dark'] .module-card-item,
        body[class*='dark'] .module-card-item {
            background-color: #1e293b !important;
            border-color: #334155 !important;
            color: #f8fafc !important;
        }

        /* Fix text color inside lesson accordion rows */
        .dark .feed-card div,
        .dark-mode .feed-card div,
        [data-theme='dark'] .feed-card div,
        body[class*='dark'] .feed-card div {
            color: #f8fafc !important;
        }

        /* Fix secondary text (subtitles, locked status notes, descriptions) */
        .dark .feed-card div[style*="color: #6b7280"],
        .dark-mode .feed-card div[style*="color: #6b7280"],
        [data-theme='dark'] .feed-card div[style*="color: #6b7280"],
        body[class*='dark'] .feed-card div[style*="color: #6b7280"] {
            color: #94a3b8 !important;
        }

        /* Fix locked item card background in Dark Mode */
        .dark .feed-card[style*="background: #f3f4f6"],
        .dark-mode .feed-card[style*="background: #f3f4f6"],
        [data-theme='dark'] .feed-card[style*="background: #f3f4f6"],
        body[class*='dark'] .feed-card[style*="background: #f3f4f6"] {
            background-color: #0f172a !important;
            border-color: #334155 !important;
        }

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

        /* Quill Rich Text Editor Container Tweaks */
        .ql-editor {
            color: #1f2937 !important;
            font-size: 14px;
        }

        /* Fix placeholder text styling inside Quill */
        .ql-editor.ql-blank::before {
            color: #9ca3af !important;
            font-style: normal;
        }
        .ql-container.ql-snow {
            border-bottom-left-radius: 6px;
            border-bottom-right-radius: 6px;
            font-family: inherit;
        }
        .ql-toolbar.ql-snow {
            border-top-left-radius: 6px;
            border-top-right-radius: 6px;
            background: #f8fafc;
        }
        .announcement-body-content p {
            margin: 0 0 8px 0;
        }
        .announcement-body-content ul, .announcement-body-content ol {
            padding-left: 20px;
            margin: 6px 0;
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
    
    <!-- Mode Indicator Banner (Controlled by C#) -->
    <asp:PlaceHolder ID="phTeacherBanner" runat="server">
        <asp:Panel ID="pnlModeBanner" runat="server" CssClass="mode-banner-teacher">
            <i class="material-icons-outlined" style="font-size: 20px;">info</i>
            <asp:Label ID="lblModeStatus" runat="server" Text="TEACHER MODE &mdash; Full administrative access active."></asp:Label>
        </asp:Panel>
    </asp:PlaceHolder>

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
                <!-- Modules & Units -->
                <li id="liModules" runat="server">
                    <asp:LinkButton ID="btnNavModules" runat="server" OnClick="btnNav_Click" CommandArgument="Modules">
                        <i class="material-icons-outlined">view_module</i> Modules & Units
                    </asp:LinkButton>
                </li>
                <!-- Tests & Quizzes -->
                <li id="liQuizzes" runat="server">
                    <asp:LinkButton ID="btnNavQuizzes" runat="server" OnClick="btnNav_Click" CommandArgument="Quizzes">
                        <i class="material-icons-outlined">assignment_turned_in</i> Tests & Quizzes
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
                                    <div class="feed-card-title">&#128204; <%# Eval("Title") %></div>
                                    <div class="feed-card-meta">Posted by <%# Eval("Author") %> &bull; <%# Eval("PostDate") %></div>
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
                            <div style="font-size: 13.5px; color: var(--text-light); margin-top: 10px; line-height: 1.6;" class="announcement-body-content">
                                <%# Eval("Body") %>
                            </div>
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
                            <div style="color: var(--text-muted); font-size: 13px; margin-bottom: 6px;">
                                <asp:Label ID="lblTeacherPreviewInstructions" runat="server" Text="Please complete all questions below and click Submit."></asp:Label>
                            </div>
                            <span class="badge-status" style="background: #e0e7ff; color: #3730a3;">Teacher Answer Key Preview</span>
                        </div>
                        <asp:Button ID="btnBackFromPreview" runat="server" Text="Back to Quizzes" CssClass="btn-primary-action" OnClick="btnBackToQuizzes_Click" Style="background: #6b7280;" />
                    </div>

                    <asp:Repeater ID="rptTeacherPreviewQuestions" runat="server" OnItemDataBound="rptTeacherPreviewQuestions_ItemDataBound">
                        <ItemTemplate>
                            <div class="feed-card" style="border-left: 4px solid #4f46e5;">
                                <asp:PlaceHolder ID="phTeacherAudio" runat="server" Visible="false">
                                    <div style="background:#1e293b;border:1px solid #334155;border-radius:8px;padding:10px 14px;margin-bottom:12px;display:flex;align-items:center;gap:10px;">
                                        <i class="material-icons-outlined" style="color:#38bdf8;font-size:22px;">headphones</i>
                                        <asp:Literal ID="litTeacherAudio" runat="server"></asp:Literal>
                                    </div>
                                </asp:PlaceHolder>
                                <asp:PlaceHolder ID="phTeacherImage" runat="server" Visible="false">
                                    <div style="margin-bottom:12px;border:1px solid #e5e7eb;border-radius:8px;overflow:hidden;text-align:center;background:#f8fafc;padding:8px;">
                                        <asp:Image ID="imgTeacherQuestion" runat="server" Style="max-width:100%;max-height:280px;object-fit:contain;" AlternateText="Question image" />
                                    </div>
                                </asp:PlaceHolder>
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
                                    &#10004; Correct Answer Key: Option <%# Eval("CorrectAnswer") %>
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
                            <div style="color: var(--text-muted); font-size: 13px;">
                                <asp:Label ID="lblActiveQuizInstructions" runat="server" Text="Please complete all questions below and click Submit."></asp:Label>
                            </div>
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
                                <div style="font-size: 11px; text-transform: uppercase; font-weight: 700; color: #4f46e5; margin-bottom: 4px;">
                                        <%# Eval("QuestionType") %>
                                    </div>
                                    <div style="font-weight: 600; font-size: 15px; margin-bottom: 12px;">
                                        <%# Container.ItemIndex + 1 %>. <%# Eval("QuestionText") %> <span style="color: #ef4444;">*</span>
                                    </div>

                                    <!-- Multiple Choice & True/False -->
                                    <asp:RadioButtonList ID="RadioButtonList1" runat="server" CssClass="form-options-list" Visible="false" Style="margin-left: 8px; font-size: 13.5px; line-height: 1.8;">
                                    </asp:RadioButtonList>

                                    <!-- Identification, Fill in Blank, Enumeration -->
                                    <asp:TextBox ID="txtShortAnswer" runat="server" CssClass="form-control" Visible="false" placeholder="Type your answer here..."></asp:TextBox>

                                    <!-- Essay -->
                                    <asp:TextBox ID="txtEssayAnswer" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" Visible="false" placeholder="Write your response here..."></asp:TextBox>
                                </div>
                                <asp:PlaceHolder ID="phQuizAudio" runat="server" Visible="false">
                                    <div style="background: #1e293b; border: 1px solid #334155; border-radius: 8px; padding: 12px 16px; margin-bottom: 14px; display: flex; align-items: center; gap: 12px;">
                                        <i class="material-icons-outlined" style="color: #38bdf8; font-size: 24px;">headphones</i>
                                        <div style="flex: 1;">
                                            <div style="font-size: 11px; text-transform: uppercase; color: #94a3b8; font-weight: 600; margin-bottom: 6px;">Listening Passage &mdash; Play the audio before answering</div>
                                            <asp:Literal ID="litQuizAudio" runat="server"></asp:Literal>
                                        </div>
                                    </div>
                                </asp:PlaceHolder>

                                <asp:PlaceHolder ID="phQuizImage" runat="server" Visible="false">
                                    <div style="margin-bottom: 14px; border: 1px solid #e5e7eb; border-radius: 8px; overflow: hidden; text-align: center; background: #f8fafc;">
                                        <asp:Image ID="imgQuizQuestion" runat="server" Style="max-width: 100%; max-height: 320px; object-fit: contain; display: block; margin: 0 auto;" AlternateText="Question image" />
                                    </div>
                                </asp:PlaceHolder>

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
                        <asp:Button ID="btnBackToModulesGrid" runat="server" Text="&larr; Back to All Units" CssClass="btn-primary-action" OnClick="btnBackToModulesGrid_Click" Visible="false" Style="background: #6b7280;" />
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

                                    <asp:LinkButton ID="btnSelectModule" runat="server" CommandName="SelectModule" CommandArgument='<%# Eval("ModuleID") %>' Style="text-decoration: none; color: inherit; display: block;">
                                        <div style="height: 100px; background-color: #2563eb; padding: 16px; box-sizing: border-box; display: flex; align-items: flex-end;">
                                            <h3 style="color: #ffffff; margin: 0; font-size: 18px; font-weight: 700;"><%# Eval("UnitTitle") %></h3>
                                        </div>
                                        <div style="padding: 14px 16px;">
                                            <div style="font-size: 13px; color: #6b7280;"><%# Eval("LessonCount") %> Lessons &bull; <%# Eval("FocusArea") %></div>
                                            <div style="font-size: 12px; color: #2563eb; margin-top: 10px; font-weight: 600;">Click to view content &rarr;</div>
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
                                            <div class="lesson-title-text" style="font-weight: 600; font-size: 15px;">
                                                    <%# Eval("LessonTitle") %>
                                                </div>
                                                <div class="lesson-sub-text" style="font-size: 12.5px; margin-top: 2px;">
                                                <%# (bool)Eval("IsUnlocked") 
                                                    ? (Eval("ContentDetails").ToString().StartsWith("~/Uploads/") 
                                                        ? "<a href='" + ResolveUrl(Eval("ContentDetails").ToString()) + "' target='_blank' style='color:#2563eb; text-decoration:underline;'>Download Attached File</a>" 
                                                        : Eval("ContentDetails"))
                                                    : "<span style='color: #ef4444;'>Locked &mdash; Complete the previous item to unlock</span>" %>
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

            <!-- SECTION 4: ASSIGNMENTS PANEL -->
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

                                <asp:PlaceHolder ID="phTeacherAssignmentActions" runat="server" Visible='<%# !IsStudentView() %>'>
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
                        <asp:Button ID="btnBackToAssignments" runat="server" Text="&larr; Back to Assignments" CssClass="btn-primary-action" OnClick="btnBackToAssignments_Click" Style="background: #6b7280;" />
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

                    <asp:Panel ID="pnlStudentSubmission" runat="server">
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

            <!-- SECTION 6: USER MANAGEMENT PANEL -->
            <asp:Panel ID="pnlUserManagement" runat="server" Visible="false">
                <div class="workspace-header">
                    <div class="workspace-title">User Management & Enrollments</div>
                    <asp:LinkButton ID="btnOpenAddStudentModal" runat="server" CssClass="btn-primary-action" OnClientClick="openModal('addStudentModal'); return false;">
                        <i class="material-icons-outlined" style="font-size: 18px;">person_add</i> Enroll Student
                    </asp:LinkButton>
                </div>

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

    <!-- MODALS -->
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

    <!-- Post Announcement Modal with Quill Rich Text Editor -->
    <div id="announcementModal" class="lms-modal-overlay">
        <div class="lms-modal-card" style="max-width: 650px;">
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
                    <div id="quillNewAnnouncement" style="height: 180px; background: #fff;"></div>
                    <asp:HiddenField ID="hfAnnouncementBody" runat="server" ClientIDMode="Static" />
                </div>
            </div>
            <div class="lms-modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal('announcementModal');">Cancel</button>
                <asp:Button ID="btnPostAnnouncement" runat="server" Text="Post Announcement" CssClass="btn-submit" OnClientClick="return syncQuillNew();" OnClick="btnPostAnnouncement_Click" />
            </div>
        </div>
    </div>

    <!-- Edit Announcement Modal with Quill Rich Text Editor -->
    <div id="editAnnouncementModal" class="lms-modal-overlay">
        <div class="lms-modal-card" style="max-width: 650px;">
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
                    <div id="quillEditAnnouncement" style="height: 180px; background: #fff;"></div>
                    <asp:HiddenField ID="hfEditAnnouncementBody" runat="server" ClientIDMode="Static" />
                </div>
            </div>
            <div class="lms-modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal('editAnnouncementModal');">Cancel</button>
                <asp:Button ID="btnUpdateAnnouncement" runat="server" Text="Update Post" CssClass="btn-submit" OnClientClick="return syncQuillEdit();" OnClick="btnUpdateAnnouncement_Click" />
            </div>
        </div>
    </div>

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

                <div class="form-group">
                    <label>Instructions / Directions</label>
                    <asp:TextBox ID="txtFormInstructions" runat="server" ClientIDMode="Static" TextMode="MultiLine" Rows="2" CssClass="form-control" placeholder="e.g. Please complete all questions below and click Submit."></asp:TextBox>
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

    <!-- Quill Rich Text Editor Script CDN -->
    <script src="https://cdn.quilljs.com/1.3.6/quill.min.js"></script>

    <script type="text/javascript">
        function openModal(id = "") {
            var modal = document.getElementById(id);
            if (modal) modal.classList.add("show");
        }

        function closeModal(id = "") {
            var modal = document.getElementById(id);
            if (modal) modal.classList.remove("show");
        }

        /* QUILL RICH TEXT EDITOR INITIALIZATION */
        var quillToolbarOptions = [
            [{ 'header': [1, 2, 3, false] }],
            ['bold', 'italic', 'underline', 'strike'],
            [{ 'color': [] }, { 'background': [] }],          // Font colors & highlight colors
            [{ 'list': 'ordered' }, { 'list': 'bullet' }],     // Ordered and Bulleted lists
            [{ 'align': [] }],
            ['clean']                                         // Clear formatting button
        ];

        var quillNew = new Quill('#quillNewAnnouncement', {
            theme: 'snow',
            modules: { toolbar: quillToolbarOptions },
            placeholder: 'Write your announcement message here...'
        });

        var quillEdit = new Quill('#quillEditAnnouncement', {
            theme: 'snow',
            modules: { toolbar: quillToolbarOptions }
        });

        function syncQuillNew() {
            var hiddenInput = document.getElementById('hfAnnouncementBody');
            if (hiddenInput && quillNew) {
                hiddenInput.value = encodeURIComponent(quillNew.root.innerHTML);
            }
            return true;
        }

        function syncQuillEdit() {
            var hiddenInput = document.getElementById('hfEditAnnouncementBody');
            if (hiddenInput && quillEdit) {
                hiddenInput.value = encodeURIComponent(quillEdit.root.innerHTML);
            }
            return true;
        }

        function loadQuillEditContent(htmlContent) {
            if (quillEdit) {
                quillEdit.root.innerHTML = decodeURIComponent(htmlContent);
            }
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
            var txtFormInstructions = document.getElementById('txtFormInstructions');
            var headerTitle = document.getElementById('quizModalHeaderTitle');

            if (hfEditQuizID) Object(hfEditQuizID).value = '';
            if (txtFormQuizTitle) Object(txtFormQuizTitle).value = '';
            if (txtFormOpenDate) Object(txtFormOpenDate).value = '';
            if (txtFormCloseDate) Object(txtFormCloseDate).value = '';
            if (txtFormTimeLimit) Object(txtFormTimeLimit).value = '';
            if (txtFormInstructions) Object(txtFormInstructions).value = '';
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
                    const parsedData = JSON.parse(jsonVal);
                    
                    let questions = [];
                    let instructionsText = '';

                    if (Array.isArray(parsedData)) {
                        questions = parsedData;
                        if (questions.length > 0 && questions[0].Instructions) {
                            instructionsText = questions[0].Instructions;
                        }
                    } else if (typeof parsedData === 'object' && parsedData !== null) {
                        questions = parsedData.Questions || [];
                        instructionsText = parsedData.Instructions || '';
                    }

                    var txtInstructions = document.getElementById('txtFormInstructions');
                    if (txtInstructions) Object(txtInstructions).value = instructionsText;

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

            const qType = data && data.QuestionType ? data.QuestionType : 'Multiple Choice';
            const qText = data && data.QuestionText ? data.QuestionText : '';
            const optA = data && data.OptionA ? data.OptionA : '';
            const optB = data && data.OptionB ? data.OptionB : '';
            const optC = data && data.OptionC ? data.OptionC : '';
            const optD = data && data.OptionD ? data.OptionD : '';
            const correct = data && data.CorrectAnswer ? data.CorrectAnswer : 'A';
            const textAns = data && data.CorrectTextAnswer ? data.CorrectTextAnswer : '';
            const enumAns = data && data.EnumerationAnswers ? data.EnumerationAnswers : '';
            const matchJson = data && data.MatchingPairsJson ? data.MatchingPairsJson : '';
            const imgPath = data && data.ImagePath ? data.ImagePath : '';
            const audioPath = data && data.AudioPath ? data.AudioPath : '';

            card.innerHTML = `
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                    <strong>Question ${questionCounter}</strong>
                    <button type="button" onclick="removeQuestionCard(${questionCounter})" style="background: none; border: none; color: #ef4444; cursor: pointer; font-weight: 600;">Remove</button>
                </div>

                <div class="form-group" style="margin-bottom: 10px;">
                    <label style="font-size: 12px; font-weight: 600;">Question Type:</label>
                    <select class="form-control q-type" onchange="toggleQuestionTypeUI(${questionCounter})">
                        <option value="Multiple Choice" ${qType === 'Multiple Choice' ? 'selected' : ''}>Multiple Choice</option>
                        <option value="TrueOrFalse" ${qType === 'TrueOrFalse' ? 'selected' : ''}>True or False</option>
                        <option value="Identification" ${qType === 'Identification' ? 'selected' : ''}>Identification</option>
                        <option value="FillInBlank" ${qType === 'FillInBlank' ? 'selected' : ''}>Fill in the Blank</option>
                        <option value="Enumeration" ${qType === 'Enumeration' ? 'selected' : ''}>Enumeration</option>
                        <option value="Matching" ${qType === 'Matching' ? 'selected' : ''}>Matching Type</option>
                        <option value="Essay" ${qType === 'Essay' ? 'selected' : ''}>Essay</option>
                    </select>
                </div>

                <!-- TOEIC Media Attachments -->
                <div style="background: #f8fafc; border: 1px dashed #cbd5e1; border-radius: 8px; padding: 10px 12px; margin-bottom: 12px;">
                    <div style="font-size: 11px; text-transform: uppercase; color: #64748b; font-weight: 700; margin-bottom: 8px;">
                        Media Attachments (Optional)
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 10px;">
                        <div>
                            <label style="font-size: 12px;">Photograph / Diagram</label>
                            <input type="file" accept="image/*" class="form-control q-img-file" onchange="handleQuestionImageUpload(this, ${questionCounter})" />
                            <input type="hidden" class="q-img-data" value="${imgPath}" />
                        </div>
                        <div>
                            <label style="font-size: 12px;">Audio Passage</label>
                            <input type="file" accept="audio/*" class="form-control q-audio-file" onchange="handleQuestionAudioUpload(this, ${questionCounter})" />
                            <input type="hidden" class="q-audio-data" value="${audioPath}" />
                        </div>
                    </div>
                </div>

                <div class="form-group" style="margin-bottom: 10px;">
                    <input type="text" class="form-control q-text" placeholder="Question prompt..." value="${qText}" />
                </div>

                <!-- Dynamic Inputs Section -->
                <div id="qTypeSection_${questionCounter}">
                    <!-- Multiple Choice -->
                    <div class="sec-mc" style="display: ${qType === 'Multiple Choice' ? 'block' : 'none'};">
                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-bottom: 10px;">
                            <input type="text" class="form-control opt-a" placeholder="Option A" value="${optA}" />
                            <input type="text" class="form-control opt-b" placeholder="Option B" value="${optB}" />
                            <input type="text" class="form-control opt-c" placeholder="Option C" value="${optC}" />
                            <input type="text" class="form-control opt-d" placeholder="Option D" value="${optD}" />
                        </div>
                        <div>
                            <label><strong>Correct Choice:</strong></label>
                            <select class="form-control correct-opt" style="width: 120px; display: inline-block;">
                                <option value="A" ${correct === 'A' ? 'selected' : ''}>Option A</option>
                                <option value="B" ${correct === 'B' ? 'selected' : ''}>Option B</option>
                                <option value="C" ${correct === 'C' ? 'selected' : ''}>Option C</option>
                                <option value="D" ${correct === 'D' ? 'selected' : ''}>Option D</option>
                            </select>
                        </div>
                    </div>

                    <!-- True or False -->
                    <div class="sec-tf" style="display: ${qType === 'TrueOrFalse' ? 'block' : 'none'};">
                        <label><strong>Correct Answer:</strong></label>
                        <select class="form-control correct-tf" style="width: 120px; display: inline-block;">
                            <option value="True" ${correct === 'True' ? 'selected' : ''}>True</option>
                            <option value="False" ${correct === 'False' ? 'selected' : ''}>False</option>
                        </select>
                    </div>

                    <!-- Identification & Fill in Blank -->
                    <div class="sec-text" style="display: ${(qType === 'Identification' || qType === 'FillInBlank') ? 'block' : 'none'};">
                        <input type="text" class="form-control correct-text-ans" placeholder="Expected Correct Phrase / Keyword..." value="${textAns}" />
                    </div>

                    <!-- Enumeration -->
                    <div class="sec-enum" style="display: ${qType === 'Enumeration' ? 'block' : 'none'};">
                        <input type="text" class="form-control enum-ans" placeholder="Acceptable answers separated by commas (e.g. Red, Blue, Yellow)" value="${enumAns}" />
                    </div>

                    <!-- Matching Type -->
                    <div class="sec-matching" style="display: ${qType === 'Matching' ? 'block' : 'none'};">
                        <textarea class="form-control match-json" rows="3" placeholder='JSON Key-Value Pairs, e.g. {"Dog":"Animal", "Rose":"Flower"}'>${matchJson}</textarea>
                    </div>

                    <!-- Essay -->
                    <div class="sec-essay" style="display: ${qType === 'Essay' ? 'block' : 'none'};">
                        <p style="font-size: 12px; color: #6b7280; margin: 0;">Student will be provided a long text input. This question requires manual teacher grading.</p>
                    </div>
                </div>
            `;
            container.appendChild(card);
        }

        function toggleQuestionTypeUI(qId) {
            const card = document.getElementById('qCard_' + qId);
            if (!card) return;

            const qType = card.querySelector('.q-type').value;

            card.querySelector('.sec-mc').style.display = (qType === 'Multiple Choice') ? 'block' : 'none';
            card.querySelector('.sec-tf').style.display = (qType === 'TrueOrFalse') ? 'block' : 'none';
            card.querySelector('.sec-text').style.display = (qType === 'Identification' || qType === 'FillInBlank') ? 'block' : 'none';
            card.querySelector('.sec-enum').style.display = (qType === 'Enumeration') ? 'block' : 'none';
            card.querySelector('.sec-matching').style.display = (qType === 'Matching') ? 'block' : 'none';
            card.querySelector('.sec-essay').style.display = (qType === 'Essay') ? 'block' : 'none';
        }

        function prepareQuizJson() {
            const cards = document.querySelectorAll('.question-builder-card');
            const txtInstructions = document.getElementById('txtFormInstructions');
            const instructionsVal = txtInstructions ? txtInstructions.value.trim() : '';

            var questions = [];

            cards.forEach(function (card) {
                const typeSelect = card.querySelector('.q-type');
                const qInput = card.querySelector('.q-text');

                const qType = typeSelect ? typeSelect.value : 'Multiple Choice';
                const text = qInput ? qInput.value.trim() : '';

                const optA = card.querySelector('.opt-a') ? card.querySelector('.opt-a').value.trim() : '';
                const optB = card.querySelector('.opt-b') ? card.querySelector('.opt-b').value.trim() : '';
                const optC = card.querySelector('.opt-c') ? card.querySelector('.opt-c').value.trim() : '';
                const optD = card.querySelector('.opt-d') ? card.querySelector('.opt-d').value.trim() : '';

                let correct = 'A';
                if (qType === 'Multiple Choice') {
                    correct = card.querySelector('.correct-opt') ? card.querySelector('.correct-opt').value : 'A';
                } else if (qType === 'TrueOrFalse') {
                    correct = card.querySelector('.correct-tf') ? card.querySelector('.correct-tf').value : 'True';
                }

                const textAns = card.querySelector('.correct-text-ans') ? card.querySelector('.correct-text-ans').value.trim() : '';
                const enumAns = card.querySelector('.enum-ans') ? card.querySelector('.enum-ans').value.trim() : '';
                const matchJson = card.querySelector('.match-json') ? card.querySelector('.match-json').value.trim() : '';
                const imgPath = card.querySelector('.q-img-data') ? card.querySelector('.q-img-data').value : '';
                const audioPath = card.querySelector('.q-audio-data') ? card.querySelector('.q-audio-data').value : '';

                if (text) {
                    questions.push({
                        QuestionType: qType,
                        QuestionText: text,
                        OptionA: optA,
                        OptionB: optB,
                        OptionC: optC,
                        OptionD: optD,
                        CorrectAnswer: correct,
                        CorrectTextAnswer: textAns,
                        EnumerationAnswers: enumAns,
                        MatchingPairsJson: matchJson,
                        ImagePath: imgPath,
                        AudioPath: audioPath,
                        Instructions: instructionsVal
                    });
                }
            });

            if (questions.length === 0) {
                alert("Please add at least one complete question.");
                return false;
            }

            var hfQuizJson = document.getElementById('hfQuizJsonData');
            if (hfQuizJson) {
                hfQuizJson.value = JSON.stringify(questions);
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