import mediumZoom from 'medium-zoom'

document.addEventListener('turbolinks:load', () => {
  mediumZoom('.js-zoom')
})
