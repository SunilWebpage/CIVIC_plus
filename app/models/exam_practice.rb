class ExamPractice < ApplicationRecord
  has_many :answer_sheets, dependent: :destroy

  validates :title, :subject, :exam_type, :duration_minutes, :total_marks, :questions_text, presence: true
  validates :duration_minutes, :total_marks, numericality: { greater_than: 0 }
end
