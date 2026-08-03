<%@ Page Title="Global Announcements" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Announcements.aspx.cs" Inherits="lms.seihaglobalacademy.com.Announcements" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Links to our unified stylesheet -->
    <link href="/assets/css/Site.css?v=4" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Top Action Bar Header Panel -->
    <div class="profile-top-bar">
        <button type="button" class="profile-menu-burger-btn">
            <i class="material-icons-outlined">menu</i>
        </button>
        <span class="profile-breadcrumbs">TROWA ADRIAN's Profile &gt; Global Announcements</span>
    </div>

    <!-- Main Dual-Column Workspace Layout -->
    <div class="profile-workspace-layout">
        
        <!-- 1. Left Secondary Navigation Menu Panel -->
        <aside class="profile-side-menu">
            <ul class="profile-menu-links">
                <li><a href="Notifications.aspx">Notifications</a></li>
                <li><a href="Profile.aspx">Profile</a></li>
                <li><a href="Files.aspx">Files</a></li>
                <li><a href="Settings.aspx">Settings</a></li>
                <li><a href="Portfolio.aspx">Portfolio</a></li>
                <li><a href="Announcements.aspx" class="active-link">Global Announcements</a></li>
            </ul>
        </aside>

        <!-- 2. Global Announcements Feed Container -->
        <div class="profile-card-container">
            <h2 class="profile-main-title">Global Announcements</h2>
            
            <div class="announcements-feed">
                <!-- Announcement Card 1 -->
                <div class="announcement-card critical">
                    <div class="announcement-card-header">
                        <div class="announcement-meta-badge urgent">Urgent</div>
                        <span class="announcement-date">July 15, 2026</span>
                    </div>
                    <h3 class="announcement-subject">Scheduled System Maintenance & Security Upgrades</h3>
                    <p class="announcement-body">
                        Please be advised that the Seiha Global Academy LMS platform will undergo scheduled maintenance on <strong>Saturday, July 18, 2026, from 11:00 PM to 3:00 AM PHT</strong>. During this window, database services and active course studios will be temporarily inaccessible. Please save all pending assignment drafts prior to this timeframe.
                    </p>
                    <div class="announcement-sender">
                        <i class="material-icons-outlined">admin_panel_settings</i>
                        <span>Posted by: System Administrator</span>
                    </div>
                </div>

                <!-- Announcement Card 2 -->
                <div class="announcement-card">
                    <div class="announcement-card-header">
                        <div class="announcement-meta-badge normal">Academy Update</div>
                        <span class="announcement-date">July 10, 2026</span>
                    </div>
                    <h3 class="announcement-subject">Enrollment Phase for Summer Intensive Modules Now Open</h3>
                    <p class="announcement-body">
                        The registration cycle for our upcoming intensive language modules and special academy masterclasses has officially launched. Students interested in acceleration programs should review the syllabus details on the <strong>Courses Catalog</strong> tab and submit enrollment applications by next Friday.
                    </p>
                    <div class="announcement-sender">
                        <i class="material-icons-outlined">school</i>
                        <span>Posted by: Academic Registrar</span>
                    </div>
                </div>

                <!-- Empty State (Hidden unless feed is empty) -->
                <div class="announcements-empty-state" style="display: none;">
                    <i class="material-icons-outlined">campaign</i>
                    <h3>No Announcements Found</h3>
                    <p>There are currently no academy-wide announcements posted on your feed.</p>
                </div>
            </div>

        </div>
    </div>
</asp:Content>