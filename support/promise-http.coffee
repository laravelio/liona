# This package contains support methods for promise-based http requests
rsvp = require 'rsvp'

class PromiseHttp
  constructor: (@http) ->

  getJSON: (options) ->
    new rsvp.Promise (resolve, reject) =>
      @http.query(options) if options

      @http.get() (err, res, body) =>
        reject(err) if err
        try
          result = JSON.parse(body)
          resolve result, res
        catch error
          reject error

module.exports = PromiseHttp
