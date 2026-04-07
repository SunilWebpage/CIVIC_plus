class AddPdfUrlToQuestionPapers < ActiveRecord::Migration[8.1]
  def change
    add_column :question_papers, :pdf_url, :string
  end
end
