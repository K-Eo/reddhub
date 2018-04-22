import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'

import '../src/application.scss'

import $ from 'jquery'

window.jQuery = $
window.$ = $

import 'bootstrap/dist/js/bootstrap.bundle'

const application = Application.start()
const context = require.context('controllers', true, /.js$/)
application.load(definitionsFromContext(context))
