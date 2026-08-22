<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="lms.seihaglobalacademy.com.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- Top Information Banner Block -->
    <div class="dashboard-info-banner">
        <i class="material-icons-outlined" style="font-size: 18px;">info</i>
        <span>Welcome to Seiha LMS! Please complete your enrollment configurations to view all custom student courses.</span>
    </div>

    <!-- Main Header Panel Layout -->
    <div class="dashboard-header-strip">
        <h1>Dashboard</h1>
        <div class="dashboard-header-actions">
            <!-- Add Course button (Teacher Only) -->
            <asp:LinkButton ID="btnCreateCourse" runat="server" CssClass="btn-add-course-nav teacher-only-control" OnClientClick="openAddCourseModal(); return false;" ToolTip="Add a Course">
                <i class="material-icons-outlined">add</i>
            </asp:LinkButton>

            <!-- Preview as Student Mode Trigger (Teacher Only) -->
            <asp:LinkButton ID="btnPreviewAsStudent" runat="server" CssClass="teacher-only-control" OnClick="btnPreviewAsStudent_Click" Style="color: var(--accent-blue, #2563eb); font-size: 13px; text-decoration: none; display: inline-flex; align-items: center; gap: 4px; margin-right: 8px;">
                <i class="material-icons-outlined" style="font-size: 16px;">visibility</i> Preview as Student
            </asp:LinkButton>

            <i class="material-icons-outlined" title="View Assignments">assignment</i>
            <i class="material-icons-outlined" title="Notifications">notifications_none</i>
            <i class="material-icons-outlined" title="Options">more_vert</i>
        </div>
    </div>

    <!-- Assignments In Progress Section -->
    <div class="assignments-section">
        <div class="assignments-header-row">
            <div class="assignments-title">Assignments in progress</div>
            <div class="filter-toggle-pill">
                <button type="button" class="filter-btn active">All</button>
                <button type="button" class="filter-btn">Manual Grading</button>
            </div>
        </div>

        <!-- Data Grid Table -->
        <div class="lms-data-table-container">
            <table class="lms-table">
                <thead>
                    <tr>
                        <th>Assignment Name &#9650;</th>
                        <th>Courses &#9650;</th>
                        <th><span style="text-decoration: underline;">End Date And Time &#9650;</span></th>
                        <th>Manual Grading &#9650;</th>
                        <th>Completed</th>
                        <th>Attempts Allowed</th>
                        <th style="text-align: right;">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptAssignments" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td><%# Eval("AssignmentName") %></td>
                                <td><%# Eval("CourseName") %></td>
                                <td><%# Eval("EndDateTime") %></td>
                                <td><%# Eval("ManualGrading") %></td>
                                <td><%# Eval("Completed") %></td>
                                <td><%# Eval("AttemptsAllowed") %></td>
                                <td style="text-align: right;">
                                    <asp:LinkButton ID="btnAction" runat="server" CommandName="View" CommandArgument='<%# Eval("AssignmentID") %>'>View</asp:LinkButton>
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                    <asp:PlaceHolder ID="phNoAssignments" runat="server" Visible="true">
                        <tr>
                            <td colspan="7" class="no-records-row">No records available</td>
                        </tr>
                    </asp:PlaceHolder>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Enrolled Courses Grid Section -->
    <div class="example-courses-section">
        <div class="courses-grid-header">Enrolled Courses</div>
        <div class="dashboard-grid">
            <asp:Repeater ID="rptDashboardCourses" runat="server">
                <ItemTemplate>
                    <!-- Clickable card wrapper leading to CourseDetails page -->
                    <a href='CourseDetails.aspx?courseId=<%# Container.ItemIndex %>' class="course-card-link" style="text-decoration: none; color: inherit;">
                        <div class="course-card">
                            <div class="card-banner">
                                <i class="material-icons-outlined card-menu-trigger">more_vert</i>
                            </div>
                            <div class="card-body">
                                <div class="course-title"><%# Eval("CourseName") %></div>
                            </div>
                        </div>
                    </a>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

    <!-- ==========================================================================
         ADD COURSE MODAL DIALOG OVERLAY
         ========================================================================== -->
    <div id="addCourseModal" class="lms-modal-overlay">
        <div class="lms-modal-card">
            <div class="lms-modal-header">
                <h3>Create New Course</h3>
                <button type="button" class="modal-close-btn" onclick="closeAddCourseModal();">&times;</button>
            </div>
            
            <div class="lms-modal-body">
                <div class="form-group">
                    <label for="txtCourseName">Course Title <span class="required-star">*</span></label>
                    <asp:TextBox ID="txtCourseName" runat="server" CssClass="form-control" placeholder="e.g. Life 1 OPTalk"></asp:TextBox>
                </div>
                
                <div class="form-group">
                    <label for="txtClassKey">Class Key / Code</label>
                    <asp:TextBox ID="txtClassKey" runat="server" CssClass="form-control" placeholder="e.g. 385VYXA2"></asp:TextBox>
                </div>

                <div class="form-group">
                    <label for="ddlCourseCategory">Category</label>
                    <asp:DropDownList ID="ddlCourseCategory" runat="server" CssClass="form-control">
                        <asp:ListItem Value="General">General Education</asp:ListItem>
                        <asp:ListItem Value="Language">Language & Communication</asp:ListItem>
                        <asp:ListItem Value="Technology">Technology & IT</asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>

            <div class="lms-modal-footer">
                <button type="button" class="btn-cancel" onclick="closeAddCourseModal();">Cancel</button>
                <asp:Button ID="btnSaveCourse" runat="server" Text="Create Course" CssClass="btn-submit" OnClick="btnSaveCourse_Click" />
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function openAddCourseModal() {
            var modal = document.getElementById("addCourseModal");
            if (modal) {
                modal.classList.add("show");
            }
        }

        function closeAddCourseModal() {
            var modal = document.getElementById("addCourseModal");
            if (modal) {
                modal.classList.remove("show");
            }
        }

        // Dismiss modal if user clicks outside the modal box
        window.addEventListener("click", function (event) {
            var modal = document.getElementById("addCourseModal");
            if (event.target === modal) {
                closeAddCourseModal();
            }
        });
    </script>
</asp:Content>