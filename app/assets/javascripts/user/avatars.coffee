MAX_AVATAR_SIZE = 1024 * 1024 * 10

clear_avatar_trigger = ->
  $('#avatar_picker_trigger')[0].value = ''

read_url = (input) ->
  if input.files && input.files[0]
    reader = new FileReader()
    size = input.files[0].size

    if size > MAX_AVATAR_SIZE
      clear_avatar_trigger()
      alert 'Your file is too large. Are you sure is it an image?'
      return

    reader.onload = (e) ->
      image = new Image()
      image.onload = ->
        if this.width < 256 and this.height < 256
          clear_avatar_trigger()
          alert 'Your image is too small. We need a picture with at least 256px by 256px.'
          return

        $("#avatar_preview").attr 'src', e.target.result
        $("#avatar_picker_modal").modal('show')

      image.src = e.target.result

    reader.readAsDataURL input.files[0]

$(document).on 'turbolinks:load', ->
  cropper = null
  modal = $('#avatar_picker_modal')

  modal.on 'shown.bs.modal', ->
    image = document.getElementById 'avatar_preview'
    cropper = new Cropper image,
      aspectRatio: 1
      autoCropArea: 0.0001
      background: false
      cropBoxMovable: false
      cropBoxResizable: false
      dragMode: 'move'
      guides: false
      minCropBoxHeight: 256
      minCropBoxWidth: 256
      toggleDragModeOnDblclick: false
      viewMode: 1

  $('#avatar_picker_save').on 'click', ->
    cropper.getCroppedCanvas().toBlob (blob) ->
      formData = new FormData()

      formData.append 'avatar', blob

      Rails.ajax
        type: 'PUT'
        url: '/avatars'
        data: formData
        error: ->
          $("#avatar_picker_modal").modal('hide')
          alert 'Oh no! something went wrong. Please, check your internet connection and try again.'

  modal.on 'hidden.bs.modal', ->
    cropper.destroy()
    cropper = null
    clear_avatar_trigger()
    
  $('#avatar_picker_trigger').change ->
    read_url @
  
