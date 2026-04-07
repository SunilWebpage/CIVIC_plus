require "json"
require "net/http"
require "uri"

class GroqChatClient
  API_URL = "https://api.groq.com/openai/v1/chat/completions".freeze
  DEFAULT_MODEL = ENV.fetch("GROQ_MODEL", "llama-3.1-8b-instant")

  def initialize(api_key: ENV["GROQ_API_KEY"], model: DEFAULT_MODEL)
    @api_key = api_key
    @model = model
  end

  def configured?
    @api_key.present?
  end

  def ask(question)
    raise ArgumentError, "Question cannot be blank" if question.blank?
    raise "Groq API key is not configured" unless configured?

    response = perform_request(question)
    extract_text(response) || "I could not generate a response right now. Please try again."
  end

  private

  def perform_request(question)
    uri = URI.parse(API_URL)
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request["Authorization"] = "Bearer #{@api_key}"
    request.body = {
      model: @model,
      messages: [
        {
          role: "system",
          content: "You are Study Bot for a student study app. Give concise, helpful, student-friendly answers with clear steps and exam-oriented explanations."
        },
        {
          role: "user",
          content: question
        }
      ],
      temperature: 0.4
    }.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    response = http.request(request)
    raise "Groq request failed: #{response.code} #{response.body}" unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end

  def extract_text(response)
    response.dig("choices", 0, "message", "content")&.strip
  end
end
