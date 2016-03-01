# Description:
#   Deploy the app
#
# Commands:
#   hubot deploy

whitelist = require '../support/whitelist'

deploy = (msg, failMsg = 'Nope') ->
  if whitelist.canDeploy(msg.robot, msg.message.user)
    branch = msg.match[1] || 'master'
    msg.reply "Fetching and deploying #{branch}.  Wish me luck!"
    require('child_process').spawn('./bin/deploy.sh', [branch], detached: true).unref()
  else
    msg.reply failMsg

module.exports = (robot) ->
  robot.respond /deploy ?([a-zA-Z-_\&\^\/\-\!\#]+)?/i, (msg) ->
    deploy msg

  robot.respond /sudo deploy/i, (msg) ->
    deploy msg, "Nope.  Now make me a sandwich."
