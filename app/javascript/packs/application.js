import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'

import '@fortawesome/fontawesome-free/css/all.css'
import 'croppie/croppie.css'
import '../src/application.scss'

import '../behavior'

const application = Application.start()
const context = require.context('controllers', true, /.(ts|js)$/)
application.load(definitionsFromContext(context))
