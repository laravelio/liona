# Description:
#   LioBot heeds the call of the last op
#
# Commands:
#   !<trigger> - Display response to intended user
#   Liona (list|show) triggers - Lists all triggers in private message
#   Liona learn trigger <trigger> <phrase> - Learn a dynamic trigger
#   Liona show trigger <trigger> - View information about a trigger
#   Liona forget trigger <trigger> - Forget a dynamic trigger
#   Liona suggest trigger <trigger> <phrase> - Suggest a trigger
#   Liona (list|show) suggested triggers - list the waiting suggestions
#   Liona show suggested trigger <id> - show the suggested trigger
#   Liona (reject|forget) suggested trigger <id> - remove a suggested trigger
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

  robot.respond /(list|show) triggers/i, (msg) ->
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

  robot.respond /learn trigger (\![a-zA-Z-_\&\^\!\#]+) (.*)/i, (msg) ->
    return unless whitelist.canAddTriggers(robot, msg.message.user)
    [name, phrase] = msg.match[1..2]

    triggerRepo.save(name, phrase, msg.message.user.name)
    msg.reply "Got it.  Learned '#{name}' as '#{phrase}'."

  robot.respond /show trigger (\![a-zA-Z-_\&\^\!\#]+)/i, (msg) ->
    return unless whitelist.canAddTriggers robot, msg.message.user
    name = msg.match[1]
    trigger = triggerRepo.find name

    return unless trigger

    rmsg = "#{trigger.name} \"#{trigger.phrase}\" [#{trigger.author}]"

    if trigger.suggested_by?
      rmsg = "#{rmsg} {#{trigger.suggested_by}}"

    if trigger.created_at?
      rmsg = "#{rmsg} #{new Date(trigger.created_at).toDateString()}"

    msg.reply rmsg

  robot.respond /forget trigger (\![a-zA-Z-_\&\^\!\#]+)/i, (msg) ->
    return unless whitelist.canAddTriggers(robot, msg.message.user)
    name = msg.match[1]

    triggerRepo.remove name
    msg.reply "Now I know nothing about '#{name}' unless it's hardcoded"

  robot.respond /suggest trigger (\![a-zA-Z-_\&\^\!\#]+) (.*)/i, (msg) ->
    [name, phrase] = msg.match[1..2]

    user = msg.message.user.name

    trigger = suggestRepo.create(name, phrase, user)
    msg.reply "Thank you. It will be waiting for review. (#{trigger.id})"

  robot.respond /(list|show) suggested triggers/i, (msg) ->
    console.log whitelist.canAddTriggers robot, msg.message.user
    return unless whitelist.canAddTriggers(robot, msg.message.user)
    triggers = suggestRepo.all()

    formatter = (list) -> list.map((t) -> "#{t.id}: #{t.name}").join(', ') || 'None'
    msg.reply formatter(triggers)

  robot.respond /show suggested trigger ([a-zA-Z0-9]+)/i, (msg) ->
    return unless whitelist.canAddTriggers robot, msg.message.user
    id = msg.match[1]
    trigger = suggestRepo.find id

    if trigger?
      date = new Date(trigger.created_at).toDateString()
      msg.reply "#{trigger.name} \"#{trigger.phrase}\" [#{trigger.author}] #{date} "

  robot.respond /learn suggested trigger ([a-zA-Z0-9]+)/i, (msg) ->
    return unless whitelist.canAddTriggers robot, msg.message.user
    id = msg.match[1]
    trigger = suggestRepo.find id

    return unless trigger?

    triggerRepo.save trigger.name, trigger.phrase, msg.message.user.name, trigger.author
    suggestRepo.remove id

    msg.reply "Got it.  Learned '#{trigger.name}' as '#{trigger.phrase}'."

  robot.respond /(reject|forget) suggested trigger ([a-zA-Z0-9]+)/i, (msg) ->
    return unless whitelist.canAddTriggers robot, msg.message.user
    id = msg.match[1]
    suggestRepo.remove id
    msg.reply "Removed suggested trigger with id: #{id}."


  robot.hear /^(([^,:\s!]+)[,:\s]+)?(!\w+)(.*)/i, (msg) ->
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
