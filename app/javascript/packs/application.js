import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'
import $ from 'jquery'

import 'bootstrap/dist/js/bootstrap.bundle'
import '../src/application.scss'

window.jQuery = $
window.$ = $

const application = Application.start()
const context = require.context('controllers', true, /.js$/)
application.load(definitionsFromContext(context))
