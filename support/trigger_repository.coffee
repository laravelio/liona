hardcodedTriggers = require '../support/hardcoded_triggers'

class TriggerRepository
  LEGACY_KEY         = 'trigger'
  KEY                = 'triggers'
  HARDCODED_TRIGGERS = hardcodedTriggers

  # New structure for triggers:
  # {
  #   name: "!foo",
  #   phrase: "Foo bar",
  #   author: "foobar"
  # }
  constructor: (@brain) ->

  find: (trigger) ->
    @swapLegacy(trigger)
    @brainTrigger(trigger) || @hardcodedTrigger(trigger)

  save: (name, phrase, author = 'Liona') ->
    trigger = name: name, phrase: phrase, author: author
    triggers = @brainTriggers()
    triggers.push trigger

    @brain.set KEY, triggers
    trigger

  remove: (trigger) ->
    triggerObj = @find(trigger) # Cleans up any legacy triggers
    triggers = @brainTriggers()
    index = triggers.indexOf triggerObj
    triggers.splice(triggerObj, 1) unless index is -1
    @brain.set KEY, triggers

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

  legacyTrigger: (trigger) ->
    @brain.get "#{LEGACY_KEY}:#{trigger}"

  hardcodedTrigger: (trigger) ->
    phrase = HARDCODED_TRIGGERS[trigger]
    return unless phrase?
    name: trigger, phrase: phrase, author: 'Liona'

  swapLegacy: (trigger) ->
    legacyPhrase = @legacyTrigger(trigger)
    if legacyPhrase?
      @save(trigger, legacyPhrase)
      @brain.remove "#{LEGACY_KEY}:#{trigger}"

module.exports = TriggerRepository
