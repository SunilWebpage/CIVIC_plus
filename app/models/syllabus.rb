class Syllabus < ApplicationRecord
  has_one_attached :pdf_file

  validates :category, :exam_name, :title, presence: true
  validate :pdf_file_must_be_attached
  validate :pdf_file_must_be_pdf

  scope :ordered, -> { order(:category, :exam_name, :title) }

  private

  def pdf_file_must_be_attached
    errors.add(:pdf_file, "must be attached") unless pdf_file.attached?
  end

  def pdf_file_must_be_pdf
    return unless pdf_file.attached?
    return if pdf_file.blob.content_type == "application/pdf"

    errors.add(:pdf_file, "must be a PDF")
  end
end
