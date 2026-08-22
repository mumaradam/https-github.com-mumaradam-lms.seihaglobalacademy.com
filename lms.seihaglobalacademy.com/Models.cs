using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;


namespace lms.seihaglobalacademy.com
{
    [Serializable]
    public class AnnouncementModel
    {
        public string Title { get; set; }
        public string Author { get; set; }
        public string PostDate { get; set; }
        public string Body { get; set; }
    }

    [Serializable]
    public class GoogleFormQuizModel
    {
        public string Title { get; set; }
        public string DueDate { get; set; }
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
        public string EndDateTime { get; set; }
        public string ManualGrading { get; set; }
        public string Completed { get; set; }
        public string AttemptsAllowed { get; set; }
    }
}