import { Controller } from 'stimulus'
import ProgressBar from 'progressbar.js'
import { Story } from '../../types/pod'

const MAX_POD_LENGTH: number = 280
const MAX_STORY_LENGTH: number = 8000
const BG_SUCCESS: string = '#34d058'
const BG_WARNING: string = '#ffc107'
const BG_DANGER: string = '#e83e8c'
const BG_SECONDARY: string = '#eee'

export default class extends Controller {
  static targets = ['source', 'progress']

  private sourceTarget: HTMLInputElement
  private progressTarget: HTMLDivElement
  private progressBar: any
  private beforeCache: () => void
  private maxLength: number

  initialize(): void {
    this.maxLength = MAX_POD_LENGTH

    this.progressBar = new ProgressBar.Circle(this.progressTarget, {
      color: BG_SUCCESS,
      strokeWidth: 20,
      trailColor: BG_SECONDARY,
    })

    this.updateProgress()
    this.beforeCache = this.destroy.bind(this)

    document.addEventListener('turbolinks:before-cache', this.beforeCache)
  }

  get length(): number {
    return this.sourceTarget.value.length
  }

  update(): void {
    this.checkMaxLength()
    this.updateProgress()
  }

  private checkMaxLength() {
    if (Story.hasSignature(this.sourceTarget.value)) {
      this.maxLength = MAX_STORY_LENGTH
    } else {
      this.maxLength = MAX_POD_LENGTH
    }
  }

  private destroy() {
    this.progressBar.destroy()
    document.removeEventListener('turbolinks:before-cache', this.beforeCache)
  }

  private updateProgress(): void {
    let color: string
    const progress = (this.length * 100) / this.maxLength / 100
    const effectiveProgress = progress > 1 ? 1 : progress

    if (progress > 0 && progress <= 0.9) {
      color = BG_SUCCESS
    } else if (progress > 0.9 && progress <= 1) {
      color = BG_WARNING
    } else {
      color = BG_DANGER
    }

    this.progressBar.animate(effectiveProgress, {
      from: { color: color },
      to: { color: color },
      step: (state, circle) => {
        circle.path.setAttribute('stroke', state.color)
      },
    })
  }
}
