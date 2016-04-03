#
# user structure
# {
#   name: 'liona',
#   created_at: ...,
#   updated_at: ...,
#   lang: Flanders,
#   last_greeted_at: ...
# }
#

class UserRepository
  KEY = 'user-settings'

  constructor: (@brain) ->
    @cache = []
    @brain.on 'loaded', =>
      braindata = brain.data._private[KEY]
      @cache = braindata if braindata

  find: (user) ->
    @all().filter((u) -> u.name.toLowerCase() is user.toLowerCase())?[0]

  save: (data, name) ->
    data = {name: name} if !data?
    data.updated_at = Date.now()
    @cache = @all data.name
    @cache.push data
    @set @cache
    data

  findOrNew: (name) ->
    @find(name) || @new(name)

  new: (name) ->
    name: name, created_at: Date.now()

  remove: (name) ->
    @set @all name

  all: (without) ->
    without && (@cache.filter (u) -> u.name.toLowerCase() isnt without.toLowerCase()) || @cache

  set: (data) ->
    @brain.set KEY, data

module.exports = UserRepository
