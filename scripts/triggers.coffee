# Description:
#   LioBot heeds the call of the last op
#
# Commands:
#   !<trigger> - Display response to intended user
#   Liona learn trigger <trigger> <phrase> - Learn a dynamic trigger
#   Liona forget trigger <trigger> - Forget a dynamic trigger
#   Liona suggest trigger <trigger> <phrase> - Suggest a trigger
#   Liona list suggested triggers - list the waiting suggestions
#   Liona show trigger <id> - show the suggested trigger
#   Liona forget suggested trigger <id> - remove a suggested trigger
#   Liona learn suggested trigger <id> - add the suggested trigger to the triggers
#
# Notes:
#   Add helpful triggers when you think of them!

whitelist   = require '../support/whitelist'
TriggerRepo = require '../support/trigger_repository'
SuggestedRepo = require '../support/suggested_trigger_repository'

module.exports = (robot) ->
  triggerRepo = new TriggerRepo(robot.brain)
  suggestRepo = new SuggestedRepo(robot.brain)

  robot.respond /list triggers/, (msg) ->
    triggers = triggerRepo.all()
    formatter = (list) -> list.map((t) -> t.name).join(', ') || 'None'
    message = "Available triggers: "

    user = msg.message.user.name

    # make it a private message
    if msg.message.room
      msg.message.room = user

    if msg.message.user?.room
      msg.message.user.room = user

    msg.send message + formatter(triggers)

  robot.respond /learn trigger (\![a-zA-Z-_\&\^\!\#]+) (.*)/, (msg) ->
    return unless whitelist.canAddTriggers(robot, msg.message.user)
    [name, phrase] = msg.match[1..2]

    triggerRepo.save(name, phrase, msg.message.user.username)
    msg.reply "Got it.  Learned '#{name}' as '#{phrase}'."

  robot.respond /forget trigger (\![a-zA-Z-_\&\^\!\#]+)/, (msg) ->
    return unless whitelist.canAddTriggers(robot, msg.message.user)
    name = msg.match[1]

    triggerRepo.remove name
    msg.reply "Now I know nothing about '#{name}' unless it's hardcoded"

  robot.respond /suggest trigger (\![a-zA-Z-_\&\^\!\#]+) (.*)/, (msg) ->
    [name, phrase] = msg.match[1..2]

    user = msg.message.user.name

    suggestRepo.create(name, phrase, user)
    msg.reply "Thank you. It will be waiting for review."

  robot.respond /list suggested triggers/, (msg) ->
    console.log whitelist.canAddTriggers robot, msg.message.user
    return unless whitelist.canAddTriggers(robot, msg.message.user)
    triggers = suggestRepo.all()

    formatter = (list) -> list.map((t) -> "#{t.id}: #{t.name}").join(', ') || 'None'
    msg.reply formatter(triggers)

  robot.respond /show trigger ([a-zA-Z0-9]+)/, (msg) ->
    return unless whitelist.canAddTriggers robot, msg.message.user
    id = msg.match[1]
    trigger = suggestRepo.find id

    if trigger?
      date = new Date(trigger.created_at).toDateString()
      msg.reply "#{trigger.name} \"#{trigger.phrase}\" [#{trigger.author}] #{date} "

  robot.respond /learn suggested trigger ([a-zA-Z0-9]+)/, (msg) ->
    return unless whitelist.canAddTriggers robot, msg.message.user
    id = msg.match[1]
    trigger = suggestRepo.find id

    return unless trigger?

    triggerRepo.save trigger.name, trigger.phrase, msg.message.user.name
    suggestRepo.remove id

    msg.reply "Got it.  Learned '#{trigger.name}' as '#{trigger.phrase}'."

  robot.respond /forget suggested trigger ([a-zA-Z0-9]+)/, (msg) ->
    return unless whitelist.canAddTriggers robot, msg.message.user
    id = msg.match[1]
    suggestRepo.remove id
    msg.reply "Removed suggested trigger with id: #{id}."


  robot.hear /^(([^:\s!]+)[:\s]+)?(!\w+)(.*)/i, (msg) ->
    user    = msg.match[2]
    name    = msg.match[3]
    args    = msg.match[4]
    phrase  = triggerRepo.find(name)?.phrase

    if phrase?
      if user?
        msg.send "#{user}: #{phrase}"
      else
        msg.send phrase
    else
      msg.reply "....ya I got nothing for #{name}."
