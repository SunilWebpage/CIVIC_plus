class CreateExamPractices < ActiveRecord::Migration[8.1]
  def change
    create_table :exam_practices do |t|
      t.string :title, null: false
      t.string :subject, null: false
      t.string :exam_type, null: false
      t.integer :duration_minutes, null: false
      t.integer :total_marks, null: false
      t.text :instructions
      t.text :questions_text, null: false

      t.timestamps
    end
  end
end
