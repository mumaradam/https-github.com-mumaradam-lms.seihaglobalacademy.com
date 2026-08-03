<%@ Page Title="Files" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Files.aspx.cs" Inherits="lms.seihaglobalacademy.com.Files" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <link href="/assets/css/Site.css?v=12" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Top Action Bar Header Panel -->
    <div class="profile-top-bar">
        <div class="profile-top-bar-left">
            <button type="button" class="profile-menu-burger-btn">
                <i class="material-icons-outlined">menu</i>
            </button>
            <span class="profile-breadcrumbs">TROWA ADRIAN &gt; Files</span>
        </div>
        <div class="profile-top-bar-right">
            <div class="user-identity-pill">
                <span class="identity-badge">TJ</span>
                <span class="identity-name">TROWA ADRIAN JAYME</span>
            </div>
        </div>
    </div>

    <!-- Main Dual-Column Workspace Layout -->
    <div class="profile-workspace-layout files-page-layout">
        
        <!-- Left Account Settings Sub-Navigation Menu -->
        <aside class="profile-side-menu">
            <ul class="profile-menu-links">
                <li><a href="Notifications.aspx">Notifications</a></li>
                <li><a href="Profile.aspx">Profile</a></li>
                <li><a href="Files.aspx" class="active-link">Files</a></li>
                <li><a href="Settings.aspx">Settings</a></li>
                <li><a href="Portfolio.aspx">Portfolio</a></li>
                <li><a href="Announcements.aspx">Global Announcements</a></li>
            </ul>
        </aside>

        <!-- Right Side File Manager Core Workspace Container -->
        <div class="profile-card-container file-manager-card">
            
            <!-- File Action Toolbar Row -->
            <div class="files-utility-toolbar">
                <div class="toolbar-left-group">
                    <div class="files-search-box">
                        <i class="material-icons-outlined search-icon">search</i>
                        <input type="text" placeholder="Search for files" class="search-input-field" />
                    </div>
                    <span class="selection-status-text">0 items selected</span>
                </div>
                
                <div class="toolbar-right-group">
                    <a href="javascript:void(0);" class="toolbar-link-btn">Switch to New Files Page</a>
                    <button type="button" class="toolbar-action-text-btn">
                        <i class="material-icons-outlined">add</i>Folder
                    </button>
                    <button type="button" class="files-upload-blue-btn">
                        <i class="material-icons-outlined">upload</i>Upload
                    </button>
                </div>
            </div>

            <!-- Nested Directory Structure & Grid Layout Wrapper -->
            <div class="file-explorer-grid">
                
                <!-- Left-hand File Directory Tree Panel -->
                <div class="file-directory-tree-panel">
                    <ul class="tree-root-list">
                        <li class="tree-node open">
                            <span class="tree-item-label expanded"><i class="material-icons-outlined folder-icon text-blue">folder_open</i>My Files</span>
                            <ul class="tree-sub-list">
                                <li class="tree-node"><span class="tree-item-label"><i class="material-icons-outlined arrow-icon">arrow_right</i><i class="material-icons-outlined folder-icon">folder</i>CH2</span></li>
                                <li class="tree-node"><span class="tree-item-label"><i class="material-icons-outlined arrow-icon">arrow_right</i><i class="material-icons-outlined folder-icon">folder</i>CH3_jayme</span></li>
                                <li class="tree-node"><span class="tree-item-label"><i class="material-icons-outlined arrow-icon">arrow_right</i><i class="material-icons-outlined folder-icon">folder</i>CH4</span></li>
                                <li class="tree-node"><span class="tree-item-label"><i class="material-icons-outlined arrow-icon">arrow_right</i><i class="material-icons-outlined folder-icon">folder</i>CH5</span></li>
                                <li class="tree-node"><span class="tree-item-label"><i class="material-icons-outlined arrow-icon">arrow_right</i><i class="material-icons-outlined folder-icon">folder</i>conversation attachments</span></li>
                                <li class="tree-node"><span class="tree-item-label"><i class="material-icons-outlined arrow-icon">arrow_right</i><i class="material-icons-outlined folder-icon">folder</i>profile pictures</span></li>
                                <li class="tree-node"><span class="tree-item-label"><i class="material-icons-outlined arrow-icon">arrow_right</i><i class="material-icons-outlined folder-icon">folder</i>Submissions</span></li>
                                <li class="tree-node"><span class="tree-item-label"><i class="material-icons-outlined arrow-icon">arrow_right</i><i class="material-icons-outlined folder-icon">folder</i>Trees</span></li>
                                <li class="tree-node"><span class="tree-item-label"><i class="material-icons-outlined arrow-icon">arrow_right</i><i class="material-icons-outlined folder-icon">folder</i>unfiled</span></li>
                            </ul>
                        </li>
                    </ul>
                </div>

                <!-- Right-hand File Roster Matrix Table View -->
                <div class="file-roster-table-panel">
                    <table class="file-roster-table">
                        <thead>
                            <tr>
                                <th style="width: 40%;">Name <i class="material-icons-outlined sort-arrow-icon">arrow_drop_up</i></th>
                                <th style="width: 15%;">Date Created</th>
                                <th style="width: 15%;">Date Modified</th>
                                <th style="width: 15%;">Modified By</th>
                                <th style="width: 10%;">Size</th>
                                <th style="width: 5%; text-align: center;"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <!-- Row 1: Document File -->
                            <tr>
                                <td><span class="file-name-cell-wrapper"><i class="material-icons-outlined file-row-icon">description</i> 1.txt</span></td>
                                <td>Mar 15, 2025</td>
                                <td>Mar 15, 2025</td>
                                <td><span class="modified-by-link">TROWA ADRIAN</span></td>
                                <td>3 KB</td>
                                <td class="check-cell"><i class="material-icons-outlined check-indicator">check_circle</i></td>
                            </tr>
                            <!-- Row 2: Folder -->
                            <tr>
                                <td><span class="file-name-cell-wrapper"><i class="material-icons-outlined file-row-icon folder-type">folder</i> CH2</span></td>
                                <td>Aug 19, 2024</td>
                                <td>--</td>
                                <td>--</td>
                                <td>--</td>
                                <td class="check-cell"><i class="material-icons-outlined check-indicator">check_circle</i></td>
                            </tr>
                            <!-- Row 3: Folder -->
                            <tr>
                                <td><span class="file-name-cell-wrapper"><i class="material-icons-outlined file-row-icon folder-type">folder</i> CH3_jayme</span></td>
                                <td>Aug 27, 2024</td>
                                <td>--</td>
                                <td>--</td>
                                <td>--</td>
                                <td class="check-cell"><i class="material-icons-outlined check-indicator">check_circle</i></td>
                            </tr>
                            <!-- Row 4: Folder -->
                            <tr>
                                <td><span class="file-name-cell-wrapper"><i class="material-icons-outlined file-row-icon folder-type">folder</i> CH4</span></td>
                                <td>Sep 24, 2024</td>
                                <td>--</td>
                                <td>--</td>
                                <td>--</td>
                                <td class="check-cell"><i class="material-icons-outlined check-indicator">check_circle</i></td>
                            </tr>
                            <!-- Row 5: Folder -->
                            <tr>
                                <td><span class="file-name-cell-wrapper"><i class="material-icons-outlined file-row-icon folder-type">folder</i> CH5</span></td>
                                <td>Sep 25, 2024</td>
                                <td>--</td>
                                <td>--</td>
                                <td>--</td>
                                <td class="check-cell"><i class="material-icons-outlined check-indicator">check_circle</i></td>
                            </tr>
                            <!-- Row 6: Folder -->
                            <tr>
                                <td><span class="file-name-cell-wrapper"><i class="material-icons-outlined file-row-icon folder-type">folder</i> conversation attachments</span></td>
                                <td>Aug 25, 2023</td>
                                <td>--</td>
                                <td>--</td>
                                <td>--</td>
                                <td class="check-cell"><i class="material-icons-outlined check-indicator">check_circle</i></td>
                            </tr>
                            <!-- Row 7: Folder -->
                            <tr>
                                <td><span class="file-name-cell-wrapper"><i class="material-icons-outlined file-row-icon folder-type">folder</i> profile pictures</span></td>
                                <td>Aug 25, 2023</td>
                                <td>--</td>
                                <td>--</td>
                                <td>--</td>
                                <td class="check-cell"><i class="material-icons-outlined check-indicator">check_circle</i></td>
                            </tr>
                            <!-- Row 8: Folder -->
                            <tr>
                                <td><span class="file-name-cell-wrapper"><i class="material-icons-outlined file-row-icon folder-type">folder</i> Submissions</span></td>
                                <td>Sep 17, 2023</td>
                                <td>--</td>
                                <td>--</td>
                                <td>--</td>
                                <td class="check-cell"><i class="material-icons-outlined check-indicator">check_circle</i></td>
                            </tr>
                            <!-- Row 9: Folder -->
                            <tr>
                                <td><span class="file-name-cell-wrapper"><i class="material-icons-outlined file-row-icon folder-type">folder</i> Trees</span></td>
                                <td>Mar 29, 2025</td>
                                <td>--</td>
                                <td>--</td>
                                <td>--</td>
                                <td class="check-cell"><i class="material-icons-outlined check-indicator">check_circle</i></td>
                            </tr>
                            <!-- Row 10: Image File -->
                            <tr>
                                <td><span class="file-name-cell-wrapper"><i class="material-icons-outlined file-row-icon image-type">image</i> UC logofinal.png</span></td>
                                <td>Oct 16, 2024</td>
                                <td>Oct 16, 2024</td>
                                <td><span class="modified-by-link">TROWA ADRIAN</span></td>
                                <td>51 KB</td>
                                <td class="check-cell"><i class="material-icons-outlined check-indicator">check_circle</i></td>
                            </tr>
                            <!-- Row 11: Folder -->
                            <tr>
                                <td><span class="file-name-cell-wrapper"><i class="material-icons-outlined file-row-icon folder-type">folder</i> unfiled</span></td>
                                <td>Aug 12, 2024</td>
                                <td>--</td>
                                <td>--</td>
                                <td>--</td>
                                <td class="check-cell"><i class="material-icons-outlined check-indicator">check_circle</i></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div>

        </div>
    </div>
</asp:Content>