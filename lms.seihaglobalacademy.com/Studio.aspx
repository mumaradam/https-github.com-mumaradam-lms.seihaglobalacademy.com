<%@ Page Title="Studio" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Studio.aspx.cs" Inherits="lms.seihaglobalacademy.com.Studio" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Upper Tab Navigation */
        .studio-tab-navigation-bar {
            display: flex;
            gap: 25px;
            margin-bottom: 20px;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 10px;
        }
        .studio-sub-tab {
            color: var(--text-muted);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            position: relative;
        }
        .studio-sub-tab.active-tab {
            color: var(--text-light);
        }
        .studio-sub-tab.active-tab::after {
            content: '';
            position: absolute;
            bottom: -11px;
            left: 0;
            width: 100%;
            height: 2px;
            background-color: var(--accent-blue);
        }

        /* Main Workspace Splitting Layout */
        .studio-workspace-container {
            display: flex;
            gap: 40px;
            margin-top: 20px;
            align-items: flex-start;
        }

        /* Left Side Filter Sidebar Panel */
        .studio-left-panel {
            width: 220px;
            display: flex;
            flex-direction: column;
            gap: 15px;
            flex-shrink: 0;
        }
        .sort-label {
            font-size: 11px;
            text-transform: uppercase;
            color: var(--text-muted);
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        .studio-sort-dropdown {
            background-color: #383c40;
            color: var(--text-light);
            border: 1px solid var(--border-color);
            padding: 8px 12px;
            border-radius: 4px;
            font-size: 13px;
            outline: none;
            cursor: pointer;
            width: 100%;
        }

        .studio-side-menu {
            display: flex;
            flex-direction: column;
            gap: 4px;
            margin-top: 10px;
        }
        .studio-menu-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 10px 12px;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 13px;
            border-radius: 4px;
            cursor: pointer;
            transition: background 0.2s, color 0.2s;
        }
        .studio-menu-item i { font-size: 18px; }
        .studio-menu-item-left { display: flex; align-items: center; gap: 8px; }
        .studio-menu-item:hover {
            color: var(--text-light);
            background-color: rgba(255, 255, 255, 0.05);
        }
        .studio-menu-item.active-menu {
            background-color: rgba(3, 169, 244, 0.15);
            color: #fff;
            font-weight: 500;
        }

        /* Right Side Content Viewport Area */
        .studio-right-viewport {
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        /* Top Action Toolbar */
        .studio-action-toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
        }
        .studio-title-text {
            font-size: 28px;
            font-weight: 400;
            color: #fff;
        }
        .toolbar-right-actions {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .icon-action-btn {
            background: none;
            border: none;
            color: var(--text-muted);
            cursor: pointer;
            padding: 8px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .icon-action-btn:hover { color: var(--text-light); }

        /* Create Button Dropdown */
        .create-dropdown-btn {
            background-color: #2b7de9;
            color: #fff;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .create-dropdown-btn:hover { background-color: #1e6bcf; }

        /* Canvas Studio Empty State Artwork Placement */
        .studio-empty-state-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
            margin-top: 40px;
            padding: 20px;
        }
        
        /* Collection Grid of Artwork Clapper/Camera Icons mimicking screenshot */
        .artwork-icon-cluster {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 15px;
            margin-bottom: 25px;
            position: relative;
            height: 90px;
            width: 200px;
        }
        .art-icon {
            color: var(--text-muted);
            opacity: 0.5;
            position: absolute;
        }
        .art-clapper { font-size: 36px; top: 0; left: 20px; transform: rotate(-15deg); }
        .art-player { font-size: 44px; top: 15px; left: 55px; }
        .art-webcam { font-size: 32px; bottom: 0; right: 60px; }
        .art-camera { font-size: 34px; top: 10px; right: 15px; transform: rotate(10deg); }

        .empty-state-title {
            font-size: 20px;
            font-weight: 400;
            color: #fff;
            margin-bottom: 8px;
        }
        .empty-state-desc {
            font-size: 13px;
            color: var(--text-muted);
            margin-bottom: 20px;
            max-width: 300px;
            line-height: 1.5;
        }
        
        .add-videos-btn {
            background-color: transparent;
            color: var(--accent-blue);
            border: 1px solid var(--accent-blue);
            padding: 8px 20px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 500;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: background 0.2s, color 0.2s;
        }
        .add-videos-btn:hover {
            background-color: var(--accent-blue);
            color: #fff;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- Top Left Sub-Navigation Tab Links -->
    <div class="studio-tab-navigation-bar">
        <a class="studio-sub-tab active-tab">My Library</a>
        <a class="studio-sub-tab">Settings</a>
    </div>

    <!-- Layout Container Splitter Grid -->
    <div class="studio-workspace-container">
        
        <!-- Left Side Control Sidebar Panel -->
        <aside class="studio-left-panel">
            <div class="sort-label">Sort Collections by</div>
            <select class="studio-sort-dropdown">
                <option>Date: Most recent on top</option>
                <option>Name: Alphabetical</option>
            </select>

            <div class="studio-side-menu">
                <a class="studio-menu-item active-menu">
                    <span class="studio-menu-item-left"><i class="material-icons-outlined">person</i>My Library</span>
                    <i class="material-icons-outlined" style="font-size:16px;">add</i>
                </a>
                <a class="studio-menu-item">
                    <span class="studio-menu-item-left"><i class="material-icons-outlined">group</i>Shared Library</span>
                    <i class="material-icons-outlined" style="font-size:16px;">chevron_right</i>
                </a>
                <a class="studio-menu-item">
                    <span class="studio-menu-item-left"><i class="material-icons-outlined">archive</i>Archive</span>
                    <i class="material-icons-outlined" style="font-size:16px;">chevron_right</i>
                </a>
            </div>
        </aside>

        <!-- Right Side Content Viewport Area -->
        <main class="studio-right-viewport">
            
            <!-- Top Toolbar Actions Strip inside view -->
            <div class="studio-action-toolbar">
                <div class="studio-title-text">My Library</div>
                <div class="toolbar-right-actions">
                    <button type="button" class="icon-action-btn" title="View Info"><i class="material-icons-outlined">info</i></button>
                    <button type="button" class="icon-action-btn" title="Search"><i class="material-icons-outlined">search</i></button>
                    <button type="button" class="icon-action-btn" title="Filter"><i class="material-icons-outlined">tune</i> Filter</button>
                    <button type="button" class="create-dropdown-btn">Create <i class="material-icons-outlined" style="font-size:16px;">expand_more</i></button>
                </div>
            </div>

            <!-- Absolute Copy Empty Canvas Template State Display -->
            <div class="studio-empty-state-container">
                <div class="artwork-icon-cluster">
                    <i class="material-icons-outlined art-icon art-clapper">movie</i>
                    <i class="material-icons-outlined art-icon art-player">slideshow</i>
                    <i class="material-icons-outlined art-icon art-webcam">videocam</i>
                    <i class="material-icons-outlined art-icon art-camera">photo_camera</i>
                </div>
                <div class="empty-state-title">Nothing here yet!</div>
                <div class="empty-state-desc">Add some videos to your collection.</div>
                <button type="button" class="add-videos-btn"><i class="material-icons-outlined" style="font-size:16px;">add</i> Add Videos</button>
            </div>

        </main>
    </div>

</asp:Content>