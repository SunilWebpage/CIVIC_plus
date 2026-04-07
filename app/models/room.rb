class Room < ApplicationRecord
  has_secure_password

  belongs_to :admin, class_name: "User"
  has_many :room_memberships, dependent: :destroy
  has_many :users, through: :room_memberships

  validates :name, presence: true, uniqueness: true
  validates :password, length: { minimum: 4 }, if: -> { password.present? }
end
