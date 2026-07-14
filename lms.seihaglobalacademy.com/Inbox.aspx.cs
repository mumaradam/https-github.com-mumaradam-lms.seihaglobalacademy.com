using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace lms.seihaglobalacademy.com
{
    public partial class Inbox : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadMockInboxThreads();
            }
        }

        private void LoadMockInboxThreads()
        {
            var chatThreads = new List<InboxThreadItem>
            {
                new InboxThreadItem { SenderName = "Technical Support Team", TimeLabel = "14:15", Subject = "Database Efficiency Staging Feedback Sync", LastSnippet = "Awesome, thank you for checking the form logs!", IsSelected = true },
                new InboxThreadItem { SenderName = "Prof. Kenji Minamoto", TimeLabel = "Yesterday", Subject = "Japanese Business Phrases Submission Extension", LastSnippet = "Please verify the submission link structure.", IsSelected = false },
                new InboxThreadItem { SenderName = "LMS Platform Automations", TimeLabel = "Jul 08", Subject = "System Deployment Token Verified Successfully", LastSnippet = "Your account login parameters were successfully mapped.", IsSelected = false }
            };

            rptInboxThreads.DataSource = chatThreads;
            rptInboxThreads.DataBind();
        }
    }

    public class InboxThreadItem
    {
        public string SenderName { get; set; }
        public string TimeLabel { get; set; }
        public string Subject { get; set; }
        public string LastSnippet { get; set; }
        public bool IsSelected { get; set; }
    }
}