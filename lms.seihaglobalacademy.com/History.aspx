<%@ Page Title="Activity History" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="History.aspx.cs" Inherits="lms.seihaglobalacademy.com.History" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .history-container {
            max-width: 850px;
            margin: 0 auto;
        }
        .history-header-strip {
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 15px;
            margin-bottom: 35px;
        }
        .history-header-strip h1 { font-weight: 400; font-size: 32px; color: var(--text-light); }

        /* Timeline Structural Rail Layout */
        .timeline-wrapper {
            position: relative;
            padding-left: 35px;
            margin-left: 15px;
            border-left: 2px solid var(--border-color);
            display: flex;
            flex-direction: column;
            gap: 40px;
        }

        /* Timeline Date Node Group Header */
        .timeline-day-group {
            position: relative;
        }
        .timeline-day-node {
            position: absolute;
            left: -42px;
            top: 2px;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background-color: var(--bg-dark);
            border: 3px solid var(--accent-blue);
        }
        .timeline-day-title {
            font-size: 14px;
            font-weight: 600;
            color: var(--accent-blue);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 15px;
        }

        /* Activity Content Cards */
        .timeline-cards-stack {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        .activity-log-card {
            background-color: #212427;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            padding: 20px;
            display: flex;
            gap: 20px;
            align-items: center;
            transition: transform 0.15s, background-color 0.15s;
            cursor: pointer;
        }
        .activity-log-card:hover {
            transform: translateX(4px);
            background-color: #26292c;
        }

        .activity-icon-box {
            width: 44px;
            height: 44px;
            background-color: #383c40;
            border-radius: 4px;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid rgba(255, 255, 255, 0.02);
        }
        .activity-icon-box i { font-size: 24px; }

        .activity-meta-details {
            display: flex;
            flex-direction: column;
            gap: 2px;
        }
        .activity-action-title {
            font-size: 15px;
            font-weight: 500;
            color: #fff;
        }
        .activity-context-path {
            font-size: 12px;
            color: var(--text-muted);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="history-container">
        <div class="history-header-strip">
            <h1>Activity Audit History</h1>
        </div>

        <!-- Vertical Timeline Rail -->
        <div class="timeline-wrapper">
            
            <!-- Group 1: Today -->
            <div class="timeline-day-group">
                <div class="timeline-day-node"></div>
                <div class="timeline-day-title">Today - July 11, 2026</div>
                
                <div class="timeline-cards-stack">
                    <div class="activity-log-card">
                        <div class="activity-icon-box"><i class="material-icons-outlined">dashboard</i></div>
                        <div class="activity-meta-details">
                            <div class="activity-action-title">Dashboard Overview Navigation</div>
                            <div class="activity-context-path">Seiha LMS &gt; Core Portal</div>
                        </div>
                    </div>
                    <div class="activity-log-card">
                        <div class="activity-icon-box"><i class="material-icons-outlined">storage</i></div>
                        <div class="activity-meta-details">
                            <div class="activity-action-title">Database Efficiency Tracker Setup</div>
                            <div class="activity-context-path">Courses &gt; Advanced ASP.NET Shell &gt; Lectures</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Group 2: Yesterday -->
            <div class="timeline-day-group">
                <div class="timeline-day-node"></div>
                <div class="timeline-day-title">Yesterday - July 10, 2026</div>
                
                <div class="timeline-cards-stack">
                    <div class="activity-log-card">
                        <div class="activity-icon-box"><i class="material-icons-outlined">assignment_turned_in</i></div>
                        <div class="activity-meta-details">
                            <div class="activity-action-title">Submission of Lab Module 2</div>
                            <div class="activity-context-path">Courses &gt; Database Structures &gt; Assignments</div>
                        </div>
                    </div>
                    <div class="activity-log-card">
                        <div class="activity-icon-box"><i class="material-icons-outlined">description</i></div>
                        <div class="activity-meta-details">
                            <div class="activity-action-title">Reviewing Grading Policy Guidelines</div>
                            <div class="activity-context-path">Courses &gt; Japanese Language Basics &gt; Documentation</div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

</asp:Content>