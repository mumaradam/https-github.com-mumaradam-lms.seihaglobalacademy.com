<%@ Page Title="Courses" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="lms.seihaglobalacademy.com.Courses" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Google Material Icons CDN -->
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Outlined" rel="stylesheet" />
    <style type="text/css">
        .courses-page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 15px;
            margin-bottom: 30px;
        }

        .courses-page-header h1 {
            font-weight: 700;
            font-size: 28px;
            color: #0f172a;
            margin: 0;
        }

        body:not(.light-mode) .courses-page-header h1 {
            color: #ffffff;
        }

        .btn-add-course-primary {
            background-color: var(--sga-blue-primary, #2563eb);
            color: #ffffff !important;
            padding: 9px 18px;
            font-size: 13.5px;
            font-weight: 600;
            border-radius: 8px;
            border: none;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            transition: background-color 0.2s ease;
        }

        .btn-add-course-primary:hover {
            background-color: var(--sga-blue-hover, #1d4ed8);
            color: #ffffff;
        }

        .courses-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 24px;
        }

        .course-card-wrapper {
            position: relative;
            text-decoration: none;
            color: inherit;
            display: block;
        }

        .course-card {
            background-color: #ffffff;
            border-radius: 12px;
            overflow: hidden;
            border: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
            height: 240px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
        }

        .course-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
        }

        body:not(.light-mode) .course-card {
            background-color: #383c40;
            border-color: #4b5056;
        }

        .card-banner {
            height: 130px;
            background-color: var(--sga-blue-primary, #2563eb);
            position: relative;
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
        }

        body:not(.light-mode) .card-banner {
            background-color: #575c62;
        }

        .card-menu-dropdown {
            position: absolute;
            top: 10px;
            right: 10px;
            z-index: 10;
        }

        .card-menu-trigger-btn {
            background: rgba(0, 0, 0, 0.4);
            border: none;
            border-radius: 50%;
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            color: #ffffff;
            transition: background 0.2s;
        }

        .card-menu-trigger-btn:hover {
            background: rgba(0, 0, 0, 0.7);
        }

        .card-dropdown-content {
            display: none;
            position: absolute;
            right: 0;
            top: 36px;
            background-color: #ffffff;
            min-width: 130px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            border-radius: 8px;
            z-index: 20;
            border: 1px solid var(--border-color);
            overflow: hidden;
        }

        body:not(.light-mode) .card-dropdown-content {
            background-color: #2a2d31;
            border-color: #4b5056;
        }

        .card-dropdown-content.show {
            display: block;
        }

        .card-dropdown-item {
            display: flex;
            align-items: center;
            gap: 8px;
            width: 100%;
            padding: 9px 14px;
            font-size: 13px;
            border: none;
            background: none;
            text-align: left;
            cursor: pointer;
            color: #334155;
            text-decoration: none;
        }

        body:not(.light-mode) .card-dropdown-item {
            color: #e2e8f0;
        }

        .card-dropdown-item:hover {
            background-color: #f1f5f9;
        }

        body:not(.light-mode) .card-dropdown-item:hover {
            background-color: #383c40;
        }

        .card-dropdown-item.delete-item {
            color: #ef4444;
        }

        .card-dropdown-item.delete-item:hover {
            background-color: #fee2e2;
        }

        body:not(.light-mode) .card-dropdown-item.delete-item:hover {
            background-color: #451a1a;
        }

        .card-body {
            padding: 14px 16px;
            background-color: #ffffff;
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        body:not(.light-mode) .card-body {
            background-color: #2a2d31;
        }

        .course-title {
            font-size: 15px;
            font-weight: 700;
            color: #0f172a;
            line-height: 1.3;
            margin-bottom: 6px;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        body:not(.light-mode) .course-title {
            color: #ffffff;
        }

        .course-meta-tags {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 12px;
            color: var(--text-muted, #64748b);
        }

        .course-tag {
            background-color: #f1f5f9;
            padding: 2px 8px;
            border-radius: 4px;
            font-weight: 500;
        }

        body:not(.light-mode) .course-tag {
            background-color: #383c40;
            color: #94a3b8;
        }

        .no-courses-placeholder {
            grid-column: 1 / -1;
            text-align: center;
            padding: 60px 20px;
            background: #ffffff;
            border-radius: 12px;
            border: 1px dashed var(--border-color);
            color: var(--text-muted, #94a3b8);
        }

        body:not(.light-mode) .no-courses-placeholder {
            background: #2a2d31;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="content-body">
        <!-- Courses Page Header -->
        <div class="courses-page-header">
            <div>
                <h1>Courses</h1>
            </div>
            <div>
                <button type="button" class="btn-add-course-primary" onclick="openCreateCourseModal();">
                    <i class="material-icons-outlined" style="font-size: 18px;">add</i> Create Course
                </button>
            </div>
        </div>

        <!-- Course Cards Widget Grid -->
        <div class="courses-grid">
            <asp:Repeater ID="rptCourses" runat="server" OnItemCommand="rptCourses_ItemCommand">
                <ItemTemplate>
                    <div class="course-card-wrapper">
                        <div class="course-card">
                            <!-- Banner Image or Color -->
                            <div class="card-banner" style='<%# Eval("CourseImage") != null ? "background-image: url(" + ResolveUrl(Eval("CourseImage").ToString()) + ");" : "" %>'>
                                <!-- Options Menu for Edit/Delete -->
                                <div class="card-menu-dropdown">
                                    <button type="button" class="card-menu-trigger-btn" onclick="toggleCourseMenu(event, '<%# "menu_" + Eval("CourseID") %>');" title="Course Options">
                                        <i class="material-icons-outlined" style="font-size: 20px;">more_vert</i>
                                    </button>
                                    <div id='<%# "menu_" + Eval("CourseID") %>' class="card-dropdown-content">
                                        <asp:LinkButton ID="btnEdit" runat="server" 
                                            CommandName="EditCourse" 
                                            CommandArgument='<%# Eval("CourseID") %>' 
                                            CssClass="card-dropdown-item">
                                            <i class="material-icons-outlined" style="font-size: 16px;">edit</i> Edit
                                        </asp:LinkButton>
                                        <asp:LinkButton ID="btnDelete" runat="server" 
                                            CommandName="DeleteCourse" 
                                            CommandArgument='<%# Eval("CourseID") %>' 
                                            CssClass="card-dropdown-item delete-item" 
                                            OnClientClick="return confirm('Are you sure you want to delete this course? This action cannot be undone.');">
                                            <i class="material-icons-outlined" style="font-size: 16px;">delete</i> Delete
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </div>

                            <!-- Card Body linking directly to Course Details -->
                            <a href='CourseDetails.aspx?courseId=<%# Eval("CourseID") %>' style="text-decoration: none; color: inherit; flex: 1; display: flex; flex-direction: column;">
                                <div class="card-body">
                                    <div>
                                        <div class="course-title"><%# Eval("CourseName") %></div>
                                    </div>
                                    <div class="course-meta-tags">
                                        <span class="course-tag"><%# Eval("CourseCode") %></span>
                                        <span>&bull;</span>
                                        <span><%# Eval("Term") %></span>
                                        <span>&bull;</span>
                                        <span><%# Eval("CourseType") %></span>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    <%# rptCourses.Items.Count == 0 ? "<div class='no-courses-placeholder'><i class='material-icons-outlined' style='font-size: 48px; opacity: 0.5; margin-bottom: 12px; display: block;'>school</i><p style='font-size: 15px; font-weight: 500;'>No courses found</p><p style='font-size: 13px; margin-top: 4px;'>Click 'Create Course' above to add your first course.</p></div>" : "" %>
                </FooterTemplate>
            </asp:Repeater>
        </div>
    </div>

    <!-- COURSE CREATE / EDIT MODAL DIALOG -->
    <div id="courseModal" class="lms-modal-overlay">
        <div class="lms-modal-card">
            <div class="lms-modal-header">
                <h3 id="modalTitle">Create New Course</h3>
                <button type="button" class="modal-close-btn" onclick="closeModal('courseModal');">&times;</button>
            </div>
            
            <div class="lms-modal-body">
                <asp:HiddenField ID="hfEditCourseID" runat="server" />

                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="txtCourseCode" style="display: block; font-size: 13px; font-weight: 600; margin-bottom: 6px;">Course Code</label>
                    <asp:TextBox ID="txtCourseCode" runat="server" CssClass="form-control" style="width: 100%; box-sizing: border-box;" placeholder="e.g. SC-101"></asp:TextBox>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="txtCourseName" style="display: block; font-size: 13px; font-weight: 600; margin-bottom: 6px;">Course Name <span style="color: #ef4444;">*</span></label>
                    <asp:TextBox ID="txtCourseName" runat="server" CssClass="form-control" style="width: 100%; box-sizing: border-box;" placeholder="e.g. TOEIC Preparation Course"></asp:TextBox>
                </div>
                
                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="txtCourseType" style="display: block; font-size: 13px; font-weight: 600; margin-bottom: 6px;">Course Type / Category</label>
                    <asp:TextBox ID="txtCourseType" runat="server" CssClass="form-control" style="width: 100%; box-sizing: border-box;" placeholder="e.g. Language, General, Business"></asp:TextBox>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="txtTerm" style="display: block; font-size: 13px; font-weight: 600; margin-bottom: 6px;">Term / Semester</label>
                    <asp:TextBox ID="txtTerm" runat="server" CssClass="form-control" style="width: 100%; box-sizing: border-box;" placeholder="e.g. Term 1, Spring 2026"></asp:TextBox>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="fileCourseBanner" style="display: block; font-size: 13px; font-weight: 600; margin-bottom: 6px;">Course Banner Image</label>
                    <asp:FileUpload ID="fileCourseBanner" runat="server" CssClass="form-control" style="width: 100%; box-sizing: border-box;" accept="image/*" />
                </div>
            </div>

            <div class="lms-modal-footer" style="display: flex; justify-content: flex-end; gap: 10px; padding: 16px 20px; border-top: 1px solid var(--border-color);">
                <button type="button" class="btn-cancel" onclick="closeModal('courseModal');" style="padding: 8px 16px; border-radius: 6px; border: 1px solid var(--border-color); background: transparent; color: inherit; cursor: pointer;">Cancel</button>
                <asp:Button ID="btnSaveCourse" runat="server" Text="Save Course" CssClass="btn-submit" OnClick="btnSaveCourse_Click" style="padding: 8px 18px; border-radius: 6px; background-color: var(--sga-blue-primary, #2563eb); color: #fff; border: none; font-weight: 600; cursor: pointer;" />
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function openModal(modalId) {
            var modal = document.getElementById(modalId);
            if (modal) {
                modal.classList.add("show");
            }
        }

        function closeModal(modalId) {
            var modal = document.getElementById(modalId);
            if (modal) {
                modal.classList.remove("show");
            }
        }

        function openCreateCourseModal() {
            var title = document.getElementById("modalTitle");
            if (title) title.innerText = "Create New Course";
            
            // Clear fields for new course
            var hfId = document.getElementById("<%= hfEditCourseID.ClientID %>");
            var txtCode = document.getElementById("<%= txtCourseCode.ClientID %>");
            var txtName = document.getElementById("<%= txtCourseName.ClientID %>");
            var txtType = document.getElementById("<%= txtCourseType.ClientID %>");
            var txtTerm = document.getElementById("<%= txtTerm.ClientID %>");
            
            if (hfId) hfId.value = "";
            if (txtCode) txtCode.value = "";
            if (txtName) txtName.value = "";
            if (txtType) txtType.value = "";
            if (txtTerm) txtTerm.value = "";
            
            openModal("courseModal");
        }

        function toggleCourseMenu(e, menuId) {
            e.stopPropagation();
            e.preventDefault();
            // Close all dropdowns
            var dropdowns = document.querySelectorAll(".card-dropdown-content");
            dropdowns.forEach(function (d) {
                if (d.id !== menuId) {
                    d.classList.remove("show");
                }
            });
            var targetMenu = document.getElementById(menuId);
            if (targetMenu) {
                targetMenu.classList.toggle("show");
            }
        }

        // Close dropdowns and modal on outside click
        window.addEventListener("click", function (event) {
            var dropdowns = document.querySelectorAll(".card-dropdown-content");
            dropdowns.forEach(function (d) {
                d.classList.remove("show");
            });

            var modal = document.getElementById("courseModal");
            if (event.target === modal) {
                closeModal("courseModal");
            }
        });
    </script>
</asp:Content>