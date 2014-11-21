# Description:
#   LioBot heeds the call of the last op
#
# Commands:
#   !<trigger> - Display response to intended user
#
# Notes:
#   Add helpful triggers when you think of them!

pasteUrl = "http://laravel.io/bin or https://gist.github.com"
helpUrl  = "http://help.laravel.io"

triggers =
  # Question Assistance
  '!dataja'       : "Don't ask to ask, Just ask!"
  '!tryit'        : "Try it and see™. You learn much more by experimentation than by asking without having even tried."
  '!explain'      : "Explain your business goals, such as what website feature you're making, instead of the technical problem you're facing. We can give you much better answers this way."
  '!help'         : "Before asking for help, use #{pasteUrl} to provide us the information we need to help you - Laravel version, expected/actual behavior, and all relevant code. Paste the link here when done. Thanks!"
  '!helpme'       : "Before asking for help, use #{pasteUrl} to provide us the information we need to help you - Laravel version, expected/actual behavior, and all relevant code. Paste the link here when done. Thanks!"
  '!paste'        : "You may paste your code at #{pasteUrl}.  Please avoid using pastebin.com"
  '!dontspam'     : "Please don't paste your code here. Instead, use #{pasteUrl}"
  '!debug'        : "Open your <project>/app/config/app.php and set the debug key to true"
  '!pb'           : "Please avoid using pastebin.com as it is slow and forces others to look at ads.  Please use #{pasteUrl}.  Thanks!"
  '!rules'        : "You may review our room rules at http://goo.gl/Tl77U2"
  '!docs'         : "The !docs syntax is deprecated, please use `Liona show <user> docs for <topic>`"
  '!usedev'       : "Only use the dev version if you don't mind potentially needing to change your app on updates if the API or concepts change. Stability is not guaranteed."

  # Helpers
  '!ugt'          : "It is always morning when someone comes into a channel. We call that Universal Greeting Time http://www.total-knowledge.com/~ilya/mips/ugt.html"
  '!nick'         : "Hello! You're currently using a nick that's difficult to distinguish. Please type in \"/nick your_name\" so we can easily identify you"
  '!wiki'         : "Check out our wiki at http://wiki.laravel.io!"
  '!welcome'      : "Hello, I'm #{process.env.HUBOT_IRC_NICK}, the Laravel IRC Bot!  Welcome to Laravel :).  If you have any questions, type !help to see how to best ask for assistance.  If you need to paste code, check !paste for more info.  Thanks!"
  '!wysiwyg'      : "What you see is what you get"
  '!relsched'     : "Here is our release schedule: http://wiki.laravel.io/Laravel_4#Release_Schedule"
  '!massassign'   : "Getting a MassAssignmentException? Find out how to protect your input at: http://wiki.laravel.io/FAQ_(Laravel_4)#MassAssignmentException"
  '!docscontrib'  : "Want to contribute to the documentation? Awesome! Fork and submit a pull request at http://github.com/laravel/docs"

  # Fun
  '!no'           : "NOOOOOOOOO! http://www.youtube.com/watch?v=umDr0mPuyQc"
  '!xy'           : "It's difficult to discuss a solution without first understanding the problem. Please, explain the problem itself and not the solution that you have in mind. For more info on presenting your problem see !help. Thanks! Also see http://mywiki.wooledge.org/XyProblem"
  '!drama'        : "I just can't take it anymore...."
  '!41update'     : "If you're updating from 4.0.x to Laravel 4.1, make sure you follow the steps in http://laravel.com/docs/upgrade to avoid common issues. This is due to necessary changes to the Laravel core to make things more awesome."
  '!43'           : "Laravel 4.3 has been bumped to 5.0 and is expected to be released in January."
  '!5'            : "Laravel 5.0 is expected to be released in January."
  '!ghissues'     : "Laravel's GitHub issues are closed. Please see #laravel-dev or check out ways you can report a bug at http://laravel.com/docs/contributions#bugs"
  '!liferaft'     : "Liferaft is a Laravel CLI application to help users send pull requests to report bugs, and help developers efficiently retrieve and resolve bugs. Read more at http://laravel.com/docs/contributions#creating-liferaft-applications"
  '!tableflip'    : "(╯°□°)╯︵ ┻━┻"
  '!dunno'        : " ¯\\_(ツ)_/¯"
  '!tableflippin' : "http://i.imgur.com/xBQOzc4.gif"
  '!testing'      : "lolnope"
  '!goal'         : "GOOOOOOOOOOOOOOOOOOOOOOAAAAAAAAAAAAAAAAALLLLLLLLLL!!!!!!!"
  '!unstoppable'  : "I am unstoppable!!! http://i.imgur.com/ALHS4Za.png"

# Bot Info
nick = process.env.HUBOT_IRC_NICK?.toLowerCase() ? "hubot"

triggers["!#{nick}"]      = "Hello! The Laravel.io team created me to help you! You can find my code at https://github.com/laravelio/liobot"
triggers["!whois#{nick}"] = triggers["!#{nick}"]

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
    else
      msg.reply "....ya I got nothing."
