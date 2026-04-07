class CreateRoomsAndRoomMemberships < ActiveRecord::Migration[8.1]
  def change
    create_table :rooms do |t|
      t.string :name, null: false
      t.string :password_digest, null: false
      t.references :admin, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :rooms, :name, unique: true

    create_table :room_memberships do |t|
      t.references :room, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    add_index :room_memberships, [ :room_id, :user_id ], unique: true
  end
end
