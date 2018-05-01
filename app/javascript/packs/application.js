import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'
import $ from 'jquery'
import Autosize from 'autosize'

import '../src/application.scss'

window.jQuery = $
window.$ = $

import 'bootstrap/dist/js/bootstrap.bundle'

const application = Application.start()
const context = require.context('controllers', true, /.js$/)
application.load(definitionsFromContext(context))

document.addEventListener('turbolinks:load', () => {
  const elements = document.querySelectorAll('.js-autosize')
  Autosize(elements)
})
