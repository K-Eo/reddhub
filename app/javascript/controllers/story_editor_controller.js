import { Controller } from 'stimulus'
import autosize from 'autosize'
import debounce from 'lodash/debounce'

export default class extends Controller {
  static targets = ['text', 'saveStatus']

  initialize() {
    this.isSaving = false
    this.id = null
    autosize(this.textTarget)
    this.onChangeDebounced = debounce(this.save, 1000)
  }

  set saveStatus(status) {
    this.saveStatusTarget.innerHTML = status
  }

  get isEmpty() {
    return this.textTarget.value.length <= 0
  }

  get isNew() {
    return this.id === null
  }

  get content() {
    return this.textTarget.value
  }

  save() {
    if (this.isEmpty || this.isSaving) {
      return
    }

    this.saveStatus = 'Saving...'

    const formData = new FormData()
    formData.append('story[title]', 'My story')
    formData.append('story[content]', this.content)

    Rails.ajax({
      type: this.isNew ? 'POST' : 'PUT',
      url: this.isNew ? '/stories.json' : `/stories/${this.id}.json`,
      data: formData,
      success: e => {
        if (e && e.id) {
          this.id = e.id
          this.saveStatus = 'Saved'
        } else {
          this.saveStatus = 'Failure'
        }

        this.isSaving = false
      },
      error: e => {
        this.saveStatus = 'Failure'
      },
    })
  }

  onChange(e) {
    this.onChangeDebounced()
  }
}
