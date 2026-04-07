class QuestionPaper < ApplicationRecord
  has_one_attached :pdf_file

  validates :title, :category, :year, presence: true
  validates :pdf_url, length: { maximum: 1000 }, allow_blank: true
  validate :pdf_url_must_be_safe

  # Scopes to filter papers by category in the UI
  scope :by_category, ->(category) { where(category: category) if category.present? }

  private

  def pdf_url_must_be_safe
    return if pdf_url.blank? || SafeUrl.normalize(pdf_url).present?

    errors.add(:pdf_url, "must be an absolute path or an http/https URL")
  end
end
