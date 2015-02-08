# Description:
#   LioBot dynamic permissions in brain
#
# Commands:
#   Liona permissions add <user> to <group>
#
# Notes:
#   Add some more whitelisted users

whitelist = require '../support/whitelist'

validGroups = ['admins', 'teachers']

nameRegex = '[a-zA-Z-_\&\^\!\#]+'

module.exports = (robot) ->
  robot.respond new RegExp("permissions add (#{nameRegex}) to (#{nameRegex})", 'i'), (msg) ->
    [user, group] = msg.match[1..2]
    return unless whitelist.isAdmin(robot, msg.message.user) && validGroups.indexOf(group) isnt -1

    users = robot.brain.get("permissions:#{group}") || []

    return msg.reply("User already in group") unless users.indexOf(user) is -1

    users.push(user)
    robot.brain.set "permissions:#{group}", users
    msg.reply "Added #{user} to #{group}"

  robot.respond new RegExp("permissions remove (#{nameRegex}) from (#{nameRegex})", 'i'), (msg) ->
    [user, group] = msg.match[1..2]
    return unless whitelist.isAdmin(robot, msg.message.user) && validGroups.indexOf(group) isnt -1

    users = robot.brain.get("permissions:#{group}") || []
    index = users.indexOf(user)

    return msg.reply("User is not in group") if index is -1

    users.splice(index, 1)
    robot.brain.set "permissions:#{group}", users
    msg.reply "Removed #{user} from #{group}"

