# Description:
#   Pastebin sucks
#
pasteUrl = "https://bpaste.net, https://paste.laravel.io or https://gist.github.com"

module.exports = (robot) ->
  robot.hear /pastebin\.com\//i, (msg) ->
    msg.reply "Please use #{pasteUrl} for pasting code - we dislike slow load times and ads with Pastebin."
