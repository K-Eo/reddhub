import { Controller } from 'stimulus'

const emojis = [
  { name: '+1', src: 'https://twemoji.maxcdn.com/2/svg/1f44d.svg', alt: '👍' },
  { name: 'heart', src: 'https://twemoji.maxcdn.com/2/svg/2764.svg', alt: '❤' },
  {
    name: 'laughing',
    src: 'https://twemoji.maxcdn.com/2/svg/1f606.svg',
    alt: '😆',
  },
  {
    name: 'astonished',
    src: 'https://twemoji.maxcdn.com/2/svg/1f632.svg',
    alt: '😲',
  },
  {
    name: 'disappointed_relieved',
    src: 'https://twemoji.maxcdn.com/2/svg/1f625.svg',
    alt: '😥',
  },
  {
    name: 'rage',
    src: 'https://twemoji.maxcdn.com/2/svg/1f621.svg',
    alt: '😡',
  },
]

export default class extends Controller {
  static targets = ['picker', 'toggler']

  initialize() {
    this.mouseListener = e => {
      if (
        !this.picker.is(e.target) &&
        this.picker.has(e.target).length === 0 &&
        !this.toggler.is(e.target) &&
        this.toggler.has(e.target).length === 0
      ) {
        this.hide()
      }
    }
  }

  get picker() {
    return $(this.pickerTarget)
  }

  get toggler() {
    return $(this.togglerTarget)
  }

  reactions() {
    const type = this.togglerTarget.getAttribute('data-type')
    const id = this.togglerTarget.getAttribute('data-id')

    return emojis
      .map(({ name, src, alt }) => {
        const encodedName = encodeURIComponent(name)

        return `<a class="btn btn-light border-0 js-action" rel="nofollow" data-method="post" href="/${type}/${id}/reaction?name=${encodedName}">
          <img draggable="false" title="${name}" alt="${alt}" src="${src}" class="emoji" style="width: 18px; height: 18px;">
        </a>`
      })
      .join('')
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

    this.picker.removeClass('d-none')
    this.picker.html(this.reactions())
    document.addEventListener('mouseup', this.mouseListener)
  }

  hide() {
    this.popper.destroy()
    this.popper = null
    this.picker.html('')
    this.picker.addClass('d-none')
    document.removeEventListener('mouseup', this.mouseListener)
  }
}
