<%@ Page Title="Help Desk" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Help.aspx.cs" Inherits="lms.seihaglobalacademy.com.Help" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .help-page-container {
            max-width: 900px;
            margin: 0 auto;
        }
        .help-page-header {
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 15px;
            margin-bottom: 40px;
        }
        .help-page-header h1 { font-weight: 400; font-size: 32px; color: var(--text-light); }

        /* 2-Column Resource Grid Layout */
        .help-resource-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
            gap: 25px;
        }
        .help-main-card {
            background-color: #383c40;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            padding: 24px;
            display: flex;
            gap: 20px;
            transition: transform 0.2s, background-color 0.2s;
            cursor: pointer;
        }
        .help-main-card:hover {
            transform: translateY(-2px);
            background-color: #404448;
        }
        body.light-mode .help-main-card:hover {
            background-color: #f9fafb !important;
        }
        
        .help-card-icon-box {
            color: var(--accent-blue);
            display: flex;
            align-items: flex-start;
        }
        .help-card-icon-box i { font-size: 36px; }

        .help-card-info { display: flex; flex-direction: column; gap: 6px; }
        .help-title-link { font-size: 18px; font-weight: 500; color: #fff; text-decoration: none; }
        .help-desc-text { font-size: 13px; color: var(--text-muted); line-height: 1.5; }
        body.light-mode .help-title-link { color: #2d3135 !important; }
        body.light-mode .help-desc-text { color: #626970 !important; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="help-page-container">
        <div class="help-page-header">
            <h1>Support & Knowledge Guides</h1>
        </div>

        <div class="help-resource-grid">
            
            <div class="help-main-card">
                <div class="help-card-icon-box"><i class="material-icons-outlined">search</i></div>
                <div class="help-card-info">
                    <div class="help-title-link">Search the Knowledge Base</div>
                    <div class="help-desc-text">Browse documentation articles covering configuration steps for student courses, assignments, and scheduling tools.</div>
                </div>
            </div>

            <div class="help-main-card">
                <div class="help-card-icon-box"><i class="material-icons-outlined">bug_report</i></div>
                <div class="help-card-info">
                    <div class="help-title-link">Report an Application Issue</div>
                    <div class="help-desc-text">Encountered an error or loading glitch inside a dashboard panel? Submit a technical bug log directly to system engineers.</div>
                </div>
            </div>

            <div class="help-main-card">
                <div class="help-card-icon-box"><i class="material-icons-outlined">school</i></div>
                <div class="help-card-info">
                    <div class="help-title-link">Student Training Portal</div>
                    <div class="help-desc-text">Watch walk-through videos to quickly master grading metrics, portfolio tracking workflows, and submission operations.</div>
                </div>
            </div>

            <div class="help-main-card">
                <div class="help-card-icon-box"><i class="material-icons-outlined">contact_support</i></div>
                <div class="help-card-info">
                    <div class="help-title-link">Contact Support Administration</div>
                    <div class="help-desc-text">Reach out directly to an administrator for custom credentials setup, password changes, or project namespace modifications.</div>
                </div>
            </div>

        </div>
    </div>

</asp:Content>