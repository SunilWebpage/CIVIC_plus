class RemovePdfUrlFromSyllabuses < ActiveRecord::Migration[8.1]
  def change
    return unless column_exists?(:syllabuses, :pdf_url)

    remove_column :syllabuses, :pdf_url, :string
  end
end
