class QuestionPaper < ApplicationRecord
  has_one_attached :pdf_file

  validates :title, :category, :year, presence: true
  validate :pdf_source_must_be_present
  validate :pdf_file_must_be_pdf

  # Scopes to filter papers by category in the UI
  scope :by_category, ->(category) { where(category: category) if category.present? }

  private

  def pdf_source_must_be_present
    return if pdf_file.attached?
    return if pdf_url.present? && SafeUrl.normalize(pdf_url).present?

    errors.add(:pdf_file, "must be attached")
  end

  def pdf_file_must_be_pdf
    return unless pdf_file.attached?
    return if pdf_file.blob.content_type == "application/pdf"

    errors.add(:pdf_file, "must be a PDF")
  end
end
