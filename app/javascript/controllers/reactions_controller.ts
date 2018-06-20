import { Controller } from 'stimulus'

interface Emoji {
  name: string
  src: string
  alt: string
}

const EMOJI_REACIONS: Array<Emoji> = [
  { name: '+1', src: '1f44d', alt: '👍' },
  { name: 'heart', src: '2764', alt: '❤' },
  { name: 'laughing', src: '1f606', alt: '😆' },
  { name: 'astonished', src: '1f632', alt: '😲' },
  { name: 'disappointed_relieved', src: '1f625', alt: '😥' },
  { name: 'rage', src: '1f621', alt: '😡' },
]

export default class extends Controller {
  static targets = ['picker', 'toggler']

  private autocloseListener: (e: MouseEvent) => void
  private pickerTarget: HTMLDivElement
  private togglerTarget: HTMLButtonElement
  private popper: Popper

  initialize() {
    this.autocloseListener = this.autoclose.bind(this)
  }

  show() {
    if (this.popper) {
      this.hide()
      return
    }

    this.popper = new Popper(this.togglerTarget, this.pickerTarget, {
      placement: 'top',
      modifiers: {
        offset: {
          offset: '0, 8',
        },
      },
    })

    this.buildReactions().forEach(reaction =>
      this.pickerTarget.appendChild(reaction)
    )

    this.pickerTarget.classList.remove('d-none')
    document.addEventListener('mouseup', this.autocloseListener)
  }

  hide() {
    this.popper.destroy()
    this.popper = null

    while (this.pickerTarget.firstChild) {
      this.pickerTarget.removeChild(this.pickerTarget.firstChild)
    }

    this.pickerTarget.classList.add('d-none')
    document.removeEventListener('mouseup', this.autocloseListener)
  }

  private buildReactions() {
    return EMOJI_REACIONS.map(emoji => this.buildReaction(emoji))
  }

  private buildReaction(emoji: Emoji): HTMLElement {
    const img = document.createElement('img')
    img.draggable = false
    img.title = emoji.name
    img.alt = emoji.alt
    img.classList.add('emoji')
    img.style.width = '18px'
    img.style.height = '18px'
    img.src = `https://twemoji.maxcdn.com/2/svg/${emoji.src}.svg`

    const button = document.createElement('button')
    button.classList.add('btn', 'btn-light', 'border-0', 'js-action')
    button.setAttribute('data-method', 'post')
    button.addEventListener('click', this.react.bind(this, emoji.name))
    button.appendChild(img)

    return button
  }

  private react(name) {
    const formData = new FormData()
    formData.append('name', name)

    Rails.ajax({
      type: 'POST',
      url: this.data.get('href'),
      data: formData,
      dataType: 'script',
    })
  }

  private autoclose(e: MouseEvent) {
    const element = e.target as HTMLElement
    if (
      this.pickerTarget != element &&
      !this.pickerTarget.contains(element) &&
      this.togglerTarget != element &&
      !this.togglerTarget.contains(element)
    ) {
      this.hide()
    }
  }
}
