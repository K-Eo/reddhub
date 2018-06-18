import { Controller } from 'stimulus'
import autosize from 'autosize'

export default class extends Controller {
  static targets = ['source', 'submit']

  private sourceTarget: HTMLTextAreaElement
  private submitTarget: HTMLButtonElement

  initialize() {
    this.typing()
    autosize(this.sourceTarget)
  }

  typing(): void {
    if (this.hasContent()) {
      this.submitTarget.disabled = false
    } else {
      this.submitTarget.disabled = true
    }
  }

  private hasContent(): boolean {
    return this.sourceTarget.value && this.sourceTarget.value.length > 0
  }
}
