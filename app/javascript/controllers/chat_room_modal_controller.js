import { Controller } from "@hotwired/stimulus"

const TEMPLATES = {
  create: (token, url) => `
    <button type="button" class="chat-modal-backdrop"></button>
    <section class="chat-modal-card" aria-labelledby="create-room-title">
      <div class="chat-modal-header">
        <div>
          <span class="eyebrow">Room</span>
          <div id="create-room-title" class="chat-form-title">Create room</div>
        </div>
        <button type="button" class="text-link chat-modal-close">Close</button>
      </div>
      <p class="text-note">Create a room, set a password, and decide how you appear to other members.</p>
      <form action="${url}" method="post">
        <input type="hidden" name="authenticity_token" value="${token}">
        <input type="text" name="room[name]" class="form-input" placeholder="Room name" required>
        <input type="password" name="room[password]" class="form-input" placeholder="Room password" required>
        <input type="password" name="room[password_confirmation]" class="form-input" placeholder="Confirm password" required>
        <input type="text" name="display_name" class="form-input" placeholder="Your display name">
        <button type="submit" class="button button-primary">Create room</button>
      </form>
    </section>
  `,

  join: (token, url) => `
    <button type="button" class="chat-modal-backdrop"></button>
    <section class="chat-modal-card" aria-labelledby="join-room-title">
      <div class="chat-modal-header">
        <div>
          <span class="eyebrow">Room</span>
          <div id="join-room-title" class="chat-form-title">Join room</div>
        </div>
        <button type="button" class="text-link chat-modal-close">Close</button>
      </div>
      <p class="text-note">Enter the room name and password provided by the admin.</p>
      <form action="${url}" method="post">
        <input type="hidden" name="authenticity_token" value="${token}">
        <input type="text" name="name" class="form-input" placeholder="Room name" required>
        <input type="password" name="password" class="form-input" placeholder="Room password" required>
        <input type="text" name="display_name" class="form-input" placeholder="Your display name">
        <button type="submit" class="button button-primary">Join room</button>
      </form>
    </section>
  `
}

export default class extends Controller {
  static values = {
    createUrl: String,
    joinUrl: String
  }

  connect() {
    this.overlay = null
  }

  open(event) {
    event.preventDefault()
    const type = event.currentTarget.dataset.chatRoomModalTypeValue
    const url = type === "join" ? this.joinUrlValue : this.createUrlValue
    if (!url) return
    this.close()

    const token = document.querySelector("meta[name='csrf-token']")?.content ?? ""
    const overlay = document.createElement("div")
    overlay.className = "chat-modal"
    overlay.innerHTML = TEMPLATES[type]?.(token, url) ?? ""
    if (!overlay.innerHTML.trim()) return

    const label =
      type === "join" ? "Close join room popup" : "Close create room popup"

    const backdrop = overlay.querySelector(".chat-modal-backdrop")
    const closeButton = overlay.querySelector(".chat-modal-close")
    backdrop?.setAttribute("aria-label", label)
    backdrop?.addEventListener("click", (closeEvent) => this.close(closeEvent))
    closeButton?.addEventListener("click", (closeEvent) => this.close(closeEvent))
    overlay.querySelector("form")?.addEventListener("submit", () => this.close())

    document.body.appendChild(overlay)
    this.overlay = overlay
  }

  close(event) {
    event?.preventDefault()
    this.closeOverlay()
  }

  closeOverlay() {
    if (this.overlay) {
      this.overlay.remove()
      this.overlay = null
    }
  }
}
