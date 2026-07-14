using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;




namespace lms.seihaglobalacademy.com
{
    public partial class Dashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadDashboardGridContent();
            }
        }

        private void LoadDashboardGridContent()
        {
            var activeCourses = new List<DashboardCourseItem>
            {
                new DashboardCourseItem { CourseName = "Example Course 1" },
                new DashboardCourseItem { CourseName = "Example Course 2" }
            };

            rptDashboardCourses.DataSource = activeCourses;
            rptDashboardCourses.DataBind();
        }
    }

    public class DashboardCourseItem
    {
        public string CourseName { get; set; }
    }
}