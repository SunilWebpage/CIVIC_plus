require Rails.root.join("app/services/pdf/answer_sheet_pdf")

class AnswerSheetsController < ApplicationController
  before_action :require_login
  before_action :set_answer_sheet, only: [ :show, :export, :destroy ]

  def create
    @exam_practice = ExamPractice.find(params[:exam_practice_id])
    @answer_sheet = current_user.answer_sheets.build(answer_sheet_params)
    @answer_sheet.exam_practice = @exam_practice
    @answer_sheet.submitted_at = Time.current

    if @answer_sheet.save
      redirect_to answer_sheet_path(@answer_sheet), notice: "Answer sheet submitted successfully."
    else
      render "exam_practices/show", status: :unprocessable_entity
    end
  end

  def show
  end

  def export
    pdf = ::Pdf::AnswerSheetPdf.new(@answer_sheet)

    send_data pdf.render,
      filename: "answer-sheet-#{@answer_sheet.id}.pdf",
      type: "application/pdf",
      disposition: "attachment"
  end

  def destroy
    @answer_sheet.destroy
    redirect_to exam_practices_path, notice: "Completed test deleted successfully."
  end

  private

  def set_answer_sheet
    @answer_sheet = current_user.answer_sheets.find(params[:id])
  end

  def answer_sheet_params
    params.require(:answer_sheet).permit(:answers_text)
  end
end
