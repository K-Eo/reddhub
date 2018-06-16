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
    const type = this.data.get('type')
    const id = this.data.get('id')
    return EMOJI_REACIONS.map(emoji => this.buildReaction(emoji, type, id))
  }

  private buildReaction(emoji: Emoji, type: string, id: string): HTMLElement {
    const name = encodeURIComponent(emoji.name)

    const img = document.createElement('img')
    img.draggable = false
    img.title = emoji.name
    img.alt = emoji.alt
    img.classList.add('emoji')
    img.style.width = '18px'
    img.style.height = '18px'
    img.src = `https://twemoji.maxcdn.com/2/svg/${emoji.src}.svg`

    const a = document.createElement('a')
    a.classList.add('btn', 'btn-light', 'border-0', 'js-action')
    a.rel = 'nofollow'
    a.setAttribute('data-method', 'post')
    a.href = `/${type}/${id}/reaction?name=${name}`

    a.appendChild(img)

    return a
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
