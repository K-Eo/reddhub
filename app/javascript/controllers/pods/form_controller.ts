import { Controller } from 'stimulus'
import autosize from 'autosize'

export default class extends Controller {
  static targets = ['source', 'submit']

  private sourceTarget: HTMLInputElement
  private submitTarget: HTMLButtonElement

  initialize(): void {
    this.word()
    autosize(this.sourceTarget)
  }

  disconnect(): void {
    autosize.destroy(this.sourceTarget)
  }

  word(): void {
    this.enableSubmit()
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
