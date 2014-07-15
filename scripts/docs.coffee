# Description:
#   LioBot gets you tip top information from the Laravel or PHP documentation
#
# Commands:
#   <nick?> !docs <doctype>? <query> - Perform a Google search against Laravel or PHP
#       docs for <query>, doctype can be 'api' to
#       search the api docs, 'php' to search the PHP docs, or blank for
#       the latest October docs pages.
#
# Notes:
#   None

cheerio   = require 'cheerio'
# htmlStrip = require 'htmlstrip-native'

TARGET_VERSION = '4.2'
SEARCH_URL = 'https://www.google.com/search'
USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.116 Safari/537.36'
#Rommie=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17

module.exports = (robot) ->
  getQueryUrl = (doctype, query) ->

    if doctype == 'api'
      "site:laravel.com/api #{query}"
    else if doctype == 'php'
      "site:php.net/manual/en #{query}"
    else
      "site:octobercms.com/docs #{query}"

  fetchResult = (query, callback) ->
    robot.http(SEARCH_URL)
      .header('User-Agent', USER_AGENT)
      .query(q: query)
      .get() (err, res, body) ->
        $ = cheerio.load body
        result = $('li.g').first()
        # Jump To Link ? Main Link
        url = result.find('.st .f a').attr('href') ? result.find('h3.r a').attr('href')
        callback url if callback

  robot.hear /(([^:,\s!]+)[:,\s]+)?!docs\s?(api|php)?\s?(.*)/i, (msg) ->
    user = msg.match[2]
    doctype = msg.match[3]
    query = msg.match[4]

    fetchResult getQueryUrl(doctype, query), (url) ->
      return msg.send "No results for \"#{query.substr(0,30)}\"" unless url

      response = url
      response = "#{user}: #{response}" if user

      if doctype == 'php' and /function/.test url
        robot.http(url).get() (err, res, body) ->
          $ = cheerio.load body
          methodSigContent = $('.methodsynopsis').html()
#          methodSigContent = htmlStrip.html_strip $('.methodsynopsis').html(), compact_whitespace : true
          msg.send "#{response} | #{methodSigContent}"
      else
          msg.send response
