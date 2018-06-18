import { Controller } from 'stimulus'

export default class extends Controller {
  private destroyTimeout: () => void

  initialize() {
    this.destroyTimeout = this.destroy.bind(this)
  }

  close() {
    this.element.classList.remove('show')
    setTimeout(this.destroyTimeout, 150)
  }

  private destroy() {
    this.element.remove()
  }
}
