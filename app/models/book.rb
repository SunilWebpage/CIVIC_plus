class Book < ApplicationRecord
  has_one_attached :pdf_file

  SUBJECTS = [ "Tamil", "Science", "Social", "Maths" ].freeze
  STANDARDS = (6..12).freeze

  validates :title, presence: true
  validates :standard, presence: true, inclusion: { in: STANDARDS }
  validates :subject, presence: true, inclusion: { in: SUBJECTS }
  validates :subject, uniqueness: { scope: :standard }
  validate :pdf_source_must_be_present
  validate :pdf_file_must_be_pdf

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
