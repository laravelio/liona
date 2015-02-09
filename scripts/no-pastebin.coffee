# Description:
#   Pastebin sucks
#
pasteUrl  = "http://laravel.io/bin, https://gist.github.com, or http://kopy.io"

module.exports = (robot) ->
  robot.hear /pastebin\.com\//i, (msg) ->
    msg.reply "Please use #{pasteUrl} for pasting code - we dislike slow load times and ads with Pastebin."


