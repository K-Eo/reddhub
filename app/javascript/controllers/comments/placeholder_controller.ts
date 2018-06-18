import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['form', 'placeholder', 'source']

  private formTarget: HTMLDivElement
  private placeholderTarget: HTMLDivElement
  private sourceTarget: HTMLInputElement
  private hideListener: (e: MouseEvent) => void

  initialize() {
    this.hideListener = this.hide.bind(this)

    if (this.hasContent() || this.hasError()) {
      this.show()
    }
  }

  onFocus() {
    this.show()
  }

  private hasError(): boolean {
    return this.sourceTarget.classList.contains('is-invalid')
  }

  private hasContent(): boolean {
    return this.sourceTarget.value && this.sourceTarget.value.length > 0
  }

  private show(): void {
    this.placeholderTarget.classList.add('d-none')
    this.formTarget.classList.remove('d-none')
    this.sourceTarget.focus()
    this.attachEvents()
  }

  private hide(e: MouseEvent): void {
    const target = e.target as HTMLElement

    if (this.sourceTarget != target && !this.hasContent()) {
      this.detachEvents()
      this.formTarget.classList.add('d-none')
      this.placeholderTarget.classList.remove('d-none')
    }
  }

  private attachEvents() {
    document.addEventListener('mouseup', this.hideListener)
  }

  private detachEvents() {
    document.removeEventListener('mouseup', this.hideListener)
  }
}
