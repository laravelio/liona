# Description:
#   LioBot gets you tip top information from the Laravel or PHP documentation
#
# Commands:
#   LioBot show <nick?> docs for <type?> <version?> <query>#
#   LioBot show docs search engine
#   LioBot show docs target version
#
#   LioBot set docs search engine (google|bing)
#   LioBot set docs target version ([0-9.]+)
#
# Notes:
#   None

cheerio   = require 'cheerio'
htmlStrip = require 'htmlstrip-native'
whiteList = require '../support/whitelist'

SEARCH_URLS =
  google: 'https://www.google.com/search'
  bing: 'http://www.bing.com/search'

BRAIN_KEY = 'docs-search-engine'
VERSION_KEY = 'docs-search-version'

USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/34.0.1847.116 Safari/537.36'
#Rommie=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17

getCurrentEngine = (robot) ->
  robot.brain.get BRAIN_KEY || 'bing'

getSearchUrl = (key) ->
  SEARCH_URLS[key]

setCurrentEngine = (robot, engine) ->
  robot.brain.set BRAIN_KEY, engine

getTargetVersion = (robot) ->
  robot.brain.get(VERSION_KEY) || 'master'

setTargetVersion = (robot, version) ->
  robot.brain.set VERSION_KEY, version

module.exports = (robot) ->
  getQueryUrl = (doctype, version, query) ->
    version = 3 if version?.match /^3(.*)/i

    TARGET_VERSION = getTargetVersion robot

    if doctype == 'api'
      if version == 3
        "site:l3.shihan.me/api #{query}"
      else if version?
        "site:laravel.com/api/#{version} #{query}"
      else
        "site:laravel.com/api/#{TARGET_VERSION} #{query}"
    else if doctype == 'lumen'
      if version?
        "site:lumen.laravel.com/docs/#{version} #{query}"
      else
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

  fetchResult = (query, location, callback) ->
    robot.http(location)
      .header('User-Agent', USER_AGENT)
      .query(q: query)
      .get() (err, res, body) ->
        # if res.statusCode is 302
        #   return fetchResult query, res.headers.location, callback

        $ = cheerio.load body

        if getCurrentEngine(robot) == 'google'
          result = $('#rso .g').first()
          # Jump To Link ? Main Link
          url = result.find('.s span.f a').attr('href') ? result.find('h3.r a').attr('href')
        else # bing
          result = $('ol#b_results li.b_algo h2')
          url = result.find('a').attr('href')

        callback url if callback

  docFetcher = (msg) ->
    [user, doctype, version, query] = msg.match[1..4]

    fetchResult getQueryUrl(doctype, version, query), getSearchUrl(getCurrentEngine(robot)), (url) ->
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

  robot.respond /show docs search engine/i, (msg) ->
    msg.send "The current docs search engine is #{getCurrentEngine robot}."

  robot.respond /show docs target version/i, (msg) ->
    msg.send "The current targeted docs version is #{getTargetVersion robot}."

#ACL - teacher
  robot.respond /set docs search engine to (google|bing)/i, (msg) ->
    if whiteList.isTeacher robot, msg.message.user
      engine = msg.match[1]
      setCurrentEngine robot, engine
      msg.send "The docs search engine is set to #{engine}."

#ACL - admin
  robot.respond /set docs target version to ([0-9.]+)/i, (msg) ->
    if whiteList.isAdmin robot, msg.message.user
      version = msg.match[1]
      setTargetVersion robot, version
      msg.send "The targeted docs version has been set to #{version}."