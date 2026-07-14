using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace lms.seihaglobalacademy.com
{
    public partial class Calendar : Page
    {
        private DateTime CurrentTargetDate
        {
            get
            {
                if (ViewState["TargetDate"] == null)
                {
                    ViewState["TargetDate"] = DateTime.Today;
                }
                return (DateTime)ViewState["TargetDate"];
            }
            set
            {
                ViewState["TargetDate"] = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                RenderDynamicCalendar();
            }
        }

        private void RenderDynamicCalendar()
        {
            DateTime target = CurrentTargetDate;
            lblMonthYearTitle.Text = target.ToString("MMMM yyyy");

            DateTime firstDayOfMonth = new DateTime(target.Year, target.Month, 1);
            int totalDaysInMonth = DateTime.DaysInMonth(target.Year, target.Month);
            int startDayOfWeekOffset = (int)firstDayOfMonth.DayOfWeek;

            List<CalendarCellModel> cellGridList = new List<CalendarCellModel>();

            // 1. Previous Month Padding
            DateTime previousMonth = firstDayOfMonth.AddMonths(-1);
            int daysInPreviousMonth = DateTime.DaysInMonth(previousMonth.Year, previousMonth.Month);
            for (int i = startDayOfWeekOffset - 1; i >= 0; i--)
            {
                cellGridList.Add(new CalendarCellModel
                {
                    DayNumber = daysInPreviousMonth - i,
                    IsCurrentMonth = false,
                    IsToday = false
                });
            }

            // 2. Active Month Days
            for (int day = 1; day <= totalDaysInMonth; day++)
            {
                bool checkIfToday = (DateTime.Today.Year == target.Year &&
                                     DateTime.Today.Month == target.Month &&
                                     DateTime.Today.Day == day);

                cellGridList.Add(new CalendarCellModel
                {
                    DayNumber = day,
                    IsCurrentMonth = true,
                    IsToday = checkIfToday
                });
            }

            // 3. Next Month Padding
            int currentTotalCells = cellGridList.Count;
            int totalRequiredGridCells = currentTotalCells <= 35 ? 35 : 42;
            int nextMonthPaddingDays = totalRequiredGridCells - currentTotalCells;

            for (int nextDay = 1; nextDay <= nextMonthPaddingDays; nextDay++)
            {
                cellGridList.Add(new CalendarCellModel
                {
                    DayNumber = nextDay,
                    IsCurrentMonth = false,
                    IsToday = false
                });
            }

            rptCalendarCells.DataSource = cellGridList;
            rptCalendarCells.DataBind();
        }

        protected void btnToday_Click(object sender, EventArgs e)
        {
            CurrentTargetDate = DateTime.Today;
            RenderDynamicCalendar();
        }

        protected void btnPrevMonth_Click(object sender, EventArgs e)
        {
            CurrentTargetDate = CurrentTargetDate.AddMonths(-1);
            RenderDynamicCalendar();
        }

        protected void btnNextMonth_Click(object sender, EventArgs e)
        {
            CurrentTargetDate = CurrentTargetDate.AddMonths(1);
            RenderDynamicCalendar();
        }
    }

    public class CalendarCellModel
    {
        public int DayNumber { get; set; }
        public bool IsCurrentMonth { get; set; }
        public bool IsToday { get; set; }
    }
}