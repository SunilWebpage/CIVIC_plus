class BotsController < ApplicationController
  before_action :require_login

  def index
    @suggestions = [
      "Solve a critical maths problem step by step",
      "Explain a science concept in simple words",
      "Give me a quick answer writing format for social",
      "How do I study Tamil book back questions fast?"
    ]
  end
end
