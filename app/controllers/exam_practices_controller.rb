class ExamPracticesController < ApplicationController
  before_action :require_login
  before_action :set_exam_practice, only: :show

  def index
    @exam_practices = ExamPractice.order(created_at: :desc)
    @completed_tests = current_user.answer_sheets.includes(:exam_practice).order(submitted_at: :desc)
  end

  def show
    @answer_sheet = current_user.answer_sheets.build(exam_practice: @exam_practice)
  end

  private

  def set_exam_practice
    @exam_practice = ExamPractice.find(params[:id])
  end
end
