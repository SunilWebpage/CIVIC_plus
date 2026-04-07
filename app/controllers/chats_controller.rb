class ChatsController < ApplicationController
  before_action :require_login

  def index
    @rooms = [
      { name: "Tamil Book Back", owner: "Arun", topic: "Std 6 and 7 discussion", status: "Active now" },
      { name: "Science Doubts", owner: "Divya", topic: "Quick revision room", status: "2 new questions" },
      { name: "Social Share", owner: "Kavin", topic: "Notes and model papers", status: "Open room" }
    ]

    @messages = [
      { sender: "Arun", body: "I created a Tamil room. Can you share the book back questions there?", time: "09:15 AM", own: false },
      { sender: "You", body: "Yes, I will send the library link here.", time: "09:17 AM", own: true },
      { sender: "Divya", body: "Please share the science paper also.", time: "09:20 AM", own: false }
    ]

    @share_items = QuestionPaper.order(year: :desc).limit(6).map do |paper|
      {
        title: paper.title,
        subtitle: "#{paper.category} • #{paper.year}",
        url: SafeUrl.normalize(paper.pdf_url) || question_paper_path(paper)
      }
    end
  end
end
