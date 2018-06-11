import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['form', 'placeholder', 'source', 'attachments']

  initialize() {
    if (this.hasContent()) {
      this.show()
      this.$source.focus()
    }

    this.$placeholder.attr('placeholder', this.$source.attr('placeholder'))

    this.mouseListener = e => {
      if (
        !this.$source.is(e.target) &&
        !this.$attachments.is(e.target) &&
        this.$attachments.has(e.target).length === 0 &&
        !this.hasContent()
      ) {
        this.hide()
      }
    }
  }

  disconnect() {
    document.removeEventListener('mouseup', this.mouseListener)
  }

  get $form() {
    return $(this.formTarget)
  }

  get $placeholder() {
    return $(this.placeholderTarget)
  }

  get $source() {
    return $(this.sourceTarget)
  }

  get $attachments() {
    return $(this.attachmentsTarget)
  }

  hasContent() {
    return this.sourceTarget.value && this.sourceTarget.value.length > 0
  }

  onFocus() {
    this.show()
  }

  onBlur() {
    if (this.hasContent()) {
      return
    }
  }

  hide() {
    document.removeEventListener('mouseup', this.mouseListener)
    this.$form.addClass('d-none')
    this.$placeholder.removeClass('d-none')
  }

  show() {
    this.$placeholder.addClass('d-none')
    this.$form.removeClass('d-none')
    this.$source.focus()
    document.addEventListener('mouseup', this.mouseListener)
  }
}
