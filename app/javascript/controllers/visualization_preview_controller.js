import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["carSelect", "carPreview", "carPlaceholder", "rimSelect", "rimPreview", "rimPlaceholder"]

  connect() {
    this.updateCarPreview()
    this.updateRimPreview()
  }

  carChanged() { this.updateCarPreview() }
  rimChanged() { this.updateRimPreview() }

  updateCarPreview() {
    const select = this.carSelectTarget
    const option = select.options[select.selectedIndex]
    const url = option && option.dataset.photoUrl
    this.showPreview(url, this.carPreviewTarget, this.carPlaceholderTarget)
  }

  updateRimPreview() {
    const select = this.rimSelectTarget
    const option = select.options[select.selectedIndex]
    const url = option && option.dataset.photoUrl
    this.showPreview(url, this.rimPreviewTarget, this.rimPlaceholderTarget)
  }

  showPreview(url, previewEl, placeholderEl) {
    if (url && url.length > 0) {
      previewEl.src = url
      previewEl.classList.remove("hidden")
      placeholderEl.classList.add("hidden")
    } else {
      previewEl.removeAttribute("src")
      previewEl.classList.add("hidden")
      placeholderEl.classList.remove("hidden")
    }
  }
}
