<%@ Page Title="Courses" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="lms.seihaglobalacademy.com.Courses" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Google Material Icons CDN -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet" />
    <style>
        .course-card-banner {
            height: 125px;
            border-radius: 12px 12px 0 0;
            position: relative;
            background-color: #059669;
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }
        .card-actions {
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
        .card-actions a {
            color: #ffffff !important;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            cursor: pointer;
        }
        .course-card {
            width: 270px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            overflow: hidden;
            margin-bottom: 20px;
            position: relative;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .course-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.12);
        }

        /* Modal Backdrop Overlay */
        .lms-modal-backdrop {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.75);
            z-index: 1000;
        }

        /* LIGHT MODE DEFAULT STYLING */
        #courseModal .lms-modal-card {
            background-color: #ffffff;
            padding: 24px;
            border-radius: 8px;
            width: 400px;
            margin: 80px auto;
            position: relative;
            box-shadow: 0 10px 25px rgba(0,0,0,0.3);
            color: #111827;
        }
        #courseModal h3,
        #courseModal #modalTitle,
        #courseModal label {
            color: #111827 !important;
        }
        #courseModal .form-control {
            width: 100%;
            padding: 8px;
            border: 1px solid #d1d5db;
            border-radius: 4px;
            box-sizing: border-box;
            background-color: #ffffff !important;
            color: #111827 !important;
        }
        #courseModal .btn-cancel-modal {
            padding: 8px 16px;
            border: 1px solid #d1d5db;
            background: #ffffff !important;
            color: #374151 !important;
            border-radius: 4px;
            cursor: pointer;
        }

        /* --- DARK MODE OVERRIDES --- */

        /* Modal Container */
        .dark #courseModal .lms-modal-card,
        .dark-mode #courseModal .lms-modal-card,
        [data-theme='dark'] #courseModal .lms-modal-card,
        body[class*='dark'] #courseModal .lms-modal-card {
            background-color: #1e293b !important;
            border: 1px solid #334155 !important;
            color: #ffffff !important;
        }

        /* Titles and Field Labels */
        .dark #courseModal h3, .dark #courseModal #modalTitle, .dark #courseModal label,
        .dark-mode #courseModal h3, .dark-mode #courseModal #modalTitle, .dark-mode #courseModal label,
        [data-theme='dark'] #courseModal h3, [data-theme='dark'] #courseModal #modalTitle, [data-theme='dark'] #courseModal label,
        body[class*='dark'] #courseModal h3, body[class*='dark'] #courseModal #modalTitle, body[class*='dark'] #courseModal label {
            color: #ffffff !important;
        }

        /* Form Inputs */
        .dark #courseModal .form-control,
        .dark-mode #courseModal .form-control,
        [data-theme='dark'] #courseModal .form-control,
        body[class*='dark'] #courseModal .form-control {
            background-color: #0f172a !important;
            border: 1px solid #334155 !important;
            color: #ffffff !important;
        }

        /* Cancel Button */
        .dark #courseModal .btn-cancel-modal,
        .dark-mode #courseModal .btn-cancel-modal,
        [data-theme='dark'] #courseModal .btn-cancel-modal,
        body[class*='dark'] #courseModal .btn-cancel-modal {
            background-color: #334155 !important;
            color: #ffffff !important;
            border: 1px solid #475569 !important;
        }

        /* Native OS/Browser Dark Mode Preference Fallback */
        @media (prefers-color-scheme: dark) {
            #courseModal .lms-modal-card { background-color: #1e293b !important; border: 1px solid #334155 !important; }
            #courseModal h3, #courseModal #modalTitle, #courseModal label { color: #ffffff !important; }
            #courseModal .form-control { background-color: #0f172a !important; border: 1px solid #334155 !important; color: #ffffff !important; }
            #courseModal .btn-cancel-modal { background-color: #334155 !important; color: #ffffff !important; border: 1px solid #475569 !important; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px;">
        <h2>All Courses</h2>
        <button type="button" class="btn-submit" onclick="resetCourseModal(); openModal('courseModal');" style="padding: 8px 16px; background: #2563eb; color: white; border: none; border-radius: 6px; cursor: pointer;">
            Create New Course
        </button>
    </div>

    <!-- Course Cards Grid Repeater -->
    <div style="display: flex; flex-wrap: wrap; gap: 20px;">
        <asp:Repeater ID="rptCourses" runat="server" OnItemCommand="rptCourses_ItemCommand">
            <ItemTemplate>
                <div class="course-card">
                    
                    <!-- Floating Edit / Delete Actions -->
                    <div class="card-actions">
                        <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditCourse" CommandArgument='<%# Eval("CourseID") %>' ToolTip="Edit Course">
                            <i class="material-icons-outlined" style="font-size: 18px;">edit</i>
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteCourse" CommandArgument='<%# Eval("CourseID") %>' OnClientClick="return confirm('Delete this course?');" ToolTip="Delete Course">
                            <i class="material-icons-outlined" style="font-size: 18px;">delete</i>
                        </asp:LinkButton>
                    </div>

                    <!-- Main Card Click Area -->
                    <a href='<%# "CourseDetails.aspx?courseId=" + Eval("CourseID") %>' style="text-decoration: none; color: inherit; display: block;">
                        <!-- Banner Container -->
                        <div class="course-card-banner" 
                             style='<%# string.IsNullOrEmpty(Eval("CourseImage") as string) 
                                        ? "background-color: #059669;" 
                                        : "background-image: url(" + ResolveUrl(Eval("CourseImage").ToString()) + ");" %>'>
                        </div>

                        <!-- Content Area -->
                        <div style="padding: 14px 16px 16px 16px;">
                            <div style="color: #059669; font-weight: 600; font-size: 11.5px; letter-spacing: 0.5px;"><%# Eval("CourseCode") %></div>
                            <div style="font-size: 15px; font-weight: 700; margin-top: 2px; color: #111827;"><%# Eval("CourseName") %></div>
                        </div>
                    </a>

                    <!-- Quick Links Footer -->
                    <div style="border-top: 1px solid #f3f4f6; padding: 8px 16px; display: flex; gap: 14px; color: #6b7280; background: #fafafa;">
                        <a href='<%# "CourseDetails.aspx?courseId=" + Eval("CourseID") + "&tab=Announcements" %>' title="Announcements" style="color: #6b7280; text-decoration: none;">
                            <i class="material-icons-outlined" style="font-size: 19px;">campaign</i>
                        </a>
                        <a href='<%# "CourseDetails.aspx?courseId=" + Eval("CourseID") + "&tab=Assignments" %>' title="Assignments" style="color: #6b7280; text-decoration: none;">
                            <i class="material-icons-outlined" style="font-size: 19px;">assignment</i>
                        </a>
                        <a href='<%# "CourseDetails.aspx?courseId=" + Eval("CourseID") + "&tab=Quizzes" %>' title="Tests & Quizzes" style="color: #6b7280; text-decoration: none;">
                            <i class="material-icons-outlined" style="font-size: 19px;">assignment_turned_in</i>
                        </a>
                    </div>

                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <!-- Create / Edit Course Modal -->
    <div id="courseModal" class="lms-modal-backdrop" style="display: none;">
        <div class="lms-modal-card">
            <asp:HiddenField ID="hfEditCourseID" runat="server" ClientIDMode="Static" />
            
            <div style="margin-bottom: 16px;">
                <h3 id="modalTitle">Create New Course</h3>
            </div>
            
            <div>
                <div style="margin-bottom: 12px;">
                    <label>Course Code</label>
                    <asp:TextBox ID="txtCourseCode" runat="server" ClientIDMode="Static" CssClass="form-control"></asp:TextBox>
                </div>
                <div style="margin-bottom: 12px;">
                    <label>Course Name</label>
                    <asp:TextBox ID="txtCourseName" runat="server" ClientIDMode="Static" CssClass="form-control"></asp:TextBox>
                </div>
                <div style="margin-bottom: 12px;">
                    <label>Course Type</label>
                    <asp:TextBox ID="txtCourseType" runat="server" ClientIDMode="Static" CssClass="form-control"></asp:TextBox>
                </div>
                <div style="margin-bottom: 12px;">
                    <label>Term</label>
                    <asp:TextBox ID="txtTerm" runat="server" ClientIDMode="Static" CssClass="form-control"></asp:TextBox>
                </div>
                <div style="margin-bottom: 16px;">
                    <label>Course Banner Image (Optional)</label>
                    <asp:FileUpload ID="fileCourseBanner" runat="server" accept="image/*" CssClass="form-control" />
                </div>
            </div>
            
            <div style="display: flex; justify-content: flex-end; gap: 8px; margin-top: 16px;">
                <button type="button" class="btn-cancel-modal" onclick="closeModal('courseModal');">Cancel</button>
                <asp:Button ID="btnSaveCourse" runat="server" Text="Save Course" OnClick="btnSaveCourse_Click" Style="padding: 8px 16px; background: #059669; color: white; border: none; border-radius: 4px; cursor: pointer;" />
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function openModal(id) {
            var el = document.getElementById(id);
            if (el) el.style.display = 'block';
        }
        function closeModal(id) {
            var el = document.getElementById(id);
            if (el) el.style.display = 'none';
        }
        function resetCourseModal() {
            document.getElementById('hfEditCourseID').value = '';
            document.getElementById('txtCourseCode').value = '';
            document.getElementById('txtCourseName').value = '';
            document.getElementById('txtCourseType').value = '';
            document.getElementById('txtTerm').value = '';
            document.getElementById('modalTitle').innerText = 'Create New Course';
        }
    </script>
</asp:Content>