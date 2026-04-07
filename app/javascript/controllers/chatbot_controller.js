import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { endpoint: String }
  static targets = ["input", "messages"]

  async ask(event) {
    event.preventDefault()

    const question = this.inputTarget.value.trim()
    if (!question) return

    this.appendMessage("You", question, true)
    this.inputTarget.value = ""
    this.setInputDisabled(true)
    this.appendMessage("Study Bot", "Thinking...", false, true)

    try {
      const response = await fetch(this.endpointValue, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
          "Accept": "application/json"
        },
        body: JSON.stringify({ question })
      })

      const payload = await response.json()
      this.removePendingMessage()

      if (!response.ok) {
        this.appendMessage("Study Bot", payload.error || "Unable to get a response right now.", false)
      } else {
        this.appendMessage("Study Bot", payload.answer, false)
      }
    } catch (_error) {
      this.removePendingMessage()
      this.appendMessage("Study Bot", "Network error. Please try again.", false)
    } finally {
      this.setInputDisabled(false)
      this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
    }
  }

  useSuggestion(event) {
    this.inputTarget.value = event.currentTarget.dataset.question
    this.inputTarget.focus()
  }

  appendMessage(sender, text, own, pending = false) {
    const message = document.createElement("article")
    message.className = `bot-message ${own ? "bot-message-own" : ""}`.trim()
    if (pending) message.dataset.pending = "true"

    const senderNode = document.createElement("div")
    senderNode.className = "bot-message-name"
    senderNode.textContent = sender

    const bodyNode = document.createElement("p")
    bodyNode.className = "bot-message-body"
    bodyNode.textContent = text

    message.append(senderNode, bodyNode)
    this.messagesTarget.append(message)
  }

  removePendingMessage() {
    this.messagesTarget.querySelector("[data-pending='true']")?.remove()
  }

  setInputDisabled(disabled) {
    this.inputTarget.disabled = disabled
    this.element.querySelector("button[type='submit']").disabled = disabled
  }
}
