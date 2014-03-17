# Description:
# 	Poll forums
#
# Commands:
# 	hubot check the forums - Tests forum search results
#

PROD_MODE        = process.env.NODE_ENV is 'production'
POLL_INTERVAL    = 1000 * 60 * 10 # 10 minute interval to start with
POLL_INTERVAL_ID = null
ANNOUNCE_ROOMS   = process.env.HUBOT_IRC_ROOMS.split ','

class ThreadPoster
  constructor: (@robot) ->
    @poller = new ForumPoller(@robot)
    @notice = new NoticeCreator()

  postNewThreads: (room) ->
    @poller.getNewThreads (threads) =>
      if threads?
        messages = (@notice.create(thread) for thread in threads)
        ANNOUNCE_ROOMS.forEach (room) => @robot.messageRoom room, messages.join("\r\n")
      else
        @robot.messageRoom room, "No new forum threads"

class ForumPoller
  LAST_POLLED_AT = null
  HOST_URL       = if PROD_MODE then 'http://laravel.io' else 'http://app.local'
  API_URI        = '/api/forum'

  constructor: (@robot) ->

  getNewThreads: (callback) ->
    @robot.http(HOST_URL+API_URI).query(take: 3).get() (err, res, body) =>
      try
        threads = JSON.parse(body)
        result = threads.filter (thread) => @isMoreRecentThanLastPoll(thread.updated_at)

        LAST_POLLED_AT = new Date()
        # need to set last polled date/time
      catch error
        console.log "Parsing error when fetching feeds from forum", error
        result = []

      callback.call(this, result)

  isMoreRecentThanLastPoll: (dateString) ->
    # This method will break apart a mysql datetime string into a JS Date obj
    t         = dateString.split /[- :]/
    updatedAt = new Date(t[0], t[1]-1, t[2], t[3], t[4], t[5])

    if LAST_POLLED_AT?
      updatedAt >= LAST_POLLED_AT
    else
      true

class NoticeCreator
  MESSAGE_FORMAT = "Forum Activity: :subject :url"

  truncate: (msg, length = 40) ->
    msg.substring(0, length) + '...'

  create: (thread) ->
    message = MESSAGE_FORMAT
    message = message.replace(':subject', @truncate(thread.subject))
                     .replace(':url', thread.url)
    message

module.exports = (robot) ->
  poster = new ThreadPoster(robot)

  POLL_INTERVAL_ID = setInterval ->
    poster.postNewThreads(msg)
  , POLL_INTERVAL

  robot.respond /check the forums/, (msg) -> poster.postNewThreads()
  #robot.on 'poll:forums:new', (posts) -> poster.postNewThreads()

