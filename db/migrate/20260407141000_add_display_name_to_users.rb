class AddDisplayNameToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :display_name, :string
    add_index :users, :display_name
  end
end
