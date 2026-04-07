class SyllabusesController < ApplicationController
  FILTERS = [
    { label: "All", value: "all" },
    { label: "Banking", value: "banking" },
    { label: "NEET", value: "neet" },
    { label: "JEE", value: "jee" },
    { label: "SSC", value: "ssc" },
    { label: "UPSC", value: "upsc" },
    { label: "TNPSC", value: "tnpsc" }
  ].freeze

  def index
    @selected_filter = params[:filter].presence_in(FILTERS.map { |filter| filter[:value] }) || "all"
    @filters = FILTERS

    groups = [
      {
        title: "Banking Exams",
        note: "Core sections for IBPS, SBI PO, SBI Clerk, RBI Assistant, and similar banking recruitment exams.",
        filters: %w[banking],
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
        filters: %w[neet],
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
        filters: %w[jee],
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
        filters: %w[ssc upsc tnpsc],
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

    @syllabus_groups =
      if @selected_filter == "all"
        groups
      else
        groups.filter_map do |group|
          filtered_exams = group[:exams].select do |exam|
            exam_filter_match?(group, exam)
          end
          next if filtered_exams.empty?

          group.merge(exams: filtered_exams)
        end
      end
  end

  private

  def exam_filter_match?(group, exam)
    return true if group[:filters].include?(@selected_filter)

    exam[:name].downcase.include?(@selected_filter)
  end
end
