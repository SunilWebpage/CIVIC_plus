class AddDisplayNameToRoomMemberships < ActiveRecord::Migration[8.1]
  def change
    add_column :room_memberships, :display_name, :string
    add_index :room_memberships, :display_name
  end
end
