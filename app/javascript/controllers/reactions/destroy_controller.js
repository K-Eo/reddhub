import { Controller } from 'stimulus'

export default class extends Controller {
  execute() {
    const url = this.data.get('href')

    Rails.ajax({
      type: 'DELETE',
      url: url,
      dataType: 'script',
    })
  }
}
