import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'

import '../behavior'

import '../src/application.scss'

const application = Application.start()
const context = require.context('controllers', true, /.js$/)
application.load(definitionsFromContext(context))
