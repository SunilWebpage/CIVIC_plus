class BooksController < ApplicationController
  def index
    @subjects = Book::SUBJECTS
    @books_by_standard = Book.order(:standard, :subject).group_by(&:standard)
    @question_papers_by_standard = Book::STANDARDS.to_h do |standard|
      papers = Book::SUBJECTS.index_with do |subject|
        "Class #{standard} #{subject} Book Back Question Paper"
      end

      [ standard, papers ]
    end
  end
end
