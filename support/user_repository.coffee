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

  find: (user) ->
    @all().filter((u) -> u.name.toLowerCase() is user.toLowerCase())?[0]

  save: (data, name) ->
    data = {name: name} if !data?
    data.updated_at = Date.now()
    datas = @all(data.name)
    datas.push data
    @set datas
    data

  findOrNew: (name) ->
    @find(name) || @new(name)

  new: (name) ->
    name: name, created_at: Date.now()

  remove: (name) ->
    @set @all name

  all: (without) ->
    data = @brain.get(KEY) || []

    without && (data.filter (u) -> u.name.toLowerCase() isnt without.toLowerCase()) || data

  set: (data) ->
    @brain.set KEY, data

module.exports = UserRepository
