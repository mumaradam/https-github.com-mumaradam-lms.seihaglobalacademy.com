<%@ Page Title="Inbox" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Inbox.aspx.cs" Inherits="lms.seihaglobalacademy.com.Inbox" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        /* Split Messaging Workspace */
        .inbox-workspace-layout {
            display: flex;
            gap: 20px;
            height: calc(100vh - 140px);
            background-color: #26292c;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            overflow: hidden;
        }

        /* Left Column: Conversation Directory Scrollable Strip */
        .inbox-threads-sidebar {
            width: 340px;
            border-right: 1px solid var(--border-color);
            display: flex;
            flex-direction: column;
            background-color: #212427;
            flex-shrink: 0;
        }
        
        .threads-sidebar-header {
            padding: 20px;
            border-bottom: 1px solid var(--border-color);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .threads-sidebar-header h2 { font-size: 18px; font-weight: 500; color: #fff; }
        .compose-icon-btn { color: var(--accent-blue); cursor: pointer; background: none; border: none; }

        .threads-scroll-container {
            flex: 1;
            overflow-y: auto;
        }

        /* Single Chat Thread Row Card Box Components */
        .thread-row-item {
            padding: 16px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.03);
            cursor: pointer;
            transition: background 0.2s;
            display: flex;
            flex-direction: column;
            gap: 4px;
        }
        .thread-row-item:hover { background-color: rgba(255, 255, 255, 0.03); }
        .thread-row-item.active-thread {
            background-color: rgba(3, 169, 244, 0.08);
            border-left: 3px solid var(--accent-blue);
        }

        .thread-meta-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .thread-sender-name { font-size: 14px; font-weight: 500; color: #fff; }
        .thread-timestamp { font-size: 11px; color: var(--text-muted); font-variant-numeric: tabular-nums; }
        .thread-subject-line { font-size: 13px; color: var(--accent-blue); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
        .thread-snippet-preview { font-size: 12px; color: var(--text-muted); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

        /* Right Column: Primary Chat Content Viewer Viewport */
        .inbox-chat-viewport {
            flex: 1;
            display: flex;
            flex-direction: column;
            background-color: #26292c;
        }

        .chat-viewport-header {
            padding: 20px;
            border-bottom: 1px solid var(--border-color);
            background-color: #212427;
        }
        .chat-header-subject { font-size: 16px; font-weight: 500; color: #fff; margin-bottom: 4px; }
        .chat-header-participants { font-size: 12px; color: var(--text-muted); }

        .chat-messages-container {
            flex: 1;
            padding: 25px;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        /* Single Chat Balloon Text Bubble Blocks */
        .chat-bubble-row { display: flex; flex-direction: column; gap: 6px; max-width: 75%; }
        .chat-bubble-row.incoming-msg { align-self: flex-start; }
        .chat-bubble-row.outgoing-msg { align-self: flex-end; align-items: flex-end; }

        .chat-bubble-text {
            padding: 12px 16px;
            border-radius: 8px;
            font-size: 13.5px;
            line-height: 1.5;
            color: #fff;
        }
        .incoming-msg .chat-bubble-text { background-color: #383c40; border: 1px solid var(--border-color); }
        .outgoing-msg .chat-bubble-text { background-color: #1e6bcf; }
        .chat-bubble-time { font-size: 11px; color: var(--text-muted); font-variant-numeric: tabular-nums; padding: 0 4px; }

        /* Lower Input Send Interface Panel Footer Area */
        .chat-input-footer-tray {
            padding: 20px;
            border-top: 1px solid var(--border-color);
            background-color: #212427;
            display: flex;
            gap: 12px;
            align-items: center;
        }
        .chat-reply-textarea {
            flex: 1;
            background-color: #2d3135;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            padding: 10px 14px;
            color: #fff;
            font-size: 13px;
            resize: none;
            outline: none;
            height: 40px;
        }
        .chat-send-btn {
            background-color: var(--accent-blue);
            color: #fff;
            border: none;
            width: 40px;
            height: 40px;
            border-radius: 4px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .chat-send-btn:hover { background-color: #0288d1; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="inbox-workspace-layout">
        
        <!-- Left Sidebar List View -->
        <aside class="inbox-threads-sidebar">
            <div class="threads-sidebar-header">
                <h2>Conversations</h2>
                <button type="button" class="compose-icon-btn" title="Compose Message"><i class="material-icons-outlined">edit_note</i></button>
            </div>
            <div class="threads-scroll-container">
                <asp:Repeater ID="rptInboxThreads" runat="server">
                    <ItemTemplate>
                        <div class='thread-row-item <%# Convert.ToBoolean(Eval("IsSelected")) ? "active-thread" : "" %>'>
                            <div class="thread-meta-top">
                                <span class="thread-sender-name"><%# Eval("SenderName") %></span>
                                <span class="thread-timestamp"><%# Eval("TimeLabel") %></span>
                            </div>
                            <div class="thread-subject-line"><%# Eval("Subject") %></div>
                            <div class="thread-snippet-preview"><%# Eval("LastSnippet") %></div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </aside>

        <!-- Right Main Chat Frame Viewport -->
        <main class="inbox-chat-viewport">
            <div class="chat-viewport-header">
                <div class="chat-header-subject">Database Efficiency Staging Feedback Sync</div>
                <div class="chat-header-participants">From: Technical Support Team (Admin)</div>
            </div>

            <div class="chat-messages-container">
                <!-- Incoming Staging Message Block -->
                <div class="chat-bubble-row incoming-msg">
                    <div class="chat-bubble-text">
                        Hello! We reviewed the initial layout forms you encoded. The interface looks incredibly clean, and the local database connection matrix parameters are fully responding. Keep up the clean structure!
                    </div>
                    <span class="chat-bubble-time">10:42</span>
                </div>

                <!-- Outgoing User Response Staging Block (incorporating 24-hour time preference alignment) -->
                <div class="chat-bubble-row outgoing-msg">
                    <div class="chat-bubble-text">
                        Awesome, thank you for checking the form logs! We're doing a step-by-step namespace integration manually inside the solution now to keep everything stable.
                    </div>
                    <span class="chat-bubble-time">14:15</span>
                </div>
            </div>

            <!-- Lower Action Tray Interface Input Bar -->
            <div class="chat-input-footer-tray">
                <input type="text" class="chat-reply-textarea" placeholder="Write a reply..." />
                <button type="button" class="chat-send-btn"><i class="material-icons-outlined" style="font-size: 20px;">send</i></button>
            </div>
        </main>
    </div>

</asp:Content>