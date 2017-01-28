
var fs = require('fs')

// using defer functions is optional. See example and docs below.
var defer = require('config/defer').deferConfig

module.exports = {
    server: {
        port: process.env.PORT || 3000
    },
    db: {
        uri: process.env.MONGO_URI || 'mongodb://localhost',
        options: {
          user: process.env.MONGO_USER,
          pass: process.env.MONGO_PASS
		}
    },
    build: {
        version: "undefined"
    }
}

