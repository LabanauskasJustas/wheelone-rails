import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  change() {
    this.submit()
  }

  input() {
    clearTimeout(this._debounce)
    this._debounce = setTimeout(() => this.submit(), 400)
  }

  submit() {
    this.element.requestSubmit()
  }
}
