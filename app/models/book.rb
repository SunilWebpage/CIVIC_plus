class Book < ApplicationRecord
  SUBJECTS = [ "Tamil", "Science", "Social", "Maths" ].freeze
  STANDARDS = (6..12).freeze

  validates :title, presence: true
  validates :pdf_url, length: { maximum: 1000 }, allow_blank: true
  validates :standard, presence: true, inclusion: { in: STANDARDS }
  validates :subject, presence: true, inclusion: { in: SUBJECTS }
  validates :subject, uniqueness: { scope: :standard }
  validate :pdf_url_must_be_safe

  private

  def pdf_url_must_be_safe
    return if pdf_url.blank? || SafeUrl.normalize(pdf_url).present?

    errors.add(:pdf_url, "must be an absolute path or an http/https URL")
  end
end
