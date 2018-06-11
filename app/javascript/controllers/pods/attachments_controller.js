import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['source', 'previews']

  get $previews() {
    return $(this.previewsTarget)
  }

  get $source() {
    return $(this.sourceTarget)
  }

  get files() {
    return this.sourceTarget.files
  }

  get length() {
    return this.files.length
  }

  picked(e) {
    this._renderComponent()
  }

  _generatePreviews() {
    for (let i = 0; i < this.files.length; i++) {
      let preview = $('<img/>')
      preview.attr('src', window.URL.createObjectURL(this.files[i]))
      preview.addClass('rounded border attachment-preview')
      this.$previews.append(preview)
    }
  }

  _renderComponent() {
    this.$previews.empty()

    if (this.length > 0) {
      this.$previews.removeClass('d-none')
      this._generatePreviews()
    } else {
      this.$previews.addClass('d-none')
    }
  }
}
