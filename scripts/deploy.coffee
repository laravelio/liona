# Description:
#   Deploy the app
#
# Commands:
#   hubot deploy

whitelistedUsers = process.env.HUBOT_ALLOWED_USERS?.split(',') || []

isWhitelisted = (user) ->
  whitelistedUsers.indexOf(user.name) isnt -1

deploy = (msg, failMsg = 'Nope') ->
  if isWhitelisted(msg.message.user)
    branch = msg.match[1] || 'master'
    msg.reply "Fetching and deploying #{branch}.  Wish me luck!"
    require('child_process').spawn('./bin/deploy.sh', [branch], detached: true).unref()
  else
    msg.reply failMsg

module.exports = (robot) ->
  robot.respond /deploy ?(\w+)?/i, (msg) ->
    deploy msg

  robot.respond /sudo deploy/i, (msg) ->
    deploy msg, "Nope.  Now make me a sandwich."


