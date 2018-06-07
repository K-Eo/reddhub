import { Controller } from 'stimulus'
import autosize from 'autosize'

export default class extends Controller {
  static targets = ['source', 'submit']

  initialize() {
    this.word()
    autosize(this.contentTarget)
  }

  disconnect() {
    autosize.destroy(this.contentTarget)
  }

  get $submit() {
    return $(this.submitTarget)
  }

  get contentLength() {
    return this.contentTarget.value.length
  }

  hasContentInRange() {
    return (
      this.sourceTarget.value &&
      this.sourceTarget.value.length > 0 &&
      this.sourceTarget.value.length <= 280
    )
  }

  word() {
    this._enableSubmit()
  }

  _enableSubmit() {
    if (this.hasContentInRange()) {
      this.$submit.prop('disabled', false)
    } else {
      this.$submit.prop('disabled', true)
    }
  }
}
