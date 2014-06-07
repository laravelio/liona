# Description:
#   LioBot gets you tip top information from the Laravel or PHP documentation
#
# Commands:
#   !docs <version?> <query> - Perform a Google search against Laravel or PHP
#       docs for <query>, version can be a numeric version number, 'api' to
#       search the api docs, 'php' to search the PHP docs, or blank for
#       the latest Laravel docs pages.
#
# Notes:
#   None

cheerio   = require 'cheerio'
htmlStrip = require('htmlstrip-native');
API_URL   = 'http://ajax.googleapis.com/ajax/services/search/web'

module.exports = (robot) ->
  getQueryUrl = (version, query) ->
    if version.match(/^3(.*)/i)
      "site:three.laravel.com/docs #{query}"
    else if version == 'api'
      "site:laravel.com/api/4.1 #{query}"
    else if version == 'php'
        "site:www.php.net/manual/en #{query}"
    else if version?
      "site:laravel.com/docs/#{version} #{query}"
    else
      "site:laravel.com/docs #{query}"

  fetchResult = (query, callback) ->
    robot.http(API_URL).query(v: '1.0', q: query).get() (err, res, body) ->
      results = JSON.parse(body).responseData.results
      url = results[0] and results[0].url
      callback(url) if callback

  robot.hear /(([^:,\s!]+)[:,\s]+)?!docs\s([0-9.]+|api|dev|php)?\s?(.*)/i, (msg) ->
    user = msg.match[2]
    version = msg.match[3]
    query = msg.match[4]

    # quick and dirty urlify version string
    # (beware if we get into 2 digit minor vers)
    if (version != 'dev' or version != 'api')
      if !version?
        version = ''
      else if version.length > 1
        version = version.replace(/[\.]/g, "-")
        version = version.substr(0, 3)
      else if version == '4'
        version = ''

    fetchResult getQueryUrl(version, query), (url) ->
      response = url
      if user
        response = user + ": " + response

      if version == 'php' and /function/.test url
          robot.http(url).get() (err, res, body) ->
            $ = cheerio.load body
            methodSigContent = htmlStrip.html_strip $('.methodsynopsis').html(), compact_whitespace : true
            msg.send response + " | #{methodSigContent}"
      else
        if !url
          msg.send "No results for \"#{query}\""
        else
          msg.send response
