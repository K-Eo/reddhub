const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
const typescript =  require('./loaders/typescript')

environment.loaders.append('typescript', typescript)

environment.plugins.append(
  'CommonsChunkVendor',
  new webpack.optimize.CommonsChunkPlugin({
    name: 'vendor',
    minChunks: module => module.context && module.context.indexOf('node_modules') !== -1
  })
)

environment.plugins.append(
  'CommonsChunkManifest',
  new webpack.optimize.CommonsChunkPlugin({
    name: 'manifest',
    minChunks: Infinity
  })
)

module.exports = environment
