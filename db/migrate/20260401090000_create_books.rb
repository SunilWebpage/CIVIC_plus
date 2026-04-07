class CreateBooks < ActiveRecord::Migration[8.1]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.integer :standard, null: false
      t.string :subject, null: false

      t.timestamps
    end

    add_index :books, [ :standard, :subject ], unique: true
  end
end
