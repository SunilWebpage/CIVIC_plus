class HomeController < ApplicationController
  def index
    @selected_category = params[:category].presence

    @papers = if @selected_category
      QuestionPaper.where(category: @selected_category).order(year: :desc)
    else
      QuestionPaper.order(year: :desc)
    end

    @featured_papers = @papers.limit(6)
    @categories = QuestionPaper.distinct.order(:category).pluck(:category)
    @total_papers = QuestionPaper.count
    @premium_papers = QuestionPaper.where(is_premium: true).count
    @latest_year = QuestionPaper.maximum(:year)

    render "question_papers/index"
  end
end
