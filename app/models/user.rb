class User < ApplicationRecord
  has_secure_password
  has_many :answer_sheets, dependent: :destroy

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
  validate :exactly_one_plan_selected

  private

  def exactly_one_plan_selected
    selected_plans = [ free, advance, pro ].count(true)
    return if selected_plans == 1

    errors.add(:base, "User must have exactly one plan: free, advance, or pro")
  end
end
