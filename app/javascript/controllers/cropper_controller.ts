import { Controller } from 'stimulus'
import { Croppie } from 'croppie'

export default class extends Controller {
  static targets = ['image', 'action', 'trigger']

  private imageTarget: HTMLImageElement
  private triggerTargets: HTMLButtonElement[]
  private croppie: Croppie
  private errorListener: () => void

  initialize() {
    this.errorListener = this.error.bind(this)
    this.croppie = new Croppie(this.imageTarget, {
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

  async save() {
    this.disableForm()

    const blob = await this.croppie.result('blob')

    const formData = new FormData()
    const filename = this.data.get('filename')

    formData.append('avatar[image]', blob, filename)

    Rails.ajax({
      type: 'PUT',
      url: '/me/avatar',
      data: formData,
      dataType: 'html',
      error: this.errorListener,
    })
  }

  private error() {
    this.enableForm()
    alert('Snaps! Please try again.')
  }

  private disableForm() {
    this.triggerTargets.forEach(trigger => {
      trigger.disabled = true
      trigger.classList.add('disabled')
    })
  }

  private enableForm() {
    this.triggerTargets.forEach(trigger => {
      trigger.disabled = false
      trigger.classList.remove('disabled')
    })
  }
}
