import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "filename", "filled", "dropzone"]

  change() {
    const file = this.inputTarget.files[0]
    if (!file) return

    this.previewTarget.src = URL.createObjectURL(file)
    this.filenameTarget.textContent = file.name

    this.filledTarget.classList.remove("hidden")
    this.filledTarget.classList.add("flex")
    this.dropzoneTarget.classList.add("hidden")
    this.dropzoneTarget.classList.remove("flex")
  }
}
