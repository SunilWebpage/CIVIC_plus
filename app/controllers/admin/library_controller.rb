module Admin
  class LibraryController < ApplicationController
    before_action :require_admin

    def index
      @book = Book.new
      @question_paper = QuestionPaper.new
      @syllabus = Syllabus.new
      @books = Book.order(:standard, :subject)
      @question_papers = QuestionPaper.order(year: :desc, title: :asc)
      @syllabuses = Syllabus.ordered
    end

    def create_book
      @book = Book.find_or_initialize_by(
        standard: book_params[:standard],
        subject: book_params[:subject]
      )
      @book.assign_attributes(book_params)
      @question_paper = QuestionPaper.new
      @syllabus = Syllabus.new
      @books = Book.order(:standard, :subject)
      @question_papers = QuestionPaper.order(year: :desc, title: :asc)
      @syllabuses = Syllabus.ordered

      if @book.save
        redirect_to admin_library_index_path, notice: "Book PDF saved successfully."
      else
        render :index, status: :unprocessable_entity
      end
    end

    def create_question_paper
      @book = Book.new
      @question_paper = QuestionPaper.new(question_paper_params)
      @syllabus = Syllabus.new
      @books = Book.order(:standard, :subject)
      @question_papers = QuestionPaper.order(year: :desc, title: :asc)
      @syllabuses = Syllabus.ordered

      if @question_paper.save
        redirect_to admin_library_index_path, notice: "Question paper PDF added successfully."
      else
        render :index, status: :unprocessable_entity
      end
    end

    def create_syllabus
      @book = Book.new
      @question_paper = QuestionPaper.new
      @syllabus = Syllabus.find_or_initialize_by(
        category: syllabus_params[:category],
        exam_name: syllabus_params[:exam_name]
      )
      @syllabus.assign_attributes(syllabus_params)
      @books = Book.order(:standard, :subject)
      @question_papers = QuestionPaper.order(year: :desc, title: :asc)
      @syllabuses = Syllabus.ordered

      if @syllabus.save
        redirect_to admin_library_index_path, notice: "Syllabus PDF saved successfully."
      else
        render :index, status: :unprocessable_entity
      end
    end

    private

    def book_params
      params.require(:book).permit(:title, :standard, :subject, :pdf_url)
    end

    def question_paper_params
      params.require(:question_paper).permit(:title, :category, :year, :is_premium, :pdf_url)
    end

    def syllabus_params
      params.require(:syllabus).permit(:category, :exam_name, :title, :description, :pdf_file)
    end
  end
end
