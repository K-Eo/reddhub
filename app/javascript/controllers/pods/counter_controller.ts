import { Controller } from 'stimulus'

const MAX_POD_LENGTH: number = 280
const WARNING_POD_LENGTH: number = 260

export default class extends Controller {
  static targets = ['source', 'component', 'counter']

  private sourceTarget: HTMLInputElement
  private componentTarget: HTMLElement
  private counterTarget: HTMLElement

  initialize(): void {
    this.renderComponent()
    this.updateProgress()
  }

  get length(): number {
    return this.sourceTarget.value.length
  }

  update(): void {
    this.renderComponent()
    this.updateProgress()
  }

  private updateProgress(): void {
    const progressWidth = this.length * 100 / MAX_POD_LENGTH
    this.counterTarget.style.width = `${progressWidth}%`
  }

  private renderComponent(): void {
    if (this.length > 0) {
      this.componentTarget.classList.remove('d-none')
    } else {
      this.componentTarget.classList.add('d-none')
    }

    this.counterTarget.classList.remove('bg-danger', 'bg-warning')

    if (this.length > MAX_POD_LENGTH) {
      this.counterTarget.classList.add('bg-danger')
    } else if (
      this.length > WARNING_POD_LENGTH &&
      this.length <= MAX_POD_LENGTH
    ) {
      this.counterTarget.classList.add('bg-warning')
    }
  }
}
