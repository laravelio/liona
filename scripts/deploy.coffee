# Description:
#   Deploy the app
#
# Commands:
#   hubot deploy

whitelistedUsers = process.env.HUBOT_ALLOWED_USERS?.split(',') || []

module.exports = (robot) ->
  robot.respond /deploy/i, (msg) ->
    if whitelistedUsers.indexOf(msg.message.user.name) isnt -1
      msg.reply "Fetching and deploying latest version.  Wish me luck!"
      require('child_process').spawn('./bin/deploy.sh', [], detached: true).unref()
    else
      msg.reply "Nope"

  robot.respond /sudo deploy/i, (msg) ->
    if whitelistedUsers.indexOf(msg.message.user.name) isnt -1
      msg.reply "Fire ze missiles!"
      require('child_process').spawn('./bin/deploy.sh', [], detached: true).unref()
    else
      msg.reply "Nope.  Now make me a sandwich."


