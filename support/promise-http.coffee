# This package contains support methods for promise-based http requests
rsvp = require 'rsvp'
zlib = require('zlib');

class PromiseHttp
  constructor: (@http) ->

  getJSON: (options) ->
    new rsvp.Promise (resolve, reject) =>
      data = ''
      @http.query(options) if options
      @http.get((err, req) ->
        req.addListener "response", (res) ->
          output = res

          if res.headers['content-encoding'] is 'gzip'
            output = zlib.createGunzip()
            res.pipe(output)

          output.on 'data', (d) ->
            data += d.toString('utf-8')

          output.on 'end', ->
            try
              result = JSON.parse data
              if result.error
                reject result.error
              else
                resolve result, res
            catch error
              reject error
      )()

module.exports = PromiseHttp
