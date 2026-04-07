class CreateQuestionPapers < ActiveRecord::Migration[8.1]
  def change
    create_table :question_papers do |t|
      t.string :title
      t.string :category
      t.integer :year
      t.boolean :is_premium

      t.timestamps
    end
  end
end
