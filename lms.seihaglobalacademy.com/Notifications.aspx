<%@ Page Title="Notification Settings" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Notifications.aspx.cs" Inherits="lms.seihaglobalacademy.com.Notifications" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="/assets/css/Site.css?v=11" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Top Action Bar Header Panel -->
    <div class="profile-top-bar">
        <div class="profile-top-bar-left">
            <button type="button" class="profile-menu-burger-btn">
                <i class="material-icons-outlined">menu</i>
            </button>
            <span class="profile-breadcrumbs">TROWA ADRIAN &gt; Notification Settings</span>
        </div>
        <div class="profile-top-bar-right">
            <div class="user-identity-pill">
                <span class="identity-badge">TJ</span>
                <span class="identity-name">TROWA ADRIAN JAYME</span>
            </div>
        </div>
    </div>

    <!-- Main Dual-Column Workspace Layout -->
    <div class="profile-workspace-layout">
        
        <!-- Left Account Settings Sub-Navigation Menu -->
        <aside class="profile-side-menu">
            <ul class="profile-menu-links">
                <li><a href="Notifications.aspx" class="active-link">Notifications</a></li>
                <li><a href="Profile.aspx">Profile</a></li>
                <li><a href="Files.aspx">Files</a></li>
                <li><a href="Settings.aspx">Settings</a></li>
                <li><a href="Portfolio.aspx">Portfolio</a></li>
                <li><a href="Announcements.aspx">Global Announcements</a></li>
            </ul>
        </aside>

        <!-- Right Side Configuration Workspace -->
        <div class="profile-card-container">
            <h1 class="portfolio-title-text" style="font-size: 26px;">Notification Settings</h1>
            
            <!-- Global Info Delivery Banners -->
            <div class="notification-info-banner">
                <i class="material-icons-outlined banner-info-icon">info</i>
                <p>Account-level notifications apply to all courses. Notifications for individual courses can be changed within each course and will override these notifications.</p>
                <button type="button" class="banner-close-btn">&times;</button>
            </div>

            <div class="notification-info-banner">
                <i class="material-icons-outlined banner-info-icon">schedule</i>
                <p>Daily notifications will be delivered around 6pm. Weekly notifications will be delivered Saturday between 1pm and 3pm.</p>
                <button type="button" class="banner-close-btn">&times;</button>
            </div>

            <!-- Context Filter Row Dropdown -->
            <div class="notification-scope-selector-row">
                <span class="scope-label">Settings for</span>
                <select class="notification-scope-dropdown">
                    <option value="account">Account</option>
                </select>
            </div>

            <!-- Configuration Options Delivery Preferences Matrix Table -->
            <div class="notification-matrix-container">
                <table class="notification-matrix-table">
                    <thead>
                        <tr>
                            <th class="col-activity-title">Course Activities</th>
                            <th class="col-channel">
                                <span class="channel-title">Email</span>
                                <span class="channel-subtitle">trowa.adrian@gmail.com</span>
                            </th>
                            <th class="col-channel">
                                <span class="channel-title">Push Notification</span>
                                <span class="channel-subtitle">For All Devices</span>
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Course Activities Category Block -->
                        <tr class="row-activity-item">
                            <td>Due Date <span class="desc-subtext">Assignment due date change</span></td>
                            <td class="cell-status"><i class="material-icons-outlined icon-weekly">calendar_view_week</i></td>
                            <td class="cell-status"><i class="material-icons-outlined icon-weekly">calendar_view_week</i></td>
                        </tr>
                        <tr class="row-activity-item">
                            <td>Grading Policies <span class="desc-subtext">Course grading policy change</span></td>
                            <td class="cell-status"><i class="material-icons-outlined icon-weekly">calendar_view_week</i></td>
                            <td class="cell-status"><i class="material-icons-outlined icon-disabled">block</i></td>
                        </tr>
                        <tr class="row-activity-item group-header">
                            <td colspan="3">Course Content <span class="desc-subtext">Change to course content:</span></td>
                        </tr>
                        <tr class="row-activity-item sub-bullet">
                            <td>• Page content</td>
                            <td class="cell-status"><i class="material-icons-outlined icon-disabled">notifications_off</i></td>
                            <td class="cell-status"><i class="material-icons-outlined icon-alert">notifications</i></td>
                        </tr>
                        <tr class="row-activity-item sub-bullet">
                            <td>• Quiz content</td>
                            <td class="cell-status"></td>
                            <td class="cell-status"></td>
                        </tr>
                        <tr class="row-activity-item sub-bullet">
                            <td>• Assignment content</td>
                            <td class="cell-status"></td>
                            <td class="cell-status"></td>
                        </tr>
                        <tr class="row-activity-item">
                            <td>Files <span class="desc-subtext">New file added to your course</span></td>
                            <td class="cell-status"><i class="material-icons-outlined icon-disabled">notifications_off</i></td>
                            <td class="cell-status"><i class="material-icons-outlined icon-disabled">notifications_off</i></td>
                        </tr>

                        <!-- Announcement Category Block -->
                        <tr class="row-category-divider">
                            <td colspan="3">Announcement</td>
                        </tr>
                        <tr class="row-activity-item">
                            <td>New Announcement <span class="desc-subtext">New announcement in your course</span></td>
                            <td class="cell-status"><i class="material-icons-outlined icon-active">check_circle</i></td>
                            <td class="cell-status"><i class="material-icons-outlined icon-active">check_circle</i></td>
                        </tr>
                        <tr class="row-activity-item group-header">
                            <td colspan="3">Announcement Created By You</td>
                        </tr>
                        <tr class="row-activity-item sub-bullet">
                            <td>• Announcements posted by you</td>
                            <td class="cell-status"><i class="material-icons-outlined icon-disabled">notifications_off</i></td>
                            <td class="cell-status"><i class="material-icons-outlined icon-disabled">notifications_off</i></td>
                        </tr>
                        <tr class="row-activity-item sub-bullet">
                            <td>• Replies to announcements you've created</td>
                            <td class="cell-status"></td>
                            <td class="cell-status"></td>
                        </tr>

                        <!-- Grading Category Block -->
                        <tr class="row-category-divider">
                            <td colspan="3">Grading</td>
                        </tr>
                        <tr class="row-warning-card">
                            <td colspan="3">
                                <div class="grading-warning-box">
                                    <i class="material-icons-outlined">warning</i>
                                    <span>Includes scores when alerting about grades. If your email is not an institutional email this means sensitive content will be sent outside of the institution.</span>
                                </div>
                            </td>
                        </tr>
                        <tr class="row-activity-item">
                            <td>Grading <span class="desc-subtext">Assignment submission grade entered/changed</span></td>
                            <td class="cell-status"><i class="material-icons-outlined icon-active">check_circle</i></td>
                            <td class="cell-status"><i class="material-icons-outlined icon-active">check_circle</i></td>
                        </tr>
                        <tr class="row-activity-item">
                            <td>Grade Weight Changed</td>
                            <td class="cell-status"></td>
                            <td class="cell-status"></td>
                        </tr>

                        <!-- Invitation Category Block -->
                        <tr class="row-category-divider">
                            <td colspan="3">Invitation</td>
                        </tr>
                        <tr class="row-activity-item">
                            <td>Invitation <span class="desc-subtext">Invitation for:</span></td>
                            <td class="cell-status"><i class="material-icons-outlined icon-active">check_circle</i></td>
                            <td class="cell-status"><i class="material-icons-outlined icon-active">check_circle</i></td>
                        </tr>
                        <tr class="row-activity-item sub-bullet">
                            <td>• Web conference</td>
                            <td class="cell-status"></td>
                            <td class="cell-status"></td>
                        </tr>
                        <tr class="row-activity-item sub-bullet">
                            <td>• Group</td>
                            <td class="cell-status"></td>
                            <td class="cell-status"></td>
                        </tr>
                        <tr class="row-activity-item sub-bullet">
                            <td>• Collaboration</td>
                            <td class="cell-status"></td>
                            <td class="cell-status"></td>
                        </tr>
                    </tbody>
                </table>
            </div>

        </div>
    </div>
</asp:Content>