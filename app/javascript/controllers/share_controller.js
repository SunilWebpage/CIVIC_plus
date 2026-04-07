import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    title: String,
    text: String,
    url: String
  }

  async share() {
    const payload = {
      title: this.titleValue,
      text: this.textValue,
      url: this.absoluteUrl()
    }

    if (navigator.share) {
      try {
        await navigator.share(payload)
        return
      } catch (_error) {
      }
    }

    await navigator.clipboard.writeText([payload.title, payload.text, payload.url].filter(Boolean).join("\n"))
    window.alert("Question link copied.")
  }

  absoluteUrl() {
    if (this.urlValue.startsWith("http://") || this.urlValue.startsWith("https://")) {
      return this.urlValue
    }

    return `${window.location.origin}${this.urlValue}`
  }
}
