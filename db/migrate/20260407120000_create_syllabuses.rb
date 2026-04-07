class CreateSyllabuses < ActiveRecord::Migration[8.1]
  def change
    create_table :syllabuses do |t|
      t.string :category, null: false
      t.string :exam_name, null: false
      t.string :title, null: false
      t.text :description

      t.timestamps
    end

    add_index :syllabuses, [ :category, :exam_name ], unique: true
  end
end
