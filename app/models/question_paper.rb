class QuestionPaper < ApplicationRecord
  has_one_attached :pdf_file

  validates :title, :category, :year, presence: true
  validates :pdf_url, length: { maximum: 1000 }, allow_blank: true

  # Scopes to filter papers by category in the UI
  scope :by_category, ->(category) { where(category: category) if category.present? }
end
