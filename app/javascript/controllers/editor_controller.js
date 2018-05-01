import { Controller } from 'stimulus'
import Autosize from 'autosize'

export default class extends Controller {
  static targets = [
    'writeTab',
    'previewTab',
    'writeCard',
    'previewCard',
    'content',
  ]

  initialize() {
    this.isBusy = false
    Autosize(this.content)
  }

  get writeTab() {
    return $(this.writeTabTarget)
  }

  get writeCard() {
    return $(this.writeCardTarget)
  }

  get previewTab() {
    return $(this.previewTabTarget)
  }

  get previewCard() {
    return $(this.previewCardTarget)
  }

  get content() {
    return $(this.contentTarget)
  }

  write(e) {
    e.preventDefault()
    this.writeTab.addClass('active')
    this.previewTab.removeClass('active')

    this.writeCard.removeClass('d-none')
    this.previewCard.addClass('d-none')
  }

  preview(e) {
    e.preventDefault()
    this.writeTab.removeClass('active')
    this.previewTab.addClass('active')

    this.writeCard.addClass('d-none')
    this.previewCard.removeClass('d-none')

    if (this.isBusy) {
      return
    }

    this.isBusy = true

    this.previewCard.html('Loading...')

    const formData = new FormData()
    formData.append('content', this.content.val())

    Rails.ajax({
      type: 'POST',
      url: this.previewTab.attr('href'),
      dataType: 'script',
      data: formData,
      error: () => {
        this.previewCard.html('Check yout internet connection and try again.')
        alert('Snaps! Something wrong happened. Please, try again.')
      },
      complete: () => {
        this.isBusy = false
      },
    })
  }
}
