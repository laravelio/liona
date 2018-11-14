# Description:
#   LioBot gets you tip top information from the Laravel or PHP documentation
#
# Commands:
#   LioBot show <nick?> docs for <type?> <version?> <query>
#   LioBot show docs search engine
#   LioBot show docs target version
#
#   LioBot set docs search engine to (google|bing)
#   LioBot set docs target version to ([0-9.]+)
#
# Notes:
#   None

cheerio   = require 'cheerio'
htmlStrip = require 'htmlstrip-native'
whiteList = require '../support/whitelist'

SEARCH_URLS =
  google: 'https://www.google.com/search'
  bing: 'http://www.bing.com/search'

ENGINE_KEY = 'docs-search-engine'
VERSION_KEY = 'docs-search-version'

TARGET_VERSION = 'master'
SEARCH_ENGINE = 'bing'

USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.116 Safari/537.36'
#Rommie=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17

getSearchUrl = (key) ->
  SEARCH_URLS[key]

module.exports = (robot) ->

  robot.brain.on 'loaded', =>
    TARGET_VERSION = robot.brain.data._private[VERSION_KEY] || TARGET_VERSION
    SEARCH_ENGINE = robot.brain.data._private[ENGINE_KEY] || SEARCH_ENGINE

  getQueryUrl = (doctype, version, query) ->
    switch doctype
      when 'api' then "site:laravel.com/api/#{version || TARGET_VERSION} #{query}"
      when 'lumen' then "site:lumen.laravel.com/docs/#{version || ''} #{query}"
      when 'php' then "site:php.net/manual/en #{query}"
      else "site:laravel.com/docs/#{version || TARGET_VERSION} #{query}"

  fetchResult = (query, location, callback) ->
    robot.http(location)
      .header('User-Agent', USER_AGENT)
      .query(q: query)
      .get() (err, res, body) ->
        $ = cheerio.load body

        if SEARCH_ENGINE is 'google'
          result = $('#rso .g').first()
          # Jump To Link ? Main Link
          url = result.find('.s span.f a').attr('href') ? result.find('div.r a').attr('href')
        else
          url = $('ol#b_results li.b_algo h2').find('a').attr('href')

        callback url if callback

  docFetcher = (msg) ->
    [user, doctype, version, query] = msg.match[1..4]

    fetchResult getQueryUrl(doctype, version, query), getSearchUrl(SEARCH_ENGINE), (url) ->
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

  setDocsSearchEngine = (msg) ->
    if whiteList.isTeacher msg.robot, msg.message.user
      engine = msg.match[1]
      msg.robot.brain.set ENGINE_KEY, SEARCH_ENGINE = engine
      msg.send "The docs search engine is set to #{engine}."

  setDocsTargetVersion = (msg) ->
    if whiteList.isTeacher msg.robot, msg.message.user
      version = msg.match[1]
      msg.robot.brain.set VERSION_KEY, TARGET_VERSION = version
      msg.send "The targeted docs version has been set to #{version}."

  showDocsSearchEngine = (msg) ->
    msg.send "The current docs search engine is #{SEARCH_ENGINE}."

  showDocsTargetVersion = (msg) ->
    msg.send "The current targeted docs version id #{TARGET_VERSION}."


  robot.respond /show (?:([^\s!]+) )?docs for (?:(api|php|lumen) )?(?:([0-9.]+) )?(.+)/i, docFetcher

  robot.respond /show docs search engine/i, showDocsSearchEngine

  robot.respond /show docs target version/i, showDocsTargetVersion

  #ACL - teacher
  robot.respond /set docs search engine to (google|bing)/i, setDocsSearchEngine

  #ACL - teacher
  robot.respond /set docs target version to ([0-9.]+)/i, setDocsTargetVersion
