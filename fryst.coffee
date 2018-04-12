# Description:
#   Fryst
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot what does fryst think? - Ask fryst a question
#
# Author:
#   poboy

fryst = [

  "Just give up",
  "You can't do it",
  "Wow that was dumb",
  "You lick toads...",
  "ask lagbox",
  "Don't be a dumbass",
  "You're a special kind of special, aren't you?",
  "Please get better at life",
  "You really should just use .net instead",
  "I'm here to help.  You are beyond help",
  "OMMFGWTFIWWY",
  "If you don't understand it by now, you never will",
  "Instead of failing at programming, go to https://www.youtube.com/user/howtobbqright",
  "Stop believing in yourself",
  "There's nothing standing between you and your goal but a total lack of talent and a complete failure of will",
  "If you want affirmation, get a puppy.  The rest of us are trying to work",
  "You want sympathy, look in the dictionary between shit and syphilis!"
]

module.exports = (robot) ->
  robot.respond /what does fryst think\?/i, (msg) ->
    msg.reply msg.random fryst
