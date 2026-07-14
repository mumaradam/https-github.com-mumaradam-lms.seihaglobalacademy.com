<%@ Page Title="Courses" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Courses.aspx.cs" Inherits="lms.seihaglobalacademy.com.Courses" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Top Navigation Header Styling */
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

        /* Course Matrix Dashboard Grid Layout */
        .courses-grid-matrix {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 30px;
        }

        /* Card Structural Base Container */
        .course-display-card {
            background-color: #383c40;
            border-radius: 8px;
            overflow: hidden;
            border: 1px solid var(--border-color);
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            transition: transform 0.2s, box-shadow 0.2s;
            display: flex;
            flex-direction: column;
        }
        .course-display-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 6px 15px rgba(0,0,0,0.3);
        }

        /* Top Accent Banner Block */
        .course-card-color-banner {
            height: 130px;
            position: relative;
            cursor: pointer;
        }
        .course-card-settings-trigger {
            position: absolute;
            top: 12px;
            right: 12px;
            color: #fff;
            opacity: 0.8;
            cursor: pointer;
            background: rgba(0,0,0,0.2);
            border-radius: 50%;
            padding: 4px;
            transition: opacity 0.2s;
        }
        .course-card-settings-trigger:hover { opacity: 1; }

        /* Mid-Section Content Text Layout */
        .course-card-text-workspace {
            padding: 20px;
            background-color: #212427;
            flex: 1;
            cursor: pointer;
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

        /* Lower Activity Link Icon Bar */
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
        .course-action-icon-link:hover {
            color: var(--accent-blue);
        }
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
        <asp:Repeater ID="rptAllCoursesList" runat="server">
            <ItemTemplate>
                <div class="course-display-card">
                    <div class="course-card-color-banner" style="background-color: <%# Eval("ColorHex") %>;">
                        <i class="material-icons-outlined course-card-settings-trigger">more_vert</i>
                    </div>
                    
                    <div class="course-card-text-workspace">
                        <div class="course-card-code-tag" style="color: <%# Eval("ColorHex") %>;"><%# Eval("CourseCode") %></div>
                        <div class="course-card-fullname"><%# Eval("CourseName") %></div>
                        <div class="course-card-term-label"><%# Eval("Term") %></div>
                    </div>

                    <div class="course-card-action-tray">
                        <a href="#" class="course-action-icon-link" title="Announcements">
                            <i class="material-icons-outlined">campaign</i>
                        </a>
                        <a href="#" class="course-action-icon-link" title="Assignments">
                            <i class="material-icons-outlined">assignment</i>
                        </a>
                        <a href="#" class="course-action-icon-link" title="Discussions">
                            <i class="material-icons-outlined">forum</i>
                        </a>
                        <a href="#" class="course-action-icon-link" title="Files">
                            <i class="material-icons-outlined">folder</i>
                        </a>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

</asp:Content>