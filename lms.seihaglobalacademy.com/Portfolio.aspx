<%@ Page Title="Portfolios" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Portfolio.aspx.cs" Inherits="lms.seihaglobalacademy.com.Portfolio" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <!-- FORCE BROWSER TO LOAD THE NEW CSS ENGINE -->
    <link href="/assets/css/Site.css?v=10" rel="stylesheet" type="text/css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Top Action Bar Header Panel -->
    <div class="profile-top-bar">
        <div class="profile-top-bar-left">
            <button type="button" class="profile-menu-burger-btn">
                <i class="material-icons-outlined">menu</i>
            </button>
            <span class="profile-breadcrumbs">JOHN CENA</span>
        </div>
        <!-- Right-aligned user identity pill -->
        <div class="profile-top-bar-right">
            <div class="user-identity-pill">
                <span class="identity-badge">JC</span>
                <span class="identity-name">JOHN CENA </span>
            </div>
        </div>
    </div>

    <!-- Main Dynamic Dual-Column Workspace Layout -->
    <div class="profile-workspace-layout">
        
        <!-- 1. Left Secondary Navigation Menu Panel -->
        <aside class="profile-side-menu">
            <ul class="profile-menu-links">
                <li><a href="Notifications.aspx">Notifications</a></li>
                <li><a href="Profile.aspx">Profile</a></li>
                <li><a href="Files.aspx">Files</a></li>
                <li><a href="Settings.aspx">Settings</a></li>
                <li><a href="Portfolio.aspx" class="active-link">Portfolio</a></li>
                <li><a href="Announcements.aspx">Global Announcements</a></li>
            </ul>
        </aside>

        <!-- 2. Portfolios Content Workspace -->
        <div class="profile-card-container">
            
            <!-- Header Block containing Title, Subtitle, and Creation Button -->
            <div class="portfolio-main-header">
                <div class="portfolio-header-text">
                    <h1 class="portfolio-title-text">Portfolios</h1>
                    <p class="portfolio-subtitle-text">Showcase your own, and view those assigned to you.</p>
                </div>
                <button type="button" class="create-portfolio-blue-btn">
                    <i class="material-icons-outlined">add</i>Create showcase portfolio
                </button>
            </div>

            <!-- Tab View Filters Sub-Navigation Toggle Strip -->
            <div class="portfolio-tab-strip">
                <a href="javascript:void(0);" class="portfolio-tab-item active-tab">Assigned</a>
                <a href="javascript:void(0);" class="portfolio-tab-item">Showcase</a>
            </div>

            <!-- Sort and Search Context Layout Bar -->
            <div class="portfolio-filter-utility-bar">
                <div class="utility-bar-left">
                    <i class="material-icons-outlined search-icon-placeholder">search</i>
                </div>
                <div class="utility-bar-right">
                    <span class="sort-label-text">Sort by:</span>
                    <select class="portfolio-sort-inline-select">
                        <option value="edited">Last edited</option>
                        <option value="created">Date created</option>
                        <option value="alphabetical">Alphabetical</option>
                    </select>
                </div>
            </div>

            <!-- Exact Rocket Empty State Container View -->
            <div class="portfolio-rocket-empty-state">
                <div class="rocket-graphic-wrapper">
                    <!-- Clean inline svg representation matching the target layout artwork -->
                    <svg class="rocket-svg" viewBox="0 0 200 200" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <!-- Tiny repair stars / sparks -->
                        <path d="M40 70 L45 75 M35 78 L38 82 M160 120 L165 125" stroke="#9aa0a6" stroke-width="2" stroke-linecap="round"/>
                        <!-- Main slanted rocket body -->
                        <g transform="translate(60, 40) rotate(15)">
                            <path d="M40 0 C65 20 80 50 80 80 L20 80 C20 50 35 20 40 0 Z" fill="#ffffff"/>
                            <path d="M20 80 L80 80 L90 100 L10 100 Z" fill="#ccd0d5"/>
                            <!-- Rocket wings -->
                            <path d="M10 60 L10 90 L30 80 Z" fill="#a0aec0"/>
                            <path d="M90 60 L90 90 L70 80 Z" fill="#a0aec0"/>
                            <!-- Window -->
                            <circle cx="50" cy="45" r="12" fill="#2d3748" stroke="#ffffff" stroke-width="3"/>
                        </g>
                        <!-- Tiny floating repair robots -->
                        <g transform="translate(45, 100)">
                            <circle cx="15" cy="15" r="8" fill="#e2e8f0"/>
                            <path d="M15 5 L15 10 M10 10 L20 10" stroke="#90cdf4" stroke-width="2"/>
                            <path d="M8 15 L2 18 M22 15 L28 12" stroke="#e2e8f0" stroke-width="2" stroke-linecap="round"/>
                        </g>
                        <g transform="translate(130, 115)">
                            <circle cx="15" cy="15" r="8" fill="#e2e8f0"/>
                            <path d="M15 5 L15 10 M10 10 L20 10" stroke="#90cdf4" stroke-width="2"/>
                            <path d="M8 15 L2 12 M22 15 L28 18" stroke="#e2e8f0" stroke-width="2" stroke-linecap="round"/>
                        </g>
                    </svg>
                </div>
                <p class="rocket-empty-notice-text">You haven't been assigned to any evaluation portfolios yet.</p>
            </div>

        </div>
    </div>
</asp:Content>