# Description:
#   LioBot heeds the call of the last op
#
# Commands:
#   !<trigger> - Display response to intended user
#
# Notes:
#   Add helpful triggers when you think of them!

triggers =
  # Question Assistance
  '!dataja'       : "Don't ask to ask, Just ask!"
  '!help'         : "Before asking for help, use http://help.laravel.io to provide us the information we need to help you - Laravel version, expected/actual behavior, and all relevant code. Paste the link here when done. Thanks!"
  '!helpme'       : "Before asking for help, use http://help.laravel.io to provide us the information we need to help you - Laravel version, expected/actual behavior, and all relevant code. Paste the link here when done. Thanks!"
  '!paste'        : "You may paste your code at http://laravel.io/bin"
  '!pb'           : "Please avoid using pastebin.com as it is slow and forces others to look at ads.  Please use http://laravel.io/bin.  Thanks!"

  # Helpers
  '!ugt'          : "It is always morning when someone comes into a channel. We call that Universal Greeting Time http://www.total-knowledge.com/~ilya/mips/ugt.html"
  '!nick'         : "Hello! You're currently using a nick that's difficult to distinguish. Please type in \"/nick your_name\" so we can easily identify you"
  '!wiki'         : "Check out our wiki at http://wiki.laravel.io!"
  '!welcome'      : "Hello, I'm #{process.env.HUBOT_IRC_NICK}, the Laravel IRC Bot!  Welcome to Laravel :).  If you have any questions, type !help to see how to best ask for assistance.  If you need to paste code, check !paste for more info.  Thanks!"
  '!wysiwyg'      : "What you see is what you get"
  '!relsched'     : "Here is our release schedule: http://wiki.laravel.io/Laravel_4#Release_Schedule"
  '!massassign'   : "Getting a MassAssignmentException? Find out how to protect your input at: http://wiki.laravel.io/FAQ_(Laravel_4)#MassAssignmentException"
  '!docscontrib'  : "Want to contribute to the documentation? Awesome! Fork and submit a pull request at http://github.com/laravel/docs"
  '!whoisliobot'  : "Hello! The Laravel.io team created me to help you! You can find my code at https://github.com/laravelio/liobot"

  # Fun
  '!no'           : "NOOOOOOOOO! http://www.youtube.com/watch?v=umDr0mPuyQc"
  '!xy'           : "It's difficult to discuss a solution without first understanding the problem. Please, explain the problem itself and not the solution that you have in mind. For more info on presenting your problem see !help. Thanks! Also see http://mywiki.wooledge.org/XyProblem"
  '!drama'        : "I just can't take it anymore...."
  '!41update'     : "If you're updating from 4.0.x to Laravel 4.1, make sure you follow the steps in https://github.com/laravel/laravel/blob/develop/upgrade.md to avoid common issues. This is due to necessary changes to the Laravel core to make things more awesome."
  '!tableflip'    : "(╯°□°)╯︵ ┻━┻"
  '!tableflippin' : "http://i.imgur.com/xBQOzc4.gif"
  '!testing'      : "lolnope"

module.exports = (robot) ->
  robot.hear /(!\w+)(?:\s+)?(\w+)?/, (msg) ->
    trigger       = msg.match[1]
    user          = msg.match[2]
    triggerPhrase = triggers[trigger]

    if triggerPhrase
      if user?
        msg.send "#{user}: #{triggerPhrase}"
      else
        msg.reply triggerPhrase
