import { Controller } from 'stimulus'

import {
  extractFileMetadata,
  extractImageMetadata,
  FileType,
} from '../utils/file'
import { MAX_IMAGE_SIZE } from '../constants'

export default class extends Controller {
  static targets = [
    'image',
    'feedback',
    'submit',
    'value',
    'progress',
    'label',
    'crop',
  ]

  private labelTarget: HTMLLabelElement
  private cropTarget: HTMLAnchorElement
  private hasCropTarget: boolean
  private imageTarget: HTMLInputElement
  private feedbackTarget: HTMLDivElement
  private submitTarget: HTMLInputElement
  private progressTarget: HTMLDivElement
  private valueTarget: HTMLDivElement

  private initializeListener: () => void
  private startListener: () => void
  private progressListener: () => void
  private errorListener: () => void
  private endListener: () => void

  initialize() {
    this.submitTarget.disabled = true
    this.submitTarget.classList.add('d-none')

    this.initializeListener = this.init.bind(this)
    this.startListener = this.start.bind(this)
    this.progressListener = this.progress.bind(this)
    this.errorListener = this.error.bind(this)
    this.endListener = this.end.bind(this)

    this.imageTarget.addEventListener(
      'direct-upload:initialize',
      this.initializeListener
    )
    this.imageTarget.addEventListener(
      'direct-upload:progress',
      this.progressListener
    )
    this.imageTarget.addEventListener('direct-upload:start', this.startListener)
    this.imageTarget.addEventListener('direct-upload:error', this.errorListener)
    this.imageTarget.addEventListener('direct-upload:end', this.endListener)
  }

  disconnect() {
    this.imageTarget.removeEventListener(
      'direct-upload:initialize',
      this.initializeListener
    )
    this.imageTarget.removeEventListener(
      'direct-upload:start',
      this.startListener
    )
    this.imageTarget.removeEventListener(
      'direct-upload:progress',
      this.progressListener
    )
    this.imageTarget.removeEventListener(
      'direct-upload:error',
      this.errorListener
    )
    this.imageTarget.removeEventListener('direct-upload:end', this.endListener)
  }

  private init(): void {
    this.setFeedback('is-loading')
    this.disable()
  }

  private start(): void {
    this.progressTarget.classList.remove(
      'progress-bar-striped',
      'progress-bar-animated'
    )
  }

  private progress(e: any): void {
    const { progress } = e.detail

    this.valueTarget.style.width = `${progress}%`
  }

  private error(e: any): void {
    e.preventDefault()

    this.resetImage()
    this.setFeedback('has-failure')
  }

  private end(): void {
    this.resetFeedback()

    this.progressTarget.classList.add(
      'progress-bar-striped',
      'progress-bar-animated'
    )
    this.valueTarget.style.width = '0'

    Rails.enableElement(this.element as HTMLElement)
    this.enable()
  }

  private setFeedback(klass) {
    if (klass) {
      this.resetFeedback()
      this.feedbackTarget.classList.add(klass)
    }
  }

  private resetFeedback() {
    while (this.feedbackTarget.classList.length > 0) {
      this.feedbackTarget.classList.remove(
        this.feedbackTarget.classList.item(0)
      )
    }

    this.feedbackTarget.classList.add('is-default')
  }

  resetImage() {
    ;(this.element as HTMLFormElement).reset()
  }

  async onPickImage() {
    this.resetFeedback()

    if (!this.imageTarget.files && !this.imageTarget.files[0]) {
      return
    }

    const currentFile = this.imageTarget.files[0]

    const meta = await extractFileMetadata(currentFile)

    if (meta.size > MAX_IMAGE_SIZE) {
      this.setFeedback('is-big')
      this.resetImage()
      return
    }

    if (meta.type == FileType.GIF || meta.type == FileType.UNSUPPORTED) {
      this.setFeedback('is-img')
      this.resetImage()
      return
    }

    const img = await extractImageMetadata(currentFile)

    if (img.width < 256 || img.height < 256) {
      this.resetImage()
      this.setFeedback('is-small')
      return
    }

    Rails.fire(this.element as HTMLFormElement, 'submit')
  }

  private disable() {
    this.labelTarget.classList.add('disabled')
    this.imageTarget.disabled = true

    if (this.hasCropTarget) {
      this.cropTarget.classList.add('disabled')
    }
  }

  private enable() {
    this.labelTarget.classList.remove('disabled')
    this.imageTarget.disabled = false

    if (this.hasCropTarget) {
      this.cropTarget.classList.remove('disabled')
    }
  }
}
