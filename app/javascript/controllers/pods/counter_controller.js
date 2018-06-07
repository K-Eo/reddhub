import { Controller } from 'stimulus'

const MAX_POD_LENGTH = 280
const WARNING_POD_LENGTH = 260

export default class extends Controller {
  static targets = ['source', 'component', 'counter']

  initialize() {
    this._renderComponent()
    this._updateProgress()
  }

  get $source() {
    return $(this.sourceTarget)
  }

  get $component() {
    return $(this.componentTarget)
  }

  get $counter() {
    return $(this.counterTarget)
  }

  get length() {
    return this.sourceTarget.value.length
  }

  update() {
    this._renderComponent()
    this._updateProgress()
  }

  _updateProgress() {
    const progressWidth = this.length * 100 / MAX_POD_LENGTH
    this.$counter.css('width', `${progressWidth}%`)
  }

  _renderComponent() {
    if (this.length > 0) {
      this.$component.removeClass('d-none')
    } else {
      this.$component.addClass('d-none')
    }

    this.$counter.removeClass('bg-danger').removeClass('bg-warning')

    if (this.length > MAX_POD_LENGTH) {
      this.$counter.addClass('bg-danger')
    } else if (
      this.length > WARNING_POD_LENGTH &&
      this.length <= MAX_POD_LENGTH
    ) {
      this.$counter.addClass('bg-warning')
    }
  }
}
