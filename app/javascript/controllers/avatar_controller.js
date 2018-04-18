import { Controller } from 'stimulus'
import Cropper from 'cropperjs'

const MAX_AVATAR_SIZE = 1024 * 1024 * 10

export default class extends Controller {
  static targets = ['trigger', 'preview', 'modal', 'cancel', 'save']

  initialize() {
    $(this.modalTarget).on('hidden.bs.modal', () => this.onCloseModal())
    $(this.modalTarget).on('shown.bs.modal', () => this.onOpenModal())
  }

  onOpenModal() {
    this.cropper = new Cropper(this.previewTarget, {
      aspectRatio: 1,
      autoCropArea: 0.0001,
      background: false,
      cropBoxMovable: false,
      cropBoxResizable: false,
      dragMode: 'move',
      guides: false,
      minCropBoxHeight: 256,
      minCropBoxWidth: 256,
      toggleDragModeOnDblclick: false,
      viewMode: 1,
    })
  }

  onSave() {
    const content = this.saveTarget.firstChild.data

    const setDisabled = () => {
      this.saveTarget.setAttribute('disabled', true)
      this.cancelTarget.setAttribute('disabled', true)
      const contentDisabled = this.saveTarget.getAttribute('data-disabled-with')
      this.saveTarget.firstChild.data = contentDisabled
    }

    const removeDisabled = () => {
      this.saveTarget.firstChild.data = content
      this.saveTarget.removeAttribute('disabled')
      this.cancelTarget.removeAttribute('disabled')
    }

    this.cropper.getCroppedCanvas().toBlob(blob => {
      setDisabled()

      const formData = new FormData()

      formData.append('avatar', blob)

      Rails.ajax({
        type: 'PUT',
        url: '/avatars',
        data: formData,
        dataType: 'script',
        success: () => {
          this.onCancel()
          removeDisabled()
        },
        error: () => {
          removeDisabled()
          alert('Oh no! something went wrong. Please, check your internet connection and try again.')
        }
      })
    })
  }

  onCloseModal() {
    this.cropper.destroy()
    this.cropper = null
    this.triggerTarget.value = ''
  }

  onCancel() {
    $(this.modalTarget).modal('hide')
  }

  onPickImage() {
    if (!this.triggerTarget.files && !this.triggerTarget.files[0]) {
      return
    }

    const currentFile = this.triggerTarget.files[0]
    const reader = new FileReader()
    const size = currentFile.size

    if (size > MAX_AVATAR_SIZE) {
      alert('Your file is too large. Are you sure is it an image?')
      return 
    }

    reader.onload = e => this.onReadLoaded(e)
    reader.readAsDataURL(currentFile)
  }

  onReadLoaded(e) {
    const image = new Image()
    const preview = this.previewTarget
    const modal = this.modalTarget

    image.onload = function() {
      if (this.width < 256 && this.height < 256) {
        alert('Your image is too small. We need an image with at least 256px by 256px.')
        return
      }

      preview.setAttribute('src', e.target.result)
      $(modal).modal({
        backdrop: 'static',
        keyboard: false,
        show: true
      })
    }

    image.src = e.target.result
  }
}
