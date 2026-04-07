import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    title: String,
    text: String,
    confirmButtonText: String,
    cancelButtonText: String
  }

  async confirm(event) {
    event.preventDefault()

    const result = await window.Swal.fire({
      title: this.titleValue || "Are you sure?",
      text: this.textValue || "This action cannot be undone.",
      icon: "warning",
      showCancelButton: true,
      confirmButtonText: this.confirmButtonTextValue || "Yes",
      cancelButtonText: this.cancelButtonTextValue || "Cancel",
      confirmButtonColor: "#8b3a2d",
      cancelButtonColor: "#486250"
    })

    if (result.isConfirmed) {
      this.element.submit()
    }
  }
}
