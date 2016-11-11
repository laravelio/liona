#
# record structure
# {
#   id: 'x3jrja',
#   name: '!foo',
#   phrase: '...',
#   created_at: ...,
#   author: '...'
# }
#

class SuggestedTriggerRepository
  KEY = 'suggested-triggers'

  constructor: (@brain) ->
    @cache = []
    @brain.on 'loaded', =>
      braindata = brain.data._private[KEY]
      @cache = braindata if braindata

  find: (key) ->
    @all().filter((u) -> u.id.toLowerCase() is key.toLowerCase())?[0]

  save: (data) ->
    @cache = @all data.name
    @cache.push data
    @set @cache
    data

  create: (name, phrase, user) ->
    @save @new name, phrase, user

  new: (name, phrase, user) ->
    name: name, created_at: Date.now(),
    phrase: phrase, author: user,
    id: Math.random().toString(36).replace(/[^a-z]+/g, '').substr(0, 6)

  remove: (key) ->
    @set @all key

  all: (without) ->
    without && (@cache.filter (u) -> u.id.toLowerCase() isnt without.toLowerCase()) || @cache

  set: (data) ->
    @brain.set KEY, data

module.exports = SuggestedTriggerRepository
