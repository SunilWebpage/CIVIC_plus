require "json"
require "net/http"
require "uri"

class GeminiChatClient
  API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent".freeze

  def initialize(api_key: ENV["GEMINI_API_KEY"])
    @api_key = api_key
  end

  def configured?
    @api_key.present?
  end

  def ask(question)
    raise ArgumentError, "Question cannot be blank" if question.blank?
    raise "Gemini API key is not configured" unless configured?

    response = perform_request(question)
    extract_text(response) || "I could not generate a response right now. Please try again."
  end

  private

  def perform_request(question)
    uri = URI.parse("#{API_URL}?key=#{@api_key}")
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"
    request.body = {
      contents: [
        {
          parts: [
            {
              text: prompt_for(question)
            }
          ]
        }
      ]
    }.to_json

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    response = http.request(request)
    raise "Gemini request failed: #{response.code}" unless response.is_a?(Net::HTTPSuccess)

    JSON.parse(response.body)
  end

  def prompt_for(question)
    <<~PROMPT
      You are Study Bot for a student study app.
      Give concise, helpful, student-friendly answers.
      Prefer clear steps, short paragraphs, and exam-oriented explanations.
      If the user asks an academic question, explain it simply.
      User question: #{question}
    PROMPT
  end

  def extract_text(response)
    response.dig("candidates", 0, "content", "parts")&.filter_map { |part| part["text"] }&.join("\n")&.strip
  end
end
