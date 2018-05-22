import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['source']

  visit(e) {
    const url = this.sourceTarget.getAttribute('data-url')
    const canVisit = $(e.target).closest('.js-action').length === 0

    if (url && canVisit) {
      Turbolinks.visit(url)
    }
  }
}
