using System;
using System.Collections.Generic;

namespace lms.seihaglobalacademy.com
{
    public class GradebookEntryModel
    {
        public int StudentID { get; set; }
        public string StudentName { get; set; }
        public double QuizAverage { get; set; }
        public double AssignmentAverage { get; set; }
        public double OverallGrade { get; set; }
    }

    public class QuestionModel
    {
        // Classifier for the 7 Exam Styles
        public string QuestionType { get; set; } = "Multiple Choice";

        public string QuestionText { get; set; }
        public string OptionA { get; set; }
        public string OptionB { get; set; }
        public string OptionC { get; set; }
        public string OptionD { get; set; }
        public string CorrectAnswer { get; set; }

        // Identification & Fill in the Blank
        public string CorrectTextAnswer { get; set; }

        public string ImagePath { get; set; }
        public string AudioPath { get; set; }
        public string Instructions { get; set; }
        public string MatchingPairsJson { get; set; }
        public string EnumerationAnswers { get; set; }
    }

    public class QuestionResultModel
    {
        public string QuestionText { get; set; }
        public string SelectedAnswer { get; set; }
        public string CorrectAnswer { get; set; }
        public bool IsCorrect { get; set; }
    }

    public class GoogleFormQuizModel
    {
        public int QuizID { get; set; }
        public string Title { get; set; }
        public string OpenDate { get; set; }
        public string CloseDate { get; set; }
        public DateTime RawOpenDate { get; set; }
        public DateTime RawCloseDate { get; set; }
        public string TimeLimit { get; set; }
        public string Instructions { get; set; }
        public List<QuestionModel> Questions { get; set; } = new List<QuestionModel>();
    }

    public class CourseAnnouncementModel
    {
        public int AnnouncementID { get; set; }
        public string Title { get; set; }
        public string Author { get; set; }
        public string PostDate { get; set; }
        public string Body { get; set; }
    }

    public class CourseModuleModel
    {
        public int ModuleID { get; set; }
        public string UnitTitle { get; set; }
        public int LessonCount { get; set; }
        public string FocusArea { get; set; }
    }

    public class AssignmentModel
    {
        public int AssignmentID { get; set; }
        public string AssignmentName { get; set; }
        public string CourseName { get; set; }
        public string OpenDate { get; set; }
        public string EndDateTime { get; set; }
        public DateTime RawOpenDate { get; set; }
        public DateTime RawCloseDate { get; set; }
        public int MaxPoints { get; set; }
        public string Instructions { get; set; }
    }
}