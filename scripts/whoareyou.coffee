# Description:
#   Tell people about the bot
#
# Commands:
#   hubot who are you

module.exports = (robot) ->
  robot.respond /who are you\??$/i, (msg) ->
    msg.reply "Hello! The Laravel.io team created me to help you! You can find my code at https://github.com/laravelio/liobot"
