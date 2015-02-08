allowedUsers = process.env.HUBOT_ALLOWED_USERS?.split(',') || []
teachers     = process.env.HUBOT_WHITELISTED_TEACHERS?.split(',') || []
teachers     = teachers.concat allowedUsers

canDeploy      = (robot, user) ->
  allowedUsers.concat(robot.brain.get("permissions:admins") || []).indexOf(user.name) isnt -1
canAddTriggers = (robot, user) ->
  teachers.concat(robot.brain.get("permissions:teachers") || []).indexOf(user.name) isnt -1

module.exports =
  canDeploy: canDeploy
  canSay: canDeploy
  isAdmin: canDeploy
  canAddTriggers: canAddTriggers
