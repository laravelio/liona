# Description:
# 	Poll forums or fetch for new threads manually
#
# Commands:
# 	hubot check the forums - Tests forum search results
#

Poller = require '../support/poller'

POLL_INTERVAL    = 1000 * 60 * 10 # 10 minute interval to start with
ANNOUNCE_ROOMS   = []

do =>
  rooms = process.env.FORUM_POLL_ANNOUNCE_ROOMS || process.env.HUBOT_IRC_ROOMS || ''
  ANNOUNCE_ROOMS = rooms.split ','

# Polling system

class ForumPoller
  HOST_URL       = 'http://laravel.io'
  API_URI        = '/api/forum'

  constructor: (@robot, @poster) ->
    @poster  ||= new ThreadPoster(@robot)
    @poller    = new Poller(@robot.http(HOST_URL+API_URI).query(take: 3), POLL_INTERVAL)
    @recentIds = []

  pollForNewThreads: ->
    @poller.start (threads) => @newThreadsCallback.call(this, threads)

  stop: ->
    @poller.stop()

  fetchNewThreads: ->
    @poller.fetch().then (threads) =>
      @newThreadsCallback.call(this, threads)

  newThreadsCallback: (threads) ->
    newThreads = threads.filter (thread) => @threadIsNew(thread)
    if newThreads.length > 0
      @poster.postNewThreads(newThreads)
    else
      console.log "No new posts from fetch at ", new Date()

  threadIsNew: (thread) ->
    return false unless @recentIds.indexOf(thread.id) is -1

    @recentIds.shift() if @recentIds.length is 3
    @recentIds.push(thread.id)
    true

class NoticeCreator
  MESSAGE_FORMAT = "Forum Activity: :subject :url"

  truncate: (msg, length = 40) ->
    if msg.length > length then msg.substring(0, length) + '...' else msg

  create: (thread) ->
    message = MESSAGE_FORMAT
    message = message.replace(':subject', @truncate(thread.subject))
                     .replace(':url', thread.url)
    message

class ThreadPoster
  constructor: (@robot) ->
    @notice = new NoticeCreator()

  postNewThreads: (threads) ->
    if threads? and threads.length > 0
      messages = (@notice.create(thread) for thread in threads)
      ANNOUNCE_ROOMS.forEach (room) => @robot.messageRoom room, messages.join("\r\n")

module.exports = (robot) ->
  poller = new ForumPoller(robot)

  # Start polling
  poller.pollForNewThreads()

  # Manual trigger
  robot.respond /check the forums/i, (msg) ->
    poller.fetchNewThreads()

