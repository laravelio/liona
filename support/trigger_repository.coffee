hardcodedTriggers = require '../support/hardcoded_triggers'

class TriggerRepository
  KEY                = 'triggers'
  HARDCODED_TRIGGERS = hardcodedTriggers

  # New structure for triggers:
  # {
  #   name: "!foo",
  #   phrase: "Foo bar",
  #   author: "foobar",
  #   created_at: 12309....,
  # }
  constructor: (@brain) ->

  find: (trigger) ->
    @brainTrigger(trigger) || @hardcodedTrigger(trigger)

  save: (name, phrase, author = 'Liona') ->
    trigger = name: name, phrase: phrase, author: author, created_at: Date.now()
    triggers = @brainTriggers().filter (t) -> t.name isnt name
    triggers.push trigger

    @brain.set KEY, triggers
    trigger

  remove: (trigger) ->
    @brain.set KEY, @brainTriggers().filter (t) -> t.name isnt trigger

  all: ->
    all = (@hardcodedTrigger(trigger) for trigger, phrase of HARDCODED_TRIGGERS)
    all.push trigger for trigger in @brainTriggers()
    all

  allByAuthor: (author) ->
    @all().filter (trigger) -> trigger.author.toLowerCase() is author?.toLowerCase()

  brainTriggers: ->
    @brain.get(KEY) || []

  brainTrigger: (trigger) ->
    @brainTriggers().filter((t) -> t.name is trigger)?[0]

  hardcodedTrigger: (trigger) ->
    phrase = HARDCODED_TRIGGERS[trigger]
    return unless phrase?
    name: trigger, phrase: phrase, author: 'Liona'

module.exports = TriggerRepository
