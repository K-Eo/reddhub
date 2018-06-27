import { Controller } from 'stimulus'
import autosize from 'autosize'
import Model from '../../types/model'
import { Pod, Story } from '../../types/pod'

enum Models {
  Pod = 0,
  Story = 1,
}

export default class extends Controller {
  static targets = ['source', 'submit']

  private sourceTarget: HTMLInputElement
  private submitTarget: HTMLButtonElement
  private models: [Pod, Story]
  private currentModel: Models

  connect() {
    this.word()
    autosize(this.sourceTarget)
    this.submitTarget.removeAttribute('data-disable-with')
  }

  initialize(): void {
    this.currentModel = Models.Pod
    this.models = [new Pod(), new Story()]
  }

  disconnect(): void {
    autosize.destroy(this.sourceTarget)
  }

  word(): void {
    this.checkForModel()

    const value = this.sourceTarget.value

    if (this.currentModel == Models.Pod) {
      ;(this.getCurrentModel() as Pod).content = value
    } else {
      ;(this.getCurrentModel() as Story).content = value
    }

    this.enableSubmit()
  }

  beforeSend(): void {
    this.sourceTarget.disabled = true
    this.submitTarget.disabled = true
  }

  private checkForModel(): void {
    if (Story.hasSignature(this.sourceTarget.value)) {
      this.currentModel = Models.Story
      this.submitTarget.classList.remove('btn-success')
      this.submitTarget.classList.add('btn-primary')
    } else {
      this.currentModel = Models.Pod
      this.submitTarget.classList.remove('btn-primary')
      this.submitTarget.classList.add('btn-success')
    }
  }

  private getCurrentModel(): Model {
    return this.models[this.currentModel]
  }

  private enableSubmit(): void {
    if (this.getCurrentModel().isValid()) {
      this.submitTarget.disabled = false
    } else {
      this.submitTarget.disabled = true
    }
  }
}
