<%@ Page Title="Settings" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Settings.aspx.cs" Inherits="lms.seihaglobalacademy.com.Settings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="/assets/css/Site.css?v=13" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Top Action Bar Header Panel -->
    <div class="profile-top-bar">
        <div class="profile-top-bar-left">
            <button type="button" class="profile-menu-burger-btn">
                <i class="material-icons-outlined">menu</i>
            </button>
            <span class="profile-breadcrumbs">TROWA ADRIAN &gt; Settings</span>
        </div>
        <div class="profile-top-bar-right">
            <div class="user-identity-pill">
                <span class="identity-badge">TJ</span>
                <span class="identity-name">TROWA ADRIAN JAYME</span>
            </div>
        </div>
    </div>

    <!-- Main Workspace Layout Grid -->
    <div class="profile-workspace-layout settings-page-layout">
        
        <!-- Left Account Sidebar Sub-Navigation Links Panel -->
        <aside class="profile-side-menu">
            <ul class="profile-menu-links">
                <li><a href="Notifications.aspx">Notifications</a></li>
                <li><a href="Profile.aspx">Profile</a></li>
                <li><a href="Files.aspx">Files</a></li>
                <li><a href="Settings.aspx" class="active-link">Settings</a></li>
                <li><a href="Portfolio.aspx">Portfolio</a></li>
                <li><a href="Announcements.aspx">Global Announcements</a></li>
            </ul>
        </aside>

        <!-- Right Core Split Workspace Area -->
        <div class="settings-split-grid">
            
            <!-- A. CORE DETAIL FIELDS & SERVICE ATTACHMENTS (Left Panel) -->
            <div class="settings-core-details-panel">
                <div class="settings-user-header">
                    <i class="material-icons-outlined settings-avatar-icon">account_box</i>
                    <h2 class="settings-display-title">TROWA ADRIAN's Settings</h2>
                </div>

                <!-- Structured Detail Readout Block -->
                <div class="settings-profile-metadata">
                    <div class="meta-row"><span class="meta-label">Full Name</span><div class="meta-value"><strong>TROWA ADRIAN JAYME</strong><span class="meta-sub">This name will be used for grading.</span></div></div>
                    <div class="meta-row"><span class="meta-label">Display Name</span><div class="meta-value"><strong>TROWA ADRIAN</strong><span class="meta-sub">People will see this name in discussions, messages and comments.</span></div></div>
                    <div class="meta-row"><span class="meta-label">Sortable Name</span><div class="meta-value"><strong>JAYME, TROWA ADRIAN</strong><span class="meta-sub">This name appears in sorted lists.</span></div></div>
                    <div class="meta-row"><span class="meta-label">Language</span><div class="meta-value">System Default (English (United States))</div></div>
                    <div class="meta-row"><span class="meta-label">Time Zone</span><div class="meta-value">Philippines<span class="meta-sub-alert">Maintenance window: 1st and 3rd Thursday of the month from 2:05am to 4:05am (Wednesday from 6:05pm to 8:05pm UTC). Next window: Thu Jul 2, 2026 from 2:05am to 4:05am</span></div></div>
                </div>

                <!-- Web Services Management Section -->
                <div class="settings-section-divider">
                    <h3>Web Services</h3>
                    <p class="section-desc-text">Canvas can make your life a lot easier by tying itself in with the web tools you already use. Click any of the services in "Other Services" to see what we mean.</p>
                    <div class="checkbox-option-row">
                        <input type="checkbox" id="chkShowServices" checked />
                        <label for="chkShowServices">Let fellow course/group members see which services I've linked to my profile</label>
                    </div>
                    
                    <div class="services-split-columns">
                        <div>
                            <h4>Registered Services</h4>
                            <p class="empty-notice-text">No Registered Services</p>
                        </div>
                        <div>
                            <h4>Other Services</h4>
                            <p class="section-desc-text" style="margin-bottom:8px;">Click any service below to register:</p>
                            <div class="service-registration-links">
                                <a href="javascript:void(0);" class="service-link"><i class="material-icons-outlined text-blue">cloud_queue</i> Google Drive</a>
                                <a href="javascript:void(0);" class="service-link"><i class="material-icons-outlined text-blue">bookmarks</i> Diigo</a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Approved Integrations Token Control Grid Table -->
                <div class="settings-section-divider">
                    <h3>Approved Integrations:</h3>
                    <p class="section-desc-text" style="margin-bottom:12px;">These are the third-party applications you have authorized to access the Canvas site on your behalf:</p>
                    
                    <table class="integrations-matrix-table">
                        <thead>
                            <tr>
                                <th>App</th>
                                <th>Status</th>
                                <th>Purpose</th>
                                <th>Dates</th>
                                <th>Details</th>
                                <th>Remove</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td><strong>Rollcall</strong></td>
                                <td><span class="badge-status-active">active</span></td>
                                <td></td>
                                <td><span class="meta-sub">Expires: never<br />Last Used: Nov 1, 2024 at 11:15pm</span></td>
                                <td><a href="javascript:void(0);" class="inline-blue-link">details</a></td>
                                <td><i class="material-icons-outlined action-trash-icon">delete</i></td>
                            </tr>
                            <tr>
                                <td><strong>Canvas for Android</strong></td>
                                <td><span class="badge-status-active">active</span></td>
                                <td>2312DRA50G</td>
                                <td><span class="meta-sub">Expires: never<br />Last Used: Dec 23, 2025 at 11:19pm</span></td>
                                <td><a href="javascript:void(0);" class="inline-blue-link">details</a></td>
                                <td><i class="material-icons-outlined action-trash-icon">delete</i></td>
                            </tr>
                        </tbody>
                    </table>
                    <button type="button" class="new-token-btn"><i class="material-icons-outlined">add</i> New Access Token</button>
                </div>
            </div>

            <!-- B. CONTACT PIPELINES & ACTION CONTROLS (Right Sidebar Panel) -->
            <div class="settings-sidebar-controls-panel">
                <h3>Ways to Contact</h3>
                
                <!-- Email Management Column Blocks -->
                <div class="contact-sub-block">
                    <h4>Email Addresses</h4>
                    <div class="contact-item-row active-item">
                        <span class="contact-value-text">trowa.adrian@gmail.com</span>
                        <i class="material-icons-outlined primary-star-icon">star</i>
                    </div>
                    <button type="button" class="add-contact-method-btn"><i class="material-icons-outlined">add</i> Email Address</button>
                </div>

                <!-- Push Device Management Column Blocks -->
                <div class="contact-sub-block" style="margin-top: 20px;">
                    <h4>Other Contacts</h4>
                    <table class="contact-table-matrix">
                        <thead>
                            <tr>
                                <th>Type</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <div class="contact-row-flex">
                                        <div>
                                            <span class="contact-value-text" style="display:block;">For All Devices</span>
                                            <span class="meta-sub">push</span>
                                        </div>
                                        <i class="material-icons-outlined action-trash-icon">delete</i>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <button type="button" class="add-contact-method-btn"><i class="material-icons-outlined">add</i> Contact Method</button>
                </div>

                <!-- Main Context Execution Action Buttons Stack -->
                <div class="settings-action-button-stack">
                    <button type="button" class="sidebar-action-btn"><i class="material-icons-outlined">edit</i> Edit Settings</button>
                    <button type="button" class="sidebar-action-btn"><i class="material-icons-outlined">download</i> Download Submissions</button>
                </div>
            </div>

        </div>
    </div>
</asp:Content>