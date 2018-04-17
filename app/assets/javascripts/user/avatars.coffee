readURL = (input) ->
  if input.files && input.files[0]
    reader = new FileReader()

    reader.onload = (e) ->
      $("#avatar_preview").attr 'src', e.target.result
      $("#avatar_picker_modal").modal('show')

    reader.readAsDataURL input.files[0]

$(document).on 'turbolinks:load', ->
  modal = $('#avatar_picker_modal')
  cropper = null
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

  modal.on 'hidden.bs.modal', ->
    cropper.destroy()
    cropper = null
    $('#avatar_picker_trigger')[0].value = ''
    
  $('#avatar_picker_trigger').change ->
    readURL @
  
