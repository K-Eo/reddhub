import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['form', 'placeholder', 'source', 'attachments', 'media']

  private formTarget: HTMLFormElement
  private placeholderTarget: HTMLElement
  private sourceTarget: HTMLInputElement
  private attachmentsTarget: HTMLElement
  private mediaTarget: HTMLInputElement
  private mouseListener: (e: MouseEvent) => void

  initialize(): void {
    if (this.hasContent()) {
      this.show()
      this.sourceTarget.focus()
    }

    this.placeholderTarget.setAttribute(
      'placeholder',
      this.sourceTarget.getAttribute('placeholder')
    )

    this.mouseListener = this.tryToCloseForm.bind(this)
  }

  disconnect(): void {
    this.dettachEvents()
  }

  onFocus(): void {
    this.show()
  }

  onBlur(): void {
    if (this.hasContent()) {
      return
    }
  }

  private hasAttachment(): boolean {
    return this.mediaTarget.files.length > 0
  }

  private hasContent(): boolean {
    return this.sourceTarget.value && this.sourceTarget.value.length > 0
  }

  private hide(): void {
    this.dettachEvents()
    this.formTarget.classList.add('d-none')
    this.placeholderTarget.classList.remove('d-none')
  }

  private tryToCloseForm(e: MouseEvent) {
    const target = e.target as HTMLElement

    if (
      this.sourceTarget != target &&
      this.attachmentsTarget != target &&
      !this.attachmentsTarget.contains(target) &&
      !this.hasContent() &&
      !this.hasAttachment()
    ) {
      this.hide()
    }
  }

  private show(): void {
    this.placeholderTarget.classList.add('d-none')
    this.formTarget.classList.remove('d-none')
    this.sourceTarget.focus()
    this.attachEvents()
  }

  private attachEvents() {
    document.addEventListener('mouseup', this.mouseListener)
  }

  private dettachEvents() {
    document.removeEventListener('mouseup', this.mouseListener)
  }
}
