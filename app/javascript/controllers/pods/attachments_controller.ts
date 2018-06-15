import { Controller } from 'stimulus'

const MAX_SIZE: number = 1024 * 1024 * 5

enum FileType {
  JPEG,
  PNG,
  GIF,
  UNSUPPORTED,
}

interface FileMetada {
  type: FileType
  size: number
}

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

    const meta = await this.extractFileMetadata(this.files[0])

    if (meta.type == FileType.GIF) {
      this.error('noGif')
    } else if (meta.type == FileType.UNSUPPORTED) {
      this.error('noImg')
    }

    if (meta.size > MAX_SIZE) {
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

  private extractFileMetadata(file: File): Promise<FileMetada> {
    return new Promise<FileMetada>((resolve, reject) => {
      if (!file) {
        reject(new Error('Missing file'))
        return
      }

      const reader = new FileReader()

      reader.onloadend = e => {
        let header = ''
        const arr = new Uint8Array(e.target.result).subarray(0, 4)

        for (let i = 0; i < arr.length; i++) {
          header += arr[i].toString(16)
        }

        const metadata: FileMetada = {
          type: FileType.UNSUPPORTED,
          size: file.size,
        }

        switch (header) {
          case '89504e47':
            metadata.type = FileType.PNG
            break
          case 'ffd8ffe0':
          case 'ffd8ffe1':
          case 'ffd8ffe2':
          case 'ffd8ffe3':
          case 'ffd8ffe8':
            metadata.type = FileType.JPEG
            break
          case '47494638':
            metadata.type = FileType.GIF
            break
          default:
            metadata.type = FileType.UNSUPPORTED
            break
        }

        resolve(metadata)
      }

      reader.readAsArrayBuffer(file.slice(0, 4))
    })
  }
}
