# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


QuestionPaper.create!(title: "NEET Physics 2024", category: "NEET", year: 2024, is_premium: false)
QuestionPaper.create!(title: "TNPSC Group 4 GS", category: "TNPSC", year: 2023, is_premium: false)
QuestionPaper.create!(title: "SBI PO Prelims", category: "Banking", year: 2024, is_premium: true)

Book::STANDARDS.each do |standard|
  Book::SUBJECTS.each do |subject|
    Book.find_or_create_by!(standard:, subject:) do |book|
      book.title = "Class #{standard} #{subject} Book"
    end
  end
end

ExamPractice.find_or_create_by!(title: "Maths Model Test 1") do |exam|
  exam.subject = "Maths"
  exam.exam_type = "Practice Test"
  exam.duration_minutes = 60
  exam.total_marks = 50
  exam.instructions = "Answer all questions clearly and show the working steps."
  exam.questions_text = <<~TEXT
    1. Solve: 2x + 7 = 21
    2. Find the area of a rectangle with length 12 cm and breadth 5 cm.
    3. Simplify: 3/4 + 1/8
  TEXT
end

ExamPractice.find_or_create_by!(title: "Science Revision Test") do |exam|
  exam.subject = "Science"
  exam.exam_type = "Exam Practice"
  exam.duration_minutes = 45
  exam.total_marks = 40
  exam.instructions = "Write short and precise answers with one example where needed."
  exam.questions_text = <<~TEXT
    1. Explain photosynthesis.
    2. What is a force? Give two examples.
    3. Differentiate between physical and chemical changes.
  TEXT
end

puts "Success: Seeded question papers, books, and exam practices into MySQL!"
