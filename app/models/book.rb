class Book < ApplicationRecord
  SUBJECTS = [ "Tamil", "Science", "Social", "Maths" ].freeze
  STANDARDS = (6..12).freeze

  validates :title, presence: true
  validates :pdf_url, length: { maximum: 1000 }, allow_blank: true
  validates :standard, presence: true, inclusion: { in: STANDARDS }
  validates :subject, presence: true, inclusion: { in: SUBJECTS }
  validates :subject, uniqueness: { scope: :standard }
end
