class AnswerSheet < ApplicationRecord
  belongs_to :user
  belongs_to :exam_practice

  validates :answers_text, :submitted_at, presence: true
end
