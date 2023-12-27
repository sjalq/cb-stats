const ports = require('./elm-pkg-js/ports')

exports.init = async function init(app) {
    ports.init(app)
}