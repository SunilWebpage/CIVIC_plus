class QuestionPapersController < ApplicationController
  before_action :require_login, only: :show

  def index
    @selected_category = params[:category].presence

    # If a category is passed in the URL, filter by it. Otherwise, show all.
    if @selected_category
      @papers = QuestionPaper.where(category: @selected_category).order(year: :desc)
    else
      @papers = QuestionPaper.all.order(year: :desc)
    end

    @featured_papers = @papers.limit(6)
    @categories = QuestionPaper.distinct.order(:category).pluck(:category)
    @total_papers = QuestionPaper.count
    @premium_papers = QuestionPaper.where(is_premium: true).count
    @latest_year = QuestionPaper.maximum(:year)
  end

  def show
    @paper = QuestionPaper.find(params[:id])
  end
end
