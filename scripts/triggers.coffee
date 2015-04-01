# Description:
#   Octobot heeds the call of the last op
#
# Commands:
#   !<trigger> - Display response to intended user
#
# Notes:
#   Add helpful triggers when you think of them!

triggers =
  # Question Assistance
  '!dataja'       : "Don't ask to ask, Just ask!"
  '!tryit'        : "Try it and see™. You learn much more by experimentation than by asking without having even tried."
  '!explain'      : "Explain your business goals, such as what website feature you're making, instead of the technical problem you're facing. We can give you much better answers this way."
  '!help'         : "Before asking for help, use http://kopy.io to provide us the information we need to help you - October build, expected/actual behavior, and all relevant code. Paste the link here when done. Thanks!"
  '!helpme'       : "Before asking for help, use http://kopy.io to provide us the information we need to help you - October build, expected/actual behavior, and all relevant code. Paste the link here when done. Thanks!"
  '!paste'        : "You may paste your code at http://kopy.io"
  '!dontspam'     : "Please don't paste your code here. Instead, use http://kopy.io"
  '!pb'           : "Please avoid using pastebin.com as it is slow and forces others to look at ads. Please use http://kopy.io - Thanks!"
  '!rules'        : "You may review our room rules at http://goo.gl/Tl77U2"

  # Helpers
  '!ugt'          : "It is always morning when someone comes into a channel. We call that Universal Greeting Time http://www.total-knowledge.com/~ilya/mips/ugt.html"
  '!nick'         : "Hello! You're currently using a nick that's difficult to distinguish. Please type in \"/nick your_name\" so we can easily identify you"
  '!welcome'      : "Hello, I'm #{process.env.HUBOT_IRC_NICK}, the OctoberCMS IRC Bot!  Welcome to October :).  If you have any questions, type !help to see how to best ask for assistance.  If you need to paste code, check !paste for more info.  Thanks!"
  '!wysiwyg'      : "What you see is what you get"
  '!massassign'   : "Getting a MassAssignmentException? Find out how to protect your input at: http://wiki.laravel.io/FAQ_(Laravel_4)#MassAssignmentException"
  '!docscontrib'  : "Want to contribute to the documentation? Awesome! Fork and submit a pull request at https://github.com/octobercms/docs"
  '!whoisoctobot'  : "Hello! The October team created me to help you! You can find my code at https://github.com/daftspunk/Octobot"

  # Fun
  '!no'           : "NOOOOOOOOO! http://www.youtube.com/watch?v=umDr0mPuyQc"
  '!xy'           : "It's difficult to discuss a solution without first understanding the problem. Please, explain the problem itself and not the solution that you have in mind. For more info on presenting your problem see !help. Thanks! Also see http://mywiki.wooledge.org/XyProblem"
  '!drama'        : "I just can't take it anymore...."
  '!beta'         : "If you're updating from Beta to October RC, make sure you follow the steps in http://octobercms.com/beta to avoid common issues. This is due to necessary changes to the October core to make things more awesome."
  '!tableflip'    : "(╯°□°)╯︵ ┻━┻"
  '!dunno'        : " ¯\_(ツ)_/¯"
  '!tableflippin' : "http://i.imgur.com/xBQOzc4.gif"
  '!testing'      : "lolnope"
  '!goal'         : "GOOOOOOOOOOOOOOOOOOOOOOAAAAAAAAAAAAAAAAALLLLLLLLLL!!!!!!!"
  '!unstoppable'  : "I am unstoppable!!! http://i.imgur.com/ALHS4Za.png"
  '!magic'        : "http://www.reactiongifs.com/r/mgc.gif"
  '!mindblown'    : "http://www.reactiongifs.com/wp-content/uploads/2011/09/mind_blown.gif"

module.exports = (robot) ->
  robot.hear /(([^:\s!]+)[:\s]+)?(!\w+)(.*)/i, (msg) ->
    user          = msg.match[2]
    trigger       = msg.match[3]
    args          = msg.match[4]
    triggerPhrase = triggers[trigger]

    if triggerPhrase
      if user?
        msg.send "#{user}: #{triggerPhrase}"
      else
        msg.send triggerPhrase
