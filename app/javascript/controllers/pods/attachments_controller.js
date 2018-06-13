import { Controller } from 'stimulus'

const MAX_SIZE = 1024 * 1024 * 5

export default class extends Controller {
  static targets = ['source', 'previews']

  initialize() {
    this.podForm = document.querySelector('#new_pod')
    this.podForm.addEventListener('ajax:success', e => this._podSaved(e))
  }

  get $previews() {
    return $(this.previewsTarget)
  }

  get $source() {
    return $(this.sourceTarget)
  }

  get length() {
    return this.files.length
  }

  get files() {
    return this.sourceTarget.files
  }

  picked() {
    this._extractMetadata(e => this._validate(e))
  }

  _extractMetadata(callback) {
    const file = this.files[0]
    const reader = new FileReader()

    reader.onloadend = function(e) {
      const arr = new Uint8Array(e.target.result).subarray(0, 4)
      let header = ''
      for (let i = 0; i < arr.length; i++) {
        header += arr[i].toString(16)
      }

      callback({
        header: header,
        size: file.size,
      })
    }

    reader.readAsArrayBuffer(file.slice(0, 4))
  }

  _validate(meta) {
    switch (meta.header) {
      case '89504e47': // image/png
      case 'ffd8ffe0': // image/jpeg
      case 'ffd8ffe1':
      case 'ffd8ffe2':
      case 'ffd8ffe3':
      case 'ffd8ffe8':
        break
      case '47494638': // image/gif
        return this._error('noGif')
      default:
        return this._error('noImg')
    }

    if (meta.size > MAX_SIZE) {
      return this._error('tooBig')
    }

    this._renderComponent()
  }

  _error(error) {
    this.sourceTarget.value = null
    this.$previews.empty()
    alert(this.data.get(error))
  }

  _hasAttachment() {
    return this.length > 0
  }

  _podSaved(e) {
    const [response, status] = e.detail
    if (status === 'OK' && response && response.id && this._hasAttachment()) {
      const action = this.data.get('url').replace('id', response.id)
      this.element.setAttribute('action', action)
      Rails.fire(this.element, 'submit')
    }
  }

  _generatePreviews() {
    for (let i = 0; i < this.length; i++) {
      let preview = $('<img/>')
      preview.attr('src', window.URL.createObjectURL(this.files[i]))
      preview.addClass('img-fluid')
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
