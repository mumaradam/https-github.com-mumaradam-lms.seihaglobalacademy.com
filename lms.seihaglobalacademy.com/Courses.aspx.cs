using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;



namespace lms.seihaglobalacademy.com
{
    public partial class Courses : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadAllCoursesGrid();
            }
        }

        private void LoadAllCoursesGrid()
        {
            var coursesCollection = new List<LMSCourseItem>
            {
                new LMSCourseItem { CourseCode = "NET-101", CourseName = "Fullstack ASP.NET Architecture & Web Forms", Term = "First Semester 2026", ColorHex = "#03a9f4" },
                new LMSCourseItem { CourseCode = "SQL-204", CourseName = "Advanced SQL Server Database Optimization", Term = "First Semester 2026", ColorHex = "#e91e63" },
                new LMSCourseItem { CourseCode = "UIX-105", CourseName = "Modern Front-End Interface Design & Layouts", Term = "First Semester 2026", ColorHex = "#4caf50" },
                new LMSCourseItem { CourseCode = "JPN-302", CourseName = "Intermediate Business Japanese Language", Term = "First Semester 2026", ColorHex = "#ff9800" }
            };

            rptAllCoursesList.DataSource = coursesCollection;
            rptAllCoursesList.DataBind();
        }
    }

    public class LMSCourseItem
    {
        public string CourseCode { get; set; }
        public string CourseName { get; set; }
        public string Term { get; set; }
        public string ColorHex { get; set; }
    }
}