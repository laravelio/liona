# Description:
#   XKCD with a mild twist
#
# Commands:
#   hubot make me a sandwich - No
#   hubot sudo make me sandwich - User is not in the sudoers file

whiteList = require '../support/whitelist'

deniedMsg = "No, make your own sandwich."
sudoMsg   = "User is not in the sudoers file.  This incident will be reported."
allowedMsg= "Okay, root."

module.exports = (robot) ->
  robot.respond /(sudo )?make me a sandwich/i, (msg) ->
    hasSudo = msg.match[1] ? false

    if hasSudo
        if whiteList.isAdmin msg.robot, msg.message.user
            msg.send allowedMsg
        else
            msg.send sudoMsg
    else
      msg.reply deniedMsg
