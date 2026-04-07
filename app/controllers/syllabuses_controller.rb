class SyllabusesController < ApplicationController
  def index
    @syllabus_groups = [
      {
        title: "Banking Exams",
        note: "Core sections for IBPS, SBI PO, SBI Clerk, RBI Assistant, and similar banking recruitment exams.",
        exams: [
          {
            name: "IBPS PO / Clerk",
            syllabus: [ "Quantitative Aptitude", "Reasoning Ability", "English Language", "General Awareness", "Computer Aptitude" ]
          },
          {
            name: "SBI PO",
            syllabus: [ "Data Interpretation", "Logical Reasoning", "Reading Comprehension", "Banking Awareness", "Descriptive English" ]
          },
          {
            name: "RBI Assistant",
            syllabus: [ "Numerical Ability", "Reasoning", "English", "General Awareness", "Computer Knowledge" ]
          }
        ]
      },
      {
        title: "Medical Entrance",
        note: "High-frequency subjects and units for medical entrance preparation.",
        exams: [
          {
            name: "NEET",
            syllabus: [ "Physics", "Chemistry", "Botany", "Zoology", "NCERT-based Class 11 and 12 topics" ]
          },
          {
            name: "AIIMS Nursing",
            syllabus: [ "Physics", "Chemistry", "Biology", "General Knowledge", "Aptitude" ]
          }
        ]
      },
      {
        title: "Engineering Entrance",
        note: "Preparation areas for national and state-level engineering entrance exams.",
        exams: [
          {
            name: "JEE Main",
            syllabus: [ "Physics", "Chemistry", "Mathematics", "Problem Solving", "Class 11 and 12 concepts" ]
          },
          {
            name: "JEE Advanced",
            syllabus: [ "Advanced Physics", "Organic and Inorganic Chemistry", "Advanced Mathematics", "Multi-concept problem solving" ]
          },
          {
            name: "State Engineering Entrance",
            syllabus: [ "Physics", "Chemistry", "Mathematics", "Board-level fundamentals" ]
          }
        ]
      },
      {
        title: "Government Recruitment",
        note: "Common subjects for competitive recruitment exams across central and state government roles.",
        exams: [
          {
            name: "SSC CGL / CHSL",
            syllabus: [ "Quantitative Aptitude", "General Intelligence", "English", "General Awareness", "Descriptive and skill sections" ]
          },
          {
            name: "UPSC Prelims",
            syllabus: [ "History", "Polity", "Geography", "Economy", "Environment", "Current Affairs", "CSAT" ]
          },
          {
            name: "TNPSC Group Exams",
            syllabus: [ "General Tamil or English", "General Studies", "Aptitude and Mental Ability", "Current Events" ]
          }
        ]
      }
    ]
  end
end
