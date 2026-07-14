<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="lms.seihaglobalacademy.com.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Top Informational Notification Banner */
        .dashboard-info-banner {
            background-color: #e8f0fe;
            border: 1px solid #d2e3fc;
            color: #1967d2;
            padding: 12px 20px;
            border-radius: 4px;
            margin-bottom: 25px;
            font-size: 13.5px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        /* Header Layout Wrapper with Controls */
        .dashboard-header-strip {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 15px;
            margin-bottom: 30px;
        }
        .dashboard-header-strip h1 { font-weight: 400; font-size: 32px; color: var(--text-light); }
        
        .dashboard-header-actions {
            display: flex;
            align-items: center;
            gap: 16px;
            color: var(--text-muted);
        }
        .dashboard-header-actions i, .theme-toggle-btn {
            font-size: 20px;
            cursor: pointer;
            transition: color 0.15s;
            background: none;
            border: none;
            color: var(--text-muted);
            display: flex;
            align-items: center;
        }
        .dashboard-header-actions i:hover, .theme-toggle-btn:hover { color: var(--text-light); }

        /* Canvas Style Empty State Banner */
        .dashboard-empty-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            margin: 40px auto 60px auto;
            max-width: 400px;
        }
        
        .empty-vector-art {
            width: 140px;
            height: 70px;
            margin-bottom: 20px;
            position: relative;
            opacity: 0.4;
        }
        .vector-curve {
            width: 100%;
            height: 100%;
            border-top: 2px solid #fff;
            border-radius: 50% 50% 0 0 / 100% 100% 0 0;
            transform: scaleY(0.4) translateY(40px);
        }
        body.light-mode .vector-curve { border-top-color: #2d3135; }
        .vector-dot-ring {
            width: 16px;
            height: 16px;
            border: 2px dashed #fff;
            border-radius: 50%;
            position: absolute;
            top: 5px;
            right: 25px;
        }
        body.light-mode .vector-dot-ring { border-color: #2d3135; }
        .vector-cross {
            position: absolute;
            left: 20px;
            top: 25px;
            color: #fff;
            font-size: 18px;
        }
        body.light-mode .vector-cross { color: #2d3135; }

        .empty-title { font-size: 18px; font-weight: 500; color: #fff; margin-bottom: 6px; }
        .empty-desc { font-size: 13px; color: var(--text-muted); margin-bottom: 12px; }
        .empty-links-row { font-size: 13px; }
        .empty-links-row a { color: var(--accent-blue); text-decoration: none; margin: 0 6px; }
        .empty-links-row a:hover { text-decoration: underline; }

        /* Lower Grid Container for Example Cards */
        .example-courses-section {
            border-top: 1px solid rgba(255,255,255,0.05);
            padding-top: 30px;
        }
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }

        /* Flat Gray Variant Example Course Cards */
        .course-card {
            background-color: #383c40;
            border-radius: 6px;
            overflow: hidden;
            border: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
            height: 200px;
        }
        .card-banner {
            height: 140px;
            background-color: #575c62;
            position: relative;
        }
        body.light-mode .card-banner { background-color: #e5e7eb; }
        .card-menu-trigger {
            position: absolute;
            top: 12px;
            right: 12px;
            color: #fff;
            opacity: 0.7;
            cursor: pointer;
        }
        body.light-mode .card-menu-trigger { color: #2d3135; }
        .card-menu-trigger:hover { opacity: 1; }
        
        .card-body {
            padding: 15px;
            background-color: #2a2d31;
            flex: 1;
            display: flex;
            align-items: center;
        }
        .course-title { font-size: 13.5px; font-weight: 500; color: var(--text-light); }
    </style>
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
            <!-- Day/Night Toggle Button Component Hook -->
            <button type="button" class="theme-toggle-btn" onclick="togglePlatformTheme();" title="Toggle Light/Dark Theme">
                <i class="material-icons-outlined" id="themeIcon">light_mode</i>
            </button>

            <i class="material-icons-outlined" title="Add Content">add</i>
            <i class="material-icons-outlined" title="View Assignments">assignment</i>
            <i class="material-icons-outlined" title="Notifications">notifications_none</i>
            <i class="material-icons-outlined" title="Options">more_vert</i>
        </div>
    </div>

    <!-- No Course Assignments Center Empty State Panel Layout -->
    <div class="dashboard-empty-state">
        <div class="empty-vector-art">
            <div class="vector-cross">✦</div>
            <div class="vector-curve"></div>
            <div class="vector-dot-ring"></div>
        </div>
        <div class="empty-title">No Course Assignments Found</div>
        <div class="empty-desc">Looks like your core courses aren't configured yet.</div>
        <div class="empty-links-row">
            <a href="Courses.aspx">Configure Courses</a> | <a href="#">View Course Catalog</a>
        </div>
    </div>

    <!-- Example Course Cards Grid Section -->
    <div class="example-courses-section">
        <div class="dashboard-grid">
            <asp:Repeater ID="rptDashboardCourses" runat="server">
                <ItemTemplate>
                    <div class="course-card">
                        <div class="card-banner">
                            <i class="material-icons-outlined card-menu-trigger">more_vert</i>
                        </div>
                        <div class="card-body">
                            <div class="course-title"><%# Eval("CourseName") %></div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>

    <!-- THEME MANAGER PERSISTENCE CONTROLLER -->
    <script type="text/javascript">
        function updateIcon() {
            var icon = document.getElementById("themeIcon");
            if (!icon) return;
            if (document.body.classList.contains("light-mode")) {
                icon.innerText = "dark_mode";
                icon.style.color = "#2d3135";
            } else {
                icon.innerText = "light_mode";
                icon.style.color = "";
            }
        }

        function togglePlatformTheme() {
            if (document.body.classList.contains("light-mode")) {
                document.body.classList.remove("light-mode");
                localStorage.setItem("lms-theme", "dark");
            } else {
                document.body.classList.add("light-mode");
                localStorage.setItem("lms-theme", "light");
            }
            updateIcon();
        }

        // Initialize state on render load execution
        updateIcon();
    </script>
</asp:Content>