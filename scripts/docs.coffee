# Description:
#   LioBot gets you tip top information from the Laravel or PHP documentation
#
# Commands:
#   <nick?> !docs <version?> <query> - Perform a Google search against Laravel or PHP
#       docs for <query>, version can be a numeric version number, 'api' to
#       search the api docs, 'php' to search the PHP docs, or blank for
#       the latest Laravel docs pages.
#
# Notes:
#   None

cheerio   = require 'cheerio'
htmlStrip = require 'htmlstrip-native'

TARGET_VERSION = 5.1
SEARCH_URL = 'https://www.google.com/search'
USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.116 Safari/537.36'
#Rommie=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17

module.exports = (robot) ->
  getQueryUrl = (doctype, version, query) ->
    version = 3 if version?.match /^3(.*)/i

    if doctype == 'api'
      if version == 3
        "site:l3.shihan.me/api #{query}"
      else if version?
        "site:laravel.com/api/#{version} #{query}"
      else
        "site:laravel.com/api/#{TARGET_VERSION} #{query}"
    else if doctype == 'lumen'
      "site:lumen.laravel.com/docs #{query}"
    else if doctype == 'php'
      "site:php.net/manual/en #{query}"
    else
      if version == 3
        "site:laravel3.veliovgroup.com/docs #{query}"
      else if version?
        "site:laravel.com/docs/#{version} #{query}"
      else
        "site:laravel.com/docs/#{TARGET_VERSION} #{query}"

  fetchResult = (query, callback) ->
    robot.http(SEARCH_URL)
      .header('User-Agent', USER_AGENT)
      .query(q: query)
      .get() (err, res, body) ->
        $ = cheerio.load body
        result = $('#rso .g').first()
        # Jump To Link ? Main Link
        url = result.find('.s span.f a').attr('href') ? result.find('h3.r a').attr('href')
        callback url if callback

  docFetcher = (msg) ->
    [user, doctype, version, query] = msg.match[1..4]

    fetchResult getQueryUrl(doctype, version, query), (url) ->
      return msg.send "No results for \"#{query.substr(0,30)}\"" unless url

      response = url
      response = "#{user}: #{response}" if user

      if doctype == 'php' and /function/.test url
        robot.http(url).get() (err, res, body) ->
          $ = cheerio.load body
          methodSigContent = htmlStrip.html_strip $('.methodsynopsis').html(), compact_whitespace : true
          msg.send "#{response} | #{methodSigContent}"
      else
        msg.send response

  robot.respond /show (?:([^\s!]+) )?docs for (?:(api|php|lumen) )?(?:([0-9.]+) )?(.+)/i, docFetcher
  robot.hear /(?:([^:,\s!]+)[:,\s]+)?!docs (?: (api|php|lumen))?(?: ([0-9.]+))?(?:\s?(.+))/i, docFetcher
