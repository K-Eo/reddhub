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
  static targets = ['picker', 'toggler', 'wrapper']

  initialize() {
    this.isToggled = false
  }

  get picker() {
    return $(this.pickerTarget)
  }

  reactions() {
    const type = this.wrapperTarget.getAttribute('data-type')
    const id = this.wrapperTarget.getAttribute('data-id')

    return emojis
      .map(({ name, src, alt }) => {
        const encodedName = encodeURIComponent(name)

        return `<a class="btn btn-light border-0" rel="nofollow" data-method="post" href="/${type}/${id}/reaction?name=${encodedName}">
          <img draggable="false" title="${name}" alt="${alt}" src="${src}" class="emoji" style="width: 18px; height: 18px;">
        </a>`
      })
      .join('')
  }

  toggle() {
    if (this.isToggled) {
      this.popper.destroy()
      this.popper = null
      this.picker.html('')
      this.picker.addClass('d-none')
      this.isToggled = false
    } else {
      this.popper = new Popper(this.wrapperTarget, this.pickerTarget, {
        placement: 'top',
      })

      this.picker.removeClass('d-none')
      this.picker.html(this.reactions())
      this.isToggled = true
    }
  }
}
