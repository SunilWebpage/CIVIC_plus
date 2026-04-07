class Conversation < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"
  has_many :chat_messages, dependent: :destroy

  validates :sender_id, uniqueness: { scope: :recipient_id }
  validate :participants_must_be_different

  scope :for_user, ->(user) { where(sender: user).or(where(recipient: user)) }

  def self.between(user_a, user_b)
    ids = [ user_a.id, user_b.id ].sort
    find_by(sender_id: ids[0], recipient_id: ids[1])
  end

  def self.find_or_create_between!(user_a, user_b)
    ids = [ user_a.id, user_b.id ].sort
    find_or_create_by!(sender_id: ids[0], recipient_id: ids[1])
  end

  def other_user(current_user)
    sender == current_user ? recipient : sender
  end

  private

  def participants_must_be_different
    return unless sender_id == recipient_id

    errors.add(:recipient_id, "must be different from sender")
  end
end
