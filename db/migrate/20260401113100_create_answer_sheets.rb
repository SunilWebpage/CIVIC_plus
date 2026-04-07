class CreateAnswerSheets < ActiveRecord::Migration[8.1]
  def change
    create_table :answer_sheets do |t|
      t.references :user, null: false, foreign_key: true
      t.references :exam_practice, null: false, foreign_key: true
      t.text :answers_text, null: false
      t.datetime :submitted_at, null: false

      t.timestamps
    end
  end
end
