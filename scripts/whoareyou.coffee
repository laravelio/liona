# Description:
#   Tell people about the bot
#
# Commands:
#   hubot who are you

module.exports = (robot) ->
  robot.respond /who are you\??$/i, (msg) ->
    msg.reply "Hello! The Laravel.io team created me to help you! You can find my code at https://github.com/laravelio/liona"

  robot.respond /which version\??$/i, (msg) ->
    version = process.env.HUBOT_GIT_SHA || false

    if version
      msg.reply "I'm currently on SHA #{version}."
    else
      msg.reply "Someone needs to store a magical incantation to
                 the HUBOT_GIT_SHA env var so I can look this up"
