using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


namespace lms.seihaglobalacademy.com
{
    [Serializable]
    public class CourseAnnouncementModel
    {
        public int AnnouncementID { get; set; }
        public string Title { get; set; }
        public string Author { get; set; }
        public string PostDate { get; set; }
        public string Body { get; set; }
    }

    [Serializable]
    public class CourseModuleModel
    {
        public int ModuleID { get; set; }
        public string UnitTitle { get; set; }
        public int LessonCount { get; set; }
        public string FocusArea { get; set; }
    }

    [Serializable]
    public class LessonModel
    {
        public int LessonID { get; set; }
        public string LessonTitle { get; set; }
        public string ContentType { get; set; }
        public string ContentDetails { get; set; }
    }

    [Serializable]
    public class GoogleFormQuizModel
    {
        public int QuizID { get; set; }
        public string Title { get; set; }
        public string OpenDate { get; set; }
        public string CloseDate { get; set; }
        public DateTime RawOpenDate { get; set; }
        public DateTime RawCloseDate { get; set; }
        public string TimeLimit { get; set; }
        public List<QuestionModel> Questions { get; set; } = new List<QuestionModel>();
    }

    [Serializable]
    public class QuestionModel
    {
        public string QuestionText { get; set; }
        public string OptionA { get; set; } = "Option A";
        public string OptionB { get; set; } = "Option B";
        public string OptionC { get; set; } = "Option C";
        public string OptionD { get; set; } = "Option D";
        public string CorrectAnswer { get; set; } = "A";
    }

    [Serializable]
    public class QuestionResultModel
    {
        public string QuestionText { get; set; }
        public string SelectedAnswer { get; set; }
        public string CorrectAnswer { get; set; }
        public bool IsCorrect { get; set; }
    }

    [Serializable]
    public class CourseModel
    {
        public string CourseName { get; set; }
    }

    [Serializable]
    public class AssignmentModel
    {
        public int AssignmentID { get; set; }
        public string AssignmentName { get; set; }
        public string CourseName { get; set; }
        public string OpenDate { get; set; }
        public string EndDateTime { get; set; }
        public DateTime RawOpenDate { get; set; }
        public DateTime RawCloseDate { get; set; }
        public int MaxPoints { get; set; } = 100;
        public string Instructions { get; set; }
        public string ManualGrading { get; set; }
        public string Completed { get; set; }
        public string AttemptsAllowed { get; set; }
    }
}