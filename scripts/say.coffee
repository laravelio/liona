# Description:
#   Liona is just so awesome
#
# Commands:
#   hubot <3

whitelist = require '../support/whitelist'

module.exports = (robot) ->
  robot.respond /say to ([a-zA-Z-_\#]+) (.*)/, (msg) ->
    if whitelist.canSay(robot, msg.message.user)
      [room, message] = msg.match[1..2]
      robot.messageRoom room, message
    else
      msg.reply "Denied because you #{msg.message.user.name} are not in the access list."
