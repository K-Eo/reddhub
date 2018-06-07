import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['form', 'placeholder', 'source']

  initialize() {
    if (this.hasContent()) {
      this.show()
      this.$source.focus()
    }
    this.$placeholder.attr('placeholder', this.$source.attr('placeholder'))
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

    this.hide()
  }

  hide() {
    this.$form.addClass('d-none')
    this.$placeholder.removeClass('d-none')
  }

  show() {
    this.$placeholder.addClass('d-none')
    this.$form.removeClass('d-none')
    this.$source.focus()
  }
}
