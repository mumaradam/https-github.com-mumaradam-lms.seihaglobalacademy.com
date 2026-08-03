<%@ Page Title="Profile" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="lms.seihaglobalacademy.com.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- Inline cache-busting link for local page overrides if needed -->
    <link href="/assets/css/Site.css?v=3" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Top Action Bar Header Panel -->
    <div class="profile-top-bar">
        <button type="button" class="profile-menu-burger-btn">
            <i class="material-icons-outlined">menu</i>
        </button>
        <span class="profile-breadcrumbs">TROWA ADRIAN's Profile</span>
    </div>

    <!-- Main Dynamic Dual-Column Workspace Layout -->
    <div class="profile-workspace-layout">
        
        <!-- 1. Left Secondary Navigation Menu Panel -->
        <aside class="profile-side-menu">
            <ul class="profile-menu-links">
                <li><a href="Notifications.aspx">Notifications</a></li>
                <li><a href="Profile.aspx" class="active-link">Profile</a></li>
                <li><a href="Files.aspx">Files</a></li>
                <li><a href="Settings.aspx">Settings</a></li>
                <li><a href="Portfolio.aspx">Portfolio</a></li>
                <li><a href="Announcements.aspx">Global Announcements</a></li>
            </ul>
        </aside>

        <!-- 2. Profile Display Container Grid -->
        <div class="profile-card-container">
            <h2 class="profile-main-title">User Profile</h2>
            
            <div class="profile-grid">
                <!-- Left Avatar/Photo Upload Stream Column -->
                <div class="profile-avatar-column">
                    <div class="profile-placeholder-avatar">
                        <i class="material-icons-outlined">person</i>
                    </div>
                    <a href="javascript:void(0);" class="edit-avatar-action-link">
                        <i class="material-icons-outlined">edit</i>Edit Profile Picture
                    </a>
                </div>

                <!-- Right Profile Details Stream Column -->
                <div class="profile-details-column">
                    <!-- Title Row containing name and action button -->
                    <div class="profile-title-row">
                        <h1 class="profile-display-fullname">JOHN CENA </h1>
                        <a href="Settings.aspx" class="edit-profile-btn">
                            <i class="material-icons-outlined">edit</i>Edit Profile
                        </a>
                    </div>

                    <!-- Contact Details Section -->
                    <div class="profile-details-section">
                        <h3>Contact</h3>
                        <p class="empty-section-notice">
                            No registered services, you can add some on the <a href="Settings.aspx" class="settings-inline-link">settings</a> page.
                        </p>
                    </div>

                    <!-- Biography Section -->
                    <div class="profile-details-section">
                        <h3>Biography</h3>
                        <p class="empty-section-notice">No biography has been added</p>
                    </div>

                    <!-- Links Section -->
                    <div class="profile-details-section">
                        <h3>Links</h3>
                        <p class="empty-section-notice">No links have been added</p>
                    </div>
                </div>
            </div>

        </div>
    </div>
</asp:Content>