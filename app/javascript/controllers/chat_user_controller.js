import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    createUrl: String
  }

  initialize() {
    this.overlay = null
  }

  open(event) {
    event.preventDefault()
    this.closeOverlay()

    const trigger = event.currentTarget
    const userId = trigger.dataset.chatUserIdValue
    const email = trigger.dataset.chatUserEmailValue
    const createUrl = trigger.dataset.chatUserCreateUrlValue || this.createUrlValue

    if (!userId || !email || !createUrl) return

    const token = document.querySelector("meta[name='csrf-token']")?.content ?? ""
    const overlay = document.createElement("div")
    overlay.className = "chat-user-overlay"
    overlay.innerHTML = `
      <div class="chat-user-popup">
        <div class="chat-user-popup-header">
          <div>
            <span class="eyebrow">Direct Message</span>
            <div class="chat-user-popup-title">${email}</div>
          </div>
          <button type="button" class="text-link chat-modal-close" data-action="click->chat-user#close">Cancel</button>
        </div>
        <p class="text-note">Send a private message to ${email}.</p>
        <form action="${createUrl}" method="post">
          <input type="hidden" name="authenticity_token" value="${token}">
          <input type="hidden" name="user_id" value="${userId}">
          <button type="submit" class="button button-primary">Start chat</button>
        </form>
      </div>
    `

    overlay.addEventListener("click", (closeEvent) => {
      if (closeEvent.target === overlay) {
        this.close(closeEvent)
      }
    })

    document.body.appendChild(overlay)
    this.overlay = overlay
  }

  close(event) {
    if (event) event.preventDefault()
    this.closeOverlay()
  }

  closeOverlay() {
    if (this.overlay) {
      this.overlay.remove()
      this.overlay = null
    }
  }
}
