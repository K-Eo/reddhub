import { Controller } from 'stimulus'

const MAX_AVATAR_SIZE = 1024 * 1024 * 5

export default class extends Controller {
  static targets = ['image', 'feedback']

  initialize() {
    this.submit.addClass('d-none')

    this.imageTarget.addEventListener('direct-upload:initialize', e => {
      const { id } = e.detail

      $('.js-resize-avatar').addClass('disabled')

      this.setFeedback('is-loading')

      $('.loading').html(`
        <div class="progress progress-bar-striped progress-bar-animated mb-2"
          style="height: 4px;"
          id="direct-upload-${id}"
        >
          <div class="progress-bar "
            id="direct-upload-progress-${id}"
            role="progressbar"
            style="width: 0;"
            aria-valuenow="0"
            aria-valuemin="0"
            aria-valuemax="100"></div>
        </div>
      `)
    })

    this.imageTarget.addEventListener('direct-upload:start', e => {
      $(`#direct-upload-${e.detail.id}`)
        .removeClass('progress-bar-striped')
        .removeClass('progress-bar-animated')
    })

    this.imageTarget.addEventListener('direct-upload:progress', e => {
      const { id, progress } = event.detail
      $(`#direct-upload-progress-${e.detail.id}`).css('width', `${progress}%`)
    })

    this.imageTarget.addEventListener('direct-upload:error', e => {
      e.preventDefault()
      this.resetImage()
      this.setFeedback('has-failure')
    })

    this.imageTarget.addEventListener('direct-upload:end', () => {
      $('.loading').html('')
      Rails.enableElement(document.querySelector('.new_avatar'))
      $('.js-resize-avatar').removeClass('disabled')
    })
  }

  get submit() {
    return $('#new_avatar input[type=submit]')
  }

  resetImage() {
    $('form')[0].reset()
  }

  setFeedback(klass) {
    if (klass) {
      this.resetFeedback().addClass(klass)
    }
  }

  resetFeedback() {
    return $(this.feedbackTarget)
      .removeClass()
      .addClass('is-default')
  }

  onPickImage() {
    this.resetFeedback()
    if (!this.imageTarget.files && !this.imageTarget.files[0]) {
      return
    }

    const currentFile = this.imageTarget.files[0]
    const reader = new FileReader()
    const size = currentFile.size

    if (size > MAX_AVATAR_SIZE) {
      this.setFeedback('is-big')
      this.resetImage()
      return
    }

    reader.onload = e => this.onReadLoaded(e)
    reader.readAsDataURL(currentFile)
  }

  onReadLoaded(e) {
    const image = new Image()
    const that = this

    image.onload = function() {
      if (this.width < 256 || this.height < 256) {
        that.resetImage()
        that.setFeedback('is-small')
        return
      }

      that.submit.click()
    }

    image.src = e.target.result
  }
}
