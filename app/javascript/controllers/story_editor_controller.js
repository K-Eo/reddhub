import { Controller } from 'stimulus'
import autosize from 'autosize'
import debounce from 'lodash/debounce'

const TIME_TO_SAVE = 4000

export default class extends Controller {
  static targets = ['settings', 'saveStatus', 'text']

  initialize() {
    this.isSaving = false
    autosize(this.textTarget)
    this.onChangeDebounced = debounce(this.save, TIME_TO_SAVE)
  }

  set saveStatus(status) {
    this.saveStatusTarget.innerHTML = status
  }

  get hasContent() {
    return this.textTarget.value.length > 0
  }

  get id() {
    return this.settingsTarget.getAttribute("data-id") || null
  }

  get isNew() {
    return this.id === null
  }

  get content() {
    return this.textTarget.value
  }

  save() {
    if (!this.hasContent || this.isSaving) {
      return
    }

    this.saveStatus = 'Saving...'

    const formData = new FormData()
    formData.append('story[content]', this.content)

    Rails.ajax({
      type: this.isNew ? 'POST' : 'PUT',
      url: this.isNew ? '/stories' : `/stories/${this.id}/content`,
      data: formData,
      dataType: 'script',
      success: () => {
        this.saveStatus = 'Saved'
        this.isSaving = false
      },
      error: () => {
        this.saveStatus = 'Failure'
        this.isSaving = false
      },
    })
  }

  onChange(e) {
    this.onChangeDebounced()
    this.saveStatus = 'Not saved'
  }

  toggleSettings(e) {
    e.preventDefault()
    $(this.settingsTarget).collapse('toggle')
  }
}
