/* *************************************************************************
 *
 * base application mockup
 *
 */

var express    = require('express')
var app        = express()
var bodyParser = require('body-parser')

app.use(bodyParser.urlencoded({ extended: true }))
app.use(bodyParser.json())

/* *************************************************************************
 * configurations
 */
var config = require('config')

var mongo = require('mongodb').MongoClient,
    assert = require('assert');
 
// Use connect method to connect to the Server 
mongo.connect(config.db.uri, config.db.options, function(err, db) {
  if (err) {
    console.log(err)
  } else {
    console.log("Connected correctly to server");
    db.close();
  }
})

/* *************************************************************************
 * simple params parsing - probably want to replace this */
var params = function(req) {
  q = req.url.split('?'), result = {}
  if (q.length >= 2){
      q[1].split('&').forEach((item) => {
           try {
             result[item.split('=')[0]] = item.split('=')[1]
           } catch (e) {
             result[item.split('=')[0]] = ''
           }
      })
  }
  return result
}

/* *************************************************************************
 * router
 */

var router = express.Router()
router.get('/health', function(request, response) {
        request.params = params(request)
        if (request.params.detail == "true") {
            response.status(200).send({"version": config.build.version})
        } else {
            response.status(204).send()
        }
    })
router.get("/ok", function(request, response) {
        response.send("Ok!!\n")
    })

app.use('/sonic', router)

/* *************************************************************************
 * startup
 */
app.listen(config.server.port)
console.log('Started on port ' + config.server.port)

