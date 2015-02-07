# Description:
#   Liona is just so awesome
#
# Commands:
#   hubot <3

whitelistedUsers = process.env.HUBOT_ALLOWED_USERS?.split(',') || []

isWhitelisted = (user) -> whitelistedUsers.indexOf(user.name) isnt -1
module.exports = (robot) ->
  robot.respond /say to ([a-zA-Z-_\#]+) (.*)/, (msg) ->
    if isWhitelisted(msg.message.user)
      [room, message] = msg.match[1..2]
      robot.messageRoom room, message
    else
      msg.reply "Denied because you #{msg.message.user.name} are not of list #{whitelistedUsers}"
