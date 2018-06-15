import { Controller } from 'stimulus'
import autosize from 'autosize'

export default class extends Controller {
  static targets = ['source', 'submit']

  private sourceTarget: HTMLInputElement
  private submitTarget: HTMLButtonElement

  initialize(): void {
    this.word()
    autosize(this.sourceTarget)
    this.submitTarget.removeAttribute('data-disable-with')
  }

  disconnect(): void {
    autosize.destroy(this.sourceTarget)
  }

  word(): void {
    this.enableSubmit()
  }

  beforeSend(): void {
    this.sourceTarget.disabled = true
    this.submitTarget.disabled = true
  }

  error(): void {
    this.sourceTarget.disabled = false
    this.submitTarget.disabled = false
  }

  private hasContentInRange(): boolean {
    return (
      this.sourceTarget.value &&
      this.sourceTarget.value.length > 0 &&
      this.sourceTarget.value.length <= 280
    )
  }

  private enableSubmit(): void {
    if (this.hasContentInRange()) {
      this.submitTarget.disabled = false
    } else {
      this.submitTarget.disabled = true
    }
  }
}
