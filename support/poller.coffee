# This package contains support methods for polling packages
PromiseHttp = require './promise-http'

class Poller
  constructor: (@http, @pollTimeInterval = 10*60*1000) ->
    @lastPolledAt   = null
    @pollIntervalId = null

  start: (callback) ->
    @stop()
    @pollIntervalId = setInterval =>
      @fetch(callback)
    , @pollTimeInterval

  stop: ->
    clearInterval @pollIntervalId if @pollIntervalId?
    @lastPolledAt = null

  fetch: (callback) ->
    new PromiseHttp(@http).getJSON()
      .then((body, res) =>
        @lastPolledAt = new Date()
        callback(body, res) if callback?
        body
      ).catch((err) ->
        console.log "Failed reaching endpoint with poller", err || null
       # callback.call(this, err) if callback?
      )

module.exports = Poller
