import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "messages"]

  ask(event) {
    event.preventDefault()

    const question = this.inputTarget.value.trim()
    if (!question) return

    this.appendMessage("You", question, true)
    this.inputTarget.value = ""

    const answer = this.buildAnswer(question)
    this.appendMessage("Study Bot", answer, false)
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }

  useSuggestion(event) {
    this.inputTarget.value = event.currentTarget.dataset.question
    this.inputTarget.focus()
  }

  appendMessage(sender, text, own) {
    const message = document.createElement("article")
    message.className = `bot-message ${own ? "bot-message-own" : ""}`.trim()

    const senderNode = document.createElement("div")
    senderNode.className = "bot-message-name"
    senderNode.textContent = sender

    const bodyNode = document.createElement("p")
    bodyNode.className = "bot-message-body"
    bodyNode.textContent = text

    message.append(senderNode, bodyNode)
    this.messagesTarget.append(message)
  }

  buildAnswer(question) {
    const lower = question.toLowerCase()

    if (lower.includes("math")) {
      return "For critical maths questions: 1. Write the given values. 2. Identify the formula. 3. Substitute carefully. 4. Solve line by line. 5. Recheck units and signs before the final answer."
    }

    if (lower.includes("science")) {
      return "For science answers: start with the definition, then explain the process in 2 to 4 simple points, add one example, and end with the result or application."
    }

    if (lower.includes("social")) {
      return "For social science critical questions: answer in order using introduction, main points with dates/names, and a short conclusion. Keep each point separate so it is easy to score."
    }

    if (lower.includes("tamil")) {
      return "For Tamil preparation: read the lesson once, mark important lines, practice book back questions, and write short answers from memory twice for retention."
    }

    if (lower.includes("critical") || lower.includes("hard") || lower.includes("difficult")) {
      return "For critical questions, break the problem into three parts: what is asked, what facts are already known, and what method should be used. Then solve each part one by one instead of trying to answer in one jump."
    }

    return "I can help with study questions, difficult problems, answer formats, revision steps, and exam preparation. Ask me subject-wise and I will guide you with a simple solution method."
  }
}
