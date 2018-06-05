import { Controller } from 'stimulus'
import autosize from 'autosize'

const MAX_POD_LENGTH = 280
const WARNING_POD_LENGTH = 260

export default class extends Controller {
  static targets = ['counterify', 'content', 'progress', 'submit']

  initialize() {
    this._expandForm()
    autosize(this.contentTarget)
  }

  disconnect() {
    autosize.destroy(this.contentTarget)
  }

  get $submit() {
    return $(this.submitTarget)
  }

  get $counterify() {
    return $(this.counterifyTarget)
  }

  get $progress() {
    return $(this.progressTarget)
  }

  get $content() {
    return $(this.contentTarget)
  }

  get content() {
    return this.contentTarget.value
  }

  word() {
    const currentLength = this.content.length
    this._renderProgress(currentLength)

    const progressWidth = currentLength * 100 / MAX_POD_LENGTH

    this.$progress.css('width', `${progressWidth}%`)
  }

  onFocus() {
    this._expandForm(true)
  }

  onBlur() {
    this._expandForm()
  }

  _expandForm(force = false) {
    if (force || this.content.length > 0) {
      this.$submit.removeClass('d-none')
      this.$content.attr('rows', 3)
      this.$content.parent().removeClass('mb-0')
    } else {
      this.$submit.addClass('d-none')
      this.$content.attr('rows', 1)
      this.$content.parent().addClass('mb-0')
    }

    autosize.update(this.contentTarget)
  }

  _renderProgress(length) {
    if (length > 0) {
      this.$counterify.removeClass('d-none')
    } else {
      this.$counterify.addClass('d-none')
    }

    this.$progress.removeClass('bg-danger').removeClass('bg-warning')

    if (length > MAX_POD_LENGTH) {
      this.$progress.addClass('bg-danger')
    } else if (length > WARNING_POD_LENGTH && length <= MAX_POD_LENGTH) {
      this.$progress.addClass('bg-warning')
    }
  }
}
