class BotsController < ApplicationController
  before_action :require_login

  def index
    @suggestions = [
      "Solve a critical maths problem step by step",
      "Explain a science concept in simple words",
      "Give me a quick answer writing format for social",
      "How do I study Tamil book back questions fast?"
    ]
    @bot_available = GroqChatClient.new.configured?
  end

  def ask
    question = params[:question].to_s.strip
    return render json: { error: "Question cannot be blank" }, status: :unprocessable_entity if question.blank?

    client = GroqChatClient.new
    return render json: { error: "AI is not configured on the server" }, status: :service_unavailable unless client.configured?

    answer = client.ask(question)
    render json: { answer: answer }
  rescue StandardError => e
    Rails.logger.error("Bot ask failed: #{e.message}")
    render json: { error: "Unable to get AI response right now" }, status: :bad_gateway
  end
end
