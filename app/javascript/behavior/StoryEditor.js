document.addEventListener('turbolinks:load', () => {
  if ($('.stories.edit').length === 0) {
    return
  }

  const writeButton = $('#story_editor_write')
  const previewButton = $('#story_editor_preview')
  const content = $('#editor_content')
  const preview = $('#editor_preview')
  const story = $('#story_content')
  let busy = false

  writeButton.on('click', e => {
    e.preventDefault()

    writeButton.addClass('active')
    previewButton.removeClass('active')

    content.removeClass('d-none')
    preview.addClass('d-none')
  })

  previewButton.on('click', e => {
    e.preventDefault()

    preview.html('Loading...')

    previewButton.addClass('active')
    writeButton.removeClass('active')

    content.addClass('d-none')
    preview.removeClass('d-none')

    if (busy) {
      return
    }

    busy = true

    const formData = new FormData()
    formData.append('content', story.val())

    Rails.ajax({
      type: 'POST',
      url: previewButton.attr('href'),
      dataType: 'script',
      data: formData,
      error: () => {
        preview.html('Check your internet connection and try again.')
        alert('Snaps! Something went wrong. Please, try again.')
      },
      complete: () => {
        busy = false
      },
    })
  })
})
