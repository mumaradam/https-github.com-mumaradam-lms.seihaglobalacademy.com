<%@ Page Title="Calendar" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Calendar.aspx.cs" Inherits="lms.seihaglobalacademy.com.Calendar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Overall Page Split-Pane Framework */
        .calendar-workspace-split {
            display: flex;
            gap: 25px;
            height: calc(100vh - 140px);
            align-items: flex-start;
        }

        /* Left Side: Dynamic Core Monthly Grid Body Container */
        .calendar-grid-container {
            flex: 1;
            background-color: #26292c;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            padding: 20px;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        /* Top Toolbar Panel Elements */
        .cal-toolbar-strip {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 15px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            margin-bottom: 15px;
        }
        .cal-toolbar-left, .cal-toolbar-right {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .cal-header-title {
            font-size: 18px;
            font-weight: 400;
            color: #fff;
            margin-left: 8px;
        }
        
        /* Action Button Toggles Style UI elements */
        .cal-action-btn {
            background-color: transparent;
            color: var(--text-light);
            border: 1px solid var(--border-color);
            padding: 6px 14px;
            font-size: 13px;
            cursor: pointer;
            border-radius: 4px;
            transition: background 0.15s;
        }
        .cal-action-btn:hover { background-color: rgba(255, 255, 255, 0.05); }
        
        .cal-view-toggle-group {
            display: flex;
            background-color: #383c40;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            overflow: hidden;
        }
        .toggle-btn {
            background: none;
            border: none;
            color: var(--text-muted);
            padding: 6px 14px;
            font-size: 13px;
            cursor: pointer;
        }
        .toggle-btn.active-view {
            background-color: #4f545c;
            color: #fff;
        }
        .plus-icon-btn {
            background: none;
            border: none;
            color: var(--text-muted);
            cursor: pointer;
            padding: 0 8px;
            display: flex;
            align-items: center;
        }
        .plus-icon-btn:hover { color: #fff; }

        /* The Calendar Grid Matrix framework */
        .cal-main-grid-panel {
            display: flex;
            flex-direction: column;
            flex: 1;
        }
        .cal-weekdays-header {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            text-align: center;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 8px;
            margin-bottom: 4px;
        }
        .cal-weekday-tag {
            font-size: 11px;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
        }

        .cal-cells-matrix {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            grid-auto-rows: 1fr;
            flex: 1;
            gap: 1px;
            background-color: var(--border-color);
            border: 1px solid var(--border-color);
            border-radius: 2px;
        }
        .cal-day-cell {
            background-color: #212427;
            padding: 8px;
            display: flex;
            flex-direction: column;
            position: relative;
        }
        .cell-num-label {
            font-size: 12px;
            color: var(--text-muted);
            align-self: flex-end;
        }
        .cal-day-cell.outside-month {
            background-color: #1a1c1e;
        }
        .cal-day-cell.outside-month .cell-num-label {
            opacity: 0.25;
        }
        .cal-day-cell.is-today {
            border: 1px solid var(--accent-blue);
            background-color: rgba(3, 169, 244, 0.03);
        }
        .cal-day-cell.is-today .cell-num-label {
            color: var(--accent-blue);
            font-weight: 600;
        }

        /* Sidebar Custom Styles */
        .cal-control-sidebar {
            width: 240px;
            display: flex;
            flex-direction: column;
            gap: 25px;
            flex-shrink: 0;
            padding-top: 10px;
        }
        .sidebar-section-block {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .section-toggle-title {
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            color: var(--text-muted);
            letter-spacing: 0.5px;
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .cal-checkbox-row {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 13px;
            color: var(--text-light);
            padding-left: 6px;
        }
        .cal-checkbox-row input[type="checkbox"] {
            accent-color: #2b7de9;
            cursor: pointer;
        }
        .feed-link-wrapper {
            margin-top: 10px;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .feed-link-wrapper a {
            color: var(--accent-blue);
            text-decoration: none;
            font-size: 13px;
        }
        .feed-link-wrapper i { font-size: 16px; color: var(--accent-blue); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="calendar-workspace-split">
        
        <!-- Left Section Core Grid Frame -->
        <div class="calendar-grid-container">
            <div class="cal-toolbar-strip">
                <div class="cal-toolbar-left">
                    <asp:Button ID="btnToday" runat="server" Text="Today" CssClass="cal-action-btn" OnClick="btnToday_Click" />
                    <asp:LinkButton ID="btnPrevMonth" runat="server" CssClass="cal-action-btn" Style="padding: 4px 8px;" OnClick="btnPrevMonth_Click">
                        <i class="material-icons-outlined" style="font-size:16px; vertical-align:middle;">chevron_left</i>
                    </asp:LinkButton>
                    <asp:LinkButton ID="btnNextMonth" runat="server" CssClass="cal-action-btn" Style="padding: 4px 8px;" OnClick="btnNextMonth_Click">
                        <i class="material-icons-outlined" style="font-size:16px; vertical-align:middle;">chevron_right</i>
                    </asp:LinkButton>
                    <span class="cal-header-title">
                        <asp:Label ID="lblMonthYearTitle" runat="server"></asp:Label>
                    </span>
                </div>
                <div class="cal-toolbar-right">
                    <div class="cal-view-toggle-group">
                        <button type="button" class="toggle-btn">Week</button>
                        <button type="button" class="toggle-btn active-view">Month</button>
                        <button type="button" class="toggle-btn">Agenda</button>
                    </div>
                    <button type="button" class="plus-icon-btn" title="Add Event"><i class="material-icons-outlined">add</i></button>
                </div>
            </div>

            <div class="cal-main-grid-panel">
                <div class="cal-weekdays-header">
                    <div class="cal-weekday-tag">Sun</div>
                    <div class="cal-weekday-tag">Mon</div>
                    <div class="cal-weekday-tag">Tue</div>
                    <div class="cal-weekday-tag">Wed</div>
                    <div class="cal-weekday-tag">Thu</div>
                    <div class="cal-weekday-tag">Fri</div>
                    <div class="cal-weekday-tag">Sat</div>
                </div>

                <!-- Dynamic Grid Cell Generation Matrix -->
                <div class="cal-cells-matrix">
                    <asp:Repeater ID="rptCalendarCells" runat="server">
                        <ItemTemplate>
                            <div class='cal-day-cell <%# Convert.ToBoolean(Eval("IsCurrentMonth")) ? "" : "outside-month" %> <%# Convert.ToBoolean(Eval("IsToday")) ? "is-today" : "" %>'>
                                <span class="cell-num-label"><%# Eval("DayNumber") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>

        <!-- Right Side Controls Sidebar Column -->
        <aside class="cal-control-sidebar">
            <div class="sidebar-section-block">
                <div class="section-toggle-title">
                    <i class="material-icons-outlined" style="font-size:14px;">arrow_drop_down</i>Calendars
                </div>
                <div class="cal-checkbox-row">
                    <input type="checkbox" id="chkUserCal" checked="checked" />
                    <label style="cursor:pointer;" for="chkUserCal">TROWA ADRIAN JAYME</label>
                </div>
            </div>
            <div class="sidebar-section-block">
                <div class="section-toggle-title">
                    <i class="material-icons-outlined" style="font-size:14px;">arrow_drop_down</i>Undated
                </div>
            </div>
            <div class="feed-link-wrapper">
                <i class="material-icons-outlined">rss_feed</i>
                <a href="#">Calendar Feed</a>
            </div>
        </aside>
    </div>

</asp:Content>