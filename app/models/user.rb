class User < ApplicationRecord
  has_secure_password
  has_many :answer_sheets, dependent: :destroy
  has_many :sent_conversations, class_name: "Conversation", foreign_key: :sender_id, dependent: :destroy
  has_many :received_conversations, class_name: "Conversation", foreign_key: :recipient_id, dependent: :destroy
  has_many :chat_messages, dependent: :destroy
  has_many :admin_rooms, class_name: "Room", foreign_key: :admin_id, dependent: :destroy
  has_many :room_memberships, dependent: :destroy
  has_many :rooms, through: :room_memberships

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
  validate :exactly_one_plan_selected

  private

  public

  def conversations
    Conversation.for_user(self)
  end

  def exactly_one_plan_selected
    selected_plans = [ free, advance, pro ].count(true)
    return if selected_plans == 1

    errors.add(:base, "User must have exactly one plan: free, advance, or pro")
  end
end
