pasteUrl  = "http://laravel.io/bin, https://gist.github.com, or http://kopy.io"

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
  '!debug'        : "Set APP_DEBUG=true in your .env file, or 'debug' => true, in your config/app.php file."
  '!pb'           : "Please avoid using pastebin.com as it is slow and forces others to look at ads.  Please use #{pasteUrl}.  Thanks!"
  '!rules'        : "You may review our room rules at http://goo.gl/Tl77U2"
  '!docs'         : "Laravel's official documentation can be found at https://laravel.com/docs"
  '!xy'           : "It's difficult to discuss a solution without first understanding the problem. Please, explain the problem itself and not the solution that you have in mind. For more info on presenting your problem see !help. Thanks! Also see http://mywiki.wooledge.org/XyProblem"
  '!dump'         : "Getting 'class not found' errors? Try typing `composer dump` into the command prompt to have composer update its reference to your classes."

  # Helpers
  '!ugt'          : "It is always morning when someone comes into a channel. We call that Universal Greeting Time http://www.total-knowledge.com/~ilya/mips/ugt.html"
  '!nick'         : "Hello! You're currently using a nick that's difficult to distinguish. Please type in \"/nick your_name\" so we can easily identify you"
  '!welcome'      : "Hello, I'm #{process.env.HUBOT_IRC_NICK}, the Laravel IRC Bot!  Welcome to Laravel :).  If you have any questions, type !help to see how to best ask for assistance.  If you need to paste code, check !paste for more info.  Thanks!"
  '!wysiwyg'      : "What you see is what you get"
  '!contrib'      : "Want to contribute to Laravel? Thanks for being awesome! Fork and submit a pull request at http://github.com/laravel/framework."
  '!docscontrib'  : "Want to contribute to the documentation? Thanks for being awesome! Fork and submit a pull request at http://github.com/laravel/docs"
  '!html'         : "Looking for the HTML or Form helpers? They are now maintained by the Laravel Collective, https://laravelcollective.com"
  '!form'         : "Looking for the HTML or Form helpers? They are now maintained by the Laravel Collective, https://laravelcollective.com"

  # Fun
  '!no'           : "NOOOOOOOOO! http://www.youtube.com/watch?v=umDr0mPuyQc"
  '!drama'        : "I just can't take it anymore...."
  '!tableflip'    : "(╯°□°)╯︵ ┻━┻"
  '!dunno'        : " ¯\\_(ツ)_/¯"
  '!tableflippin' : "http://i.imgur.com/xBQOzc4.gif"
  '!goal'         : "GOOOOOOOOOOOOOOOOOOOOOOAAAAAAAAAAAAAAAAALLLLLLLLLL!!!!!!!"
  '!unstoppable'  : "I am unstoppable!!! http://i.imgur.com/ALHS4Za.png"
  '!haha'         : "http://i.imgur.com/CVhoCwr.jpg"
  '!phrasing'     : "Phrasing! http://batdoc.files.wordpress.com/2012/03/archer-1-phrasing.jpg"

# Bot Info
nick = process.env.HUBOT_IRC_NICK?.toLowerCase() ? "hubot"

triggers["!#{nick}"]      = "Hello! The Laravel.io team created me to help you! You can find my code at https://github.com/laravelio/liona"
triggers["!whois#{nick}"] = triggers["!#{nick}"]

module.exports = triggers
