import { Controller } from 'stimulus'

import { MAX_IMAGE_SIZE } from '../constants'
import { FileType } from '../utils/file'
import validates from '../validations/validates'

export default class extends Controller {
  static targets = ['label', 'source', 'submit', 'error']

  private labelTarget: HTMLLabelElement
  private sourceTarget: HTMLInputElement
  private submitTarget: HTMLInputElement
  private errorTarget: HTMLParagraphElement

  initialize() {
    this.submitTarget.remove()
  }

  @validates({
    source: {
      file_type: { types: [FileType.JPEG, FileType.PNG] },
      file_size: { max: MAX_IMAGE_SIZE },
      file_with_height: { width: 256, height: 256 },
    },
  })
  pick() {
    const element = this.element as HTMLFormElement
    this.enableForm()
    element.submit()
    this.disableForm()
  }

  private beforeValidation() {
    this.disableForm()
  }

  private failureValidation(property, error) {
    this.enableForm()
    this.errorTarget.classList.remove('d-none')
    this.errorTarget.innerText = this.data.get(error.validator)
  }

  private enableForm() {
    this.errorTarget.classList.add('d-none')
    this.errorTarget.innerHTML = ''
    this.labelTarget.classList.remove('disabled')
    this.sourceTarget.disabled = false
  }

  private disableForm() {
    this.labelTarget.classList.add('disabled')
    this.sourceTarget.disabled = true
  }
}
