<%@ Page Title="Courses" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="lms.seihaglobalacademy.com.Courses" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .courses-header-strip {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 15px;
            margin-bottom: 35px;
        }
        .courses-header-strip h1 { font-weight: 400; font-size: 32px; color: var(--text-light); }
        
        .courses-toolbar-controls {
            display: flex;
            gap: 12px;
        }
        .course-filter-select {
            background-color: #383c40;
            color: var(--text-light);
            border: 1px solid var(--border-color);
            padding: 8px 14px;
            border-radius: 4px;
            font-size: 13px;
            outline: none;
            cursor: pointer;
        }

        .courses-grid-matrix {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 30px;
        }

        .course-display-card {
            background-color: #383c40;
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid var(--border-color);
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            transition: transform 0.2s, box-shadow 0.2s;
            display: flex;
            flex-direction: column;
            position: relative;
        }
        .course-display-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.3);
        }

        .course-card-color-banner {
            height: 130px;
            position: relative;
            cursor: pointer;
        }

        .course-card-teacher-actions {
            position: absolute;
            top: 10px;
            right: 10px;
            display: flex;
            gap: 6px;
            background: rgba(0, 0, 0, 0.4);
            padding: 4px 8px;
            border-radius: 20px;
            backdrop-filter: blur(4px);
        }

        .course-action-btn {
            background: none;
            border: none;
            color: #ffffff;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            opacity: 0.85;
            transition: opacity 0.2s, color 0.2s;
            padding: 2px;
        }
        .course-action-btn:hover { opacity: 1; }
        .course-action-btn.edit:hover { color: #60a5fa; }
        .course-action-btn.delete:hover { color: #f87171; }

        .course-card-text-workspace {
            padding: 20px;
            background-color: #212427;
            flex: 1;
            cursor: pointer;
            text-decoration: none;
            display: block;
        }
        .course-card-code-tag {
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        .course-card-fullname {
            font-size: 16px;
            font-weight: 400;
            color: var(--text-light);
            line-height: 1.4;
        }
        .course-card-term-label {
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 8px;
        }

        .course-card-action-tray {
            background-color: #1e2226;
            border-top: 1px solid var(--border-color);
            padding: 12px 20px;
            display: flex;
            gap: 18px;
        }
        .course-action-icon-link {
            color: var(--text-muted);
            text-decoration: none;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: color 0.2s;
        }
        .course-action-icon-link:hover { color: var(--accent-blue); }
        .course-action-icon-link i { font-size: 22px; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="courses-header-strip">
        <h1>All Courses</h1>
        <div class="courses-toolbar-controls">
            <select class="course-filter-select">
                <option>All Terms</option>
                <option>First Semester 2026</option>
            </select>
        </div>
    </div>

    <div class="courses-grid-matrix">
        <asp:Repeater ID="rptAllCoursesList" runat="server" OnItemCommand="rptAllCoursesList_ItemCommand" OnItemDataBound="rptAllCoursesList_ItemDataBound">
            <ItemTemplate>
                <div class="course-display-card">
                    
                    <!-- Color Banner (Navigates to Course Details) -->
                    <a href='<%# "CourseDetails.aspx?courseId=" + Eval("CourseID") %>' class="course-card-color-banner" style="background-color: <%# Eval("ColorHex") %>;"></a>

                    <!-- Teacher Edit/Delete Controls -->
                    <asp:PlaceHolder ID="phTeacherCourseActions" runat="server">
                        <div class="course-card-teacher-actions">
                            <asp:LinkButton ID="btnEditCourse" runat="server" CommandName="EditCourse" CommandArgument='<%# Eval("CourseID") %>' CssClass="course-action-btn edit" ToolTip="Edit Course">
                                <i class="material-icons-outlined" style="font-size: 18px;">edit</i>
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnDeleteCourse" runat="server" CommandName="DeleteCourse" CommandArgument='<%# Eval("CourseID") %>' CssClass="course-action-btn delete" ToolTip="Delete Course" OnClientClick="return confirm('Are you sure you want to delete this course?');">
                                <i class="material-icons-outlined" style="font-size: 18px;">delete</i>
                            </asp:LinkButton>
                        </div>
                    </asp:PlaceHolder>

                    <!-- Card Body Clickable Link -->
                    <a href='<%# "CourseDetails.aspx?courseId=" + Eval("CourseID") %>' class="course-card-text-workspace">
                        <div class="course-card-code-tag" style="color: <%# Eval("ColorHex") %>;"><%# Eval("CourseCode") %></div>
                        <div class="course-card-fullname"><%# Eval("CourseName") %></div>
                        <div class="course-card-term-label"><%# Eval("Term") %></div>
                    </a>

                    <!-- Action Quick Links -->
                    <div class="course-card-action-tray">
                        <a href='<%# "CourseDetails.aspx?courseId=" + Eval("CourseID") %>' class="course-action-icon-link" title="Announcements">
                            <i class="material-icons-outlined">campaign</i>
                        </a>
                        <a href='<%# "CourseDetails.aspx?courseId=" + Eval("CourseID") %>' class="course-action-icon-link" title="Assignments">
                            <i class="material-icons-outlined">assignment</i>
                        </a>
                        <a href='<%# "CourseDetails.aspx?courseId=" + Eval("CourseID") %>' class="course-action-icon-link" title="Quizzes">
                            <i class="material-icons-outlined">assignment_turned_in</i>
                        </a>
                    </div>

                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <!-- EDIT COURSE MODAL -->
    <div id="editCourseModal" class="lms-modal-overlay">
        <div class="lms-modal-card">
            <div class="lms-modal-header">
                <h3>Edit Course</h3>
                <button type="button" class="modal-close-btn" onclick="closeModal('editCourseModal');">&times;</button>
            </div>
            <div class="lms-modal-body">
                <asp:HiddenField ID="hfEditCourseID" runat="server" />
                <div class="form-group">
                    <label>Course Title <span class="required-star">*</span></label>
                    <asp:TextBox ID="txtEditCourseName" runat="server" CssClass="form-control"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label>Description</label>
                    <asp:TextBox ID="txtEditCourseDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control"></asp:TextBox>
                </div>
            </div>
            <div class="lms-modal-footer">
                <button type="button" class="btn-cancel" onclick="closeModal('editCourseModal');">Cancel</button>
                <asp:Button ID="btnUpdateCourse" runat="server" Text="Update Course" CssClass="btn-submit" OnClick="btnUpdateCourse_Click" />
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
    </script>
</asp:Content>