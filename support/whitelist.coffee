allowedUsers = process.env.HUBOT_ALLOWED_USERS?.split(',') || []
teachers     = process.env.HUBOT_WHITELISTED_TEACHERS?.split(',') || []
teachers     = teachers.concat allowedUsers

canDeploy      = (user) -> allowedUsers.indexOf(user.name) isnt -1
canAddTriggers = (user) -> teachers.indexOf(user.name) isnt -1

module.exports =
  canDeploy: canDeploy
  canSay: canDeploy
  canAddTriggers: canAddTriggers
