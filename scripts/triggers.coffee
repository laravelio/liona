# Description:
#   LioBot heeds the call of the last op
#
# Commands:
#   !<trigger> - Display response to intended user
#   Liona learn trigger <trigger> <phrase> - Learn a dynamic trigger
#   Liona forget trigger <trigger> - Forget a dynamic trigger
#
# Notes:
#   Add helpful triggers when you think of them!

whitelist = require '../support/whitelist'

pasteUrl  = "http://laravel.io/bin, https://gist.github.com, or http://kopy.io"
helpUrl   = "http://help.laravel.io"

triggers =
  # Question Assistance
  '!dataja'       : "Don't ask to ask, Just ask!"
  '!nopros'       : "Please don't ask around for pros on something, just present your question to the room according to our guidelines and someone will help you if they can or send you on the right path."
  '!tryit'        : "Please make sure you've attempted something before asking. You learn much more by experimentation than by asking without having even tried."
  '!explain'      : "Explain your business goals, such as what website feature you're making, instead of the technical problem you're facing. We can give you much better answers this way."
  '!help'         : "Before asking for help, please use #{pasteUrl} to provide us the information we need to help you - Laravel version, expected/actual behavior, full error messages, and all relevant code. Paste the link here when done. Thanks!"
  '!paste'        : "You may paste your code at #{pasteUrl}.  Please avoid using pastebin.com - we hate slow load times and ads :)"
  '!dontspam'     : "Please don't paste your code here. Instead, use #{pasteUrl}"
  '!failpaste'    : "Please don't paste your code directly to the room. Instead, use #{pasteUrl}"
  '!debug'        : "Open your <project>/app/config/app.php and set the debug key to true"
  '!pb'           : "Please avoid using pastebin.com as it is slow and forces others to look at ads.  Please use #{pasteUrl}.  Thanks!"
  '!rules'        : "You may review our room rules at http://goo.gl/Tl77U2"
  '!docs'         : "The !docs syntax is deprecated, please use `Liona show <user> docs for <topic>`"
  '!xy'           : "It's difficult to discuss a solution without first understanding the problem. Please, explain the problem itself and not the solution that you have in mind. For more info on presenting your problem see !help. Thanks! Also see http://mywiki.wooledge.org/XyProblem"

  # Helpers
  '!ugt'          : "It is always morning when someone comes into a channel. We call that Universal Greeting Time http://www.total-knowledge.com/~ilya/mips/ugt.html"
  '!nick'         : "Hello! You're currently using a nick that's difficult to distinguish. Please type in \"/nick your_name\" so we can easily identify you"
  '!welcome'      : "Hello, I'm #{process.env.HUBOT_IRC_NICK}, the Laravel IRC Bot!  Welcome to Laravel :).  If you have any questions, type !help to see how to best ask for assistance.  If you need to paste code, check !paste for more info.  Thanks!"
  '!wysiwyg'      : "What you see is what you get"
  '!relsched'     : "Here is our release schedule: http://wiki.laravel.io/Laravel_4#Release_Schedule"
  '!massassign'   : "Getting a MassAssignmentException? Learn what it's all about at http://laravel.com/docs/4.2/eloquent#mass-assignment"
  '!contrib'      : "Want to contribute to Laravel? Thanks for being awesome! Fork and submit a pull request at http://github.com/laravel/framework."
  '!docscontrib'  : "Want to contribute to the documentation? Thanks for being awesome! Fork and submit a pull request at http://github.com/laravel/docs"
  '!liferaft'     : "Liferaft is a Laravel CLI application to help users send pull requests to report bugs, and help developers efficiently retrieve and resolve bugs. Read more at http://laravel.com/docs/contributions#creating-liferaft-applications"
  '!html'         : "Looking for the HTML or Form helpers? They have been removed from the core of Laravel 5. You can still use them via a package. http://laravel.com/docs/5.0/upgrade - Form & HTML Helpers."
  '!form'         : "Looking for the HTML or Form helpers? They have been removed from the core of Laravel 5. You can still use them via a package. http://laravel.com/docs/5.0/upgrade - Form & HTML Helpers."
  '!packages'     : "There have been significant changes to package development in Laravel 5 including the removal of workbench. Please refer to the docs http://laravel.com/docs/5.0/packages"

  # Fun
  '!no'           : "NOOOOOOOOO! http://www.youtube.com/watch?v=umDr0mPuyQc"
  '!drama'        : "I just can't take it anymore...."
  '!tableflip'    : "(╯°□°)╯︵ ┻━┻"
  '!dunno'        : " ¯\\_(ツ)_/¯"
  '!tableflippin' : "http://i.imgur.com/xBQOzc4.gif"
  '!goal'         : "GOOOOOOOOOOOOOOOOOOOOOOAAAAAAAAAAAAAAAAALLLLLLLLLL!!!!!!!"
  '!unstoppable'  : "I am unstoppable!!! http://i.imgur.com/ALHS4Za.png"
  '!haha'         : "http://i.imgur.com/CVhoCwr.jpg"

# Bot Info
nick = process.env.HUBOT_IRC_NICK?.toLowerCase() ? "hubot"

triggers["!#{nick}"]      = "Hello! The Laravel.io team created me to help you! You can find my code at https://github.com/laravelio/liobot"
triggers["!whois#{nick}"] = triggers["!#{nick}"]

module.exports = (robot) ->
  robot.respond /learn trigger (\![a-zA-Z-_\&\^\!\#]+) (.*)/, (msg) ->
    return unless whitelist.canAddTriggers(robot, msg.message.user)
    [name, phrase] = msg.match[1..2]

    robot.brain.set "trigger:#{name}", phrase
    msg.reply "Got it.  Learned '#{name}' as '#{phrase}'."

  robot.respond /forget trigger (\![a-zA-Z-_\&\^\!\#]+)/, (msg) ->
    return unless whitelist.canAddTriggers(robot, msg.message.user)
    name = msg.match[1]

    robot.brain.remove "trigger:#{name}", phrase
    msg.reply "Poof! And now I know nothing about #{name} unless it's hardcoded"


  robot.hear /^(([^:\s!]+)[:\s]+)?(!\w+)(.*)/i, (msg) ->
    user          = msg.match[2]
    trigger       = msg.match[3]
    args          = msg.match[4]
    triggerPhrase = robot.brain.get("trigger:#{trigger}") || triggers[trigger]

    if triggerPhrase
      if user?
        msg.send "#{user}: #{triggerPhrase}"
      else
        msg.send triggerPhrase
    else
      msg.reply "....ya I got nothing for #{trigger}."
