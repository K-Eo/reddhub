import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['component']
  componentTarget: HTMLDivElement

  visit(e: MouseEvent) {
    const jsAction = (e.target as Element).closest('.js-action')

    if (jsAction == null && this.data.has('url')) {
      Turbolinks.visit(this.data.get('url'))
    }
  }
}
