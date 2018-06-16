import { Controller } from 'stimulus'
import { FileType, extractFileMetadata } from '../../utils/file'
import { MAX_IMAGE_SIZE } from '../../constants'

export default class extends Controller {
  static targets = ['source', 'previews']

  private previewsTarget: HTMLElement
  private sourceTarget: HTMLInputElement
  private ajaxSuccess: (e: any) => void

  connect() {
    this.podForm.addEventListener('ajax:success', this.ajaxSuccess)
  }

  initialize(): void {
    this.ajaxSuccess = this.podSaved.bind(this)
  }

  disconnect() {
    if (this.podForm) {
      this.podForm.removeEventListener('ajax:success', this.ajaxSuccess)
    }
  }

  get files(): FileList {
    return this.sourceTarget.files
  }

  get length(): number {
    return this.files.length
  }

  get podForm(): HTMLElement {
    return document.querySelector('#new_pod')
  }

  get podSubmit(): HTMLButtonElement {
    return document.querySelector('#new_pod input[type=submit')
  }

  get podTextarea(): HTMLTextAreaElement {
    return document.querySelector('#pod_content')
  }

  ajaxError(): void {
    this.podSubmit.disabled = false
    this.podTextarea.disabled = false
  }

  async picked() {
    if (!this.hasAttachment()) {
      return
    }

    const meta = await extractFileMetadata(this.files[0])

    if (meta.type == FileType.GIF) {
      this.error('noGif')
    } else if (meta.type == FileType.UNSUPPORTED) {
      this.error('noImg')
    }

    if (meta.size > MAX_IMAGE_SIZE) {
      this.error('tooBig')
    }

    this.renderComponent()
  }

  private hasAttachment(): boolean {
    return this.length > 0
  }

  private podSaved(e): void {
    const [response, status] = (e as Rails.AjaxEvent).detail

    if (status === 'OK' && response && response.id) {
      if (this.hasAttachment()) {
        const action = this.data.get('url').replace('id', response.id)
        this.element.setAttribute('action', action)
        Rails.fire(this.element as HTMLElement, 'submit')
      } else {
        Turbolinks.clearCache()
        Turbolinks.visit('/')
      }
    }
  }

  private error(error: string): void {
    this.sourceTarget.value = null
    this.clearPreviews()
    alert(this.data.get(error))
  }

  private clearPreviews(): void {
    while (this.previewsTarget.firstChild) {
      this.previewsTarget.removeChild(this.previewsTarget.firstChild)
    }
  }

  private generatePreviews(): void {
    for (let i = 0; i < this.length; i++) {
      let preview = document.createElement('img')
      preview.setAttribute('src', window.URL.createObjectURL(this.files[i]))
      preview.classList.add('img-fluid')
      this.previewsTarget.appendChild(preview)
    }
  }

  private renderComponent(): void {
    this.clearPreviews()

    if (this.hasAttachment()) {
      this.previewsTarget.classList.remove('d-none')
      this.generatePreviews()
    } else {
      this.previewsTarget.classList.add('d-none')
    }
  }
}
