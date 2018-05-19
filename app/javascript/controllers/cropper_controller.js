import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['image']

  initialize() {
    $(this.imageTarget).croppie({
      viewport: {
        width: 256,
        height: 256,
      },
      boundary: {
        width: '100%',
        height: 500,
      },
    })
  }

  save() {
    $(this.imageTarget)
      .croppie('result', 'blob')
      .then(blob => {
        const actions = $('.js-action')
        actions.addClass('disabled')
        const formData = new FormData()
        const filename = this.imageTarget.getAttribute('data-filename')

        formData.append('avatar[image]', blob, filename)

        Rails.ajax({
          type: 'PUT',
          url: '/me/avatar',
          data: formData,
          dataType: 'html',
          error: () => {
            actions.removeClass('disabled')
            alert('Snaps! Please try again.')
          },
        })
      })
  }
}
