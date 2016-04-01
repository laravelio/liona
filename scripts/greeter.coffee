# Description:
#   Language based greetings, and laravenewbie nick change welcome message
#
# Commands:
#   hubot show greeting for {language}
#   hubot I speak {language}
#   hubot forget my greeting
#   hubot what is my greeting
#   hubot what is my language
#   hubot greeting(s)
#   hubot greet {user}( in {langugage})
#   hubot greet me
#
#   hubot clear last greet
#   hubot forget me

UserRepo = require '../support/user_repository'
GreetingRepo = require '../support/greetings'

CACHETIME = 1000 * 60 * 60


# greetings helpers
buildGreeting = (obj, user) ->
  {greeting: greeting, lang: lang} = obj
  "#{greeting} #{user}! (#{lang})"

cantFindIt = (lang) ->
  "Sorry no such language, #{lang}."

doUserGreet = (users, greetings, name) ->
  user = users.find name
  if user?.lang?
    if user.last_greeted_at? && (Date.now() - user.last_greeted_at) < CACHETIME
      return

    users.greeted user
    return buildGreeting greetings.find(user.lang), (name || user.name)

# helpy helpers
userName = (msg) ->
  msg.message.user.name

roomName = (msg) ->
  msg.message.room


# add some sh...tuff to the UserRepo
UserRepo::greeted = (user) ->
  user.last_greeted_at = Date.now()
  @save user
  user

UserRepo::clearGreet = (user) ->
  if user?.last_greeted_at?
    delete user.last_greeted_at
    @save user
  user

UserRepo::updateLang = (name, lang) ->
  user = @findOrNew name
  user.lang = lang
  @save user

UserRepo::clearLang = (name) ->
  user = @find name
  if user?.lang?
    delete user.lang
    @save user

UserRepo::nameUser = (msg) ->
  name = userName msg
  [name, @find name]


# Da Exports

module.exports = (robot) ->
  userRepo = new UserRepo(robot.brain)
  greetings = new GreetingRepo


  respondClearLastGreet = (msg) ->
    userRepo.clearGreet userRepo.find userName msg

  respondGreetings = (msg) ->
    greeting = greetings.random msg
    user = userName msg
    msg.send buildGreeting greeting, user

  respondGreetUserInLanguage = (msg) ->
    console.log msg.match
    [name, lang] = msg.match[1..2]
    user = userRepo.findOrNew name
    greeting = greetings.findOrRandom msg, (lang? && lang || user.lang)
    msg.send buildGreeting greeting, name

  respondGreetMe = (msg) ->
    name = userName msg
    message = doUserGreet userRepo, greetings, name
    msg.send message if message

  respondISpeak = (msg) ->
    lang = msg.match[1]
    name = userName msg
    greeting = greetings.find lang

    if greeting
      userRepo.updateLang name, lang
      message = "You will now be greeted in #{greeting['lang']}."

    msg.reply message || cantFindIt lang

  respondForgetMe = (msg) ->
    name = userName msg
    userRepo.remove name

  respondForgetMyGreeting = (msg) ->
    user = userRepo.find userName msg
    userRepo.clearLang user if user
    msg.reply "I have already forgotten what we were talking about."

  respondWhatIsMyGreeting = (msg) ->
    [name, user] = userRepo.nameUser msg

    if user?.lang?
      msg.send buildGreeting greetings.find(user.lang), name
    else
      msg.reply "No greeting set."

  respondWhatIsMyLanguage = (msg) ->
    user = userRepo.find userName msg

    if user?.lang?
      msg.reply "Your set language is " + greetings.find(user.lang).lang + "."
    else
      msg.reply "You have no language set."

  respondShowGreetingFor = (msg) ->
    lang = msg.match[1]
    name = userName msg
    greeting = greetings.find lang

    msg.send greeting && buildGreeting greeting, name || cantFindIt lang

  userEnters = (msg) ->
    name = userName msg

    if name.indexOf('laravelnewbie') > -1
      message = "Good morning #{name}, welcome to #{roomName(msg)}.  Please type in \"/nick your_new_nick\" to change your name so we can distinguish you easily."
    else
      message = doUserGreet userRepo, greetings, name

    msg.send message if message


  robot.respond /clear last greet/i, respondClearLastGreet

  robot.respond /greeting(s)?/i, respondGreetings

  robot.respond /greet ([^me|^\s!]+)(?: in (.+))?/i, respondGreetUserInLanguage

  robot.respond /greet me/i, respondGreetMe

  robot.respond /i speak (.+)/i, respondISpeak

  robot.respond /forget me/i, respondForgetMe

  robot.respond /forget my greeting/i, respondForgetMyGreeting

  robot.respond /what is my greeting(\?)?/i, respondWhatIsMyGreeting

  robot.respond /what is my language(\?)?/i, respondWhatIsMyLanguage

  robot.respond /show greeting for (.+)/i, respondShowGreetingFor

  robot.enter userEnters
