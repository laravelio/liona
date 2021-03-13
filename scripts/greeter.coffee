# Description:
#   Language based greetings, and laravenewbie nick change welcome message
#
# Commands:
#   hubot show greeting for <language>
#   hubot I speak <language>
#   hubot forget my greeting
#   hubot what is my greeting
#   hubot what is my language
#   hubot greeting(s)
#   hubot greet <user>( in <langugage>)
#   hubot greet me
#   hubot greetings <on|off>
#   hubot show user greeting for <user>
#   hubot set greeting for <user> to <lang>
#   hubot unset greeting for <user>
#   hubot show throttle time
#   hubot set throttle to <seconds>
#
#   hubot clear last greet
#   hubot forget me

UserRepo = require '../support/user_repository'
GreetingRepo = require '../support/greetings'
whiteList = require '../support/whitelist'

CACHETIME = 1000 * 60 * 60 * 12
THROTTLETIME = 2
LIMITS = {}

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
    buildGreeting greetings.find(user.lang), (name || user.name)

# helpy helpers
userName = (msg) ->
  msg.message.user.name

roomName = (msg) ->
  msg.message.room

throttle = (name) ->
  return true if LIMITS[name]? and LIMITS[name] > Date.now() - (THROTTLETIME * 1000)
  LIMITS[name] = Date.now()
  false

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
  userRepo = new UserRepo robot.brain
  greetings = new GreetingRepo

  allowGreetings = true

  clearLastGreet = (msg) ->
    userRepo.clearGreet userRepo.find userName msg

  respondGreetings = (msg) ->
    return unless allowGreetings
    greeting = greetings.random msg
    user = userName msg
    msg.send buildGreeting greeting, user

  greetUserInLanguage = (msg) ->
    return unless allowGreetings
    [name, lang] = msg.match[1..2]
    user = userRepo.findOrNew name
    greeting = greetings.findOrRandom msg, (lang? && lang || user.lang)
    msg.send buildGreeting greeting, name

  greetMe = (msg) ->
    return unless allowGreetings
    name = userName msg
    message = doUserGreet userRepo, greetings, name
    msg.send message if message

  iSpeak = (msg) ->
    lang = msg.match[1]
    name = userName msg
    greeting = greetings.find lang
    if greeting
      userRepo.updateLang name, lang
      message = "You will now be greeted in #{greeting['lang']}."
    msg.reply message || cantFindIt lang

  forgetMe = (msg) ->
    name = userName msg
    userRepo.remove name

  forgetMyGreeting = (msg) ->
    user = userRepo.find userName msg
    userRepo.clearLang user.name if user
    msg.reply "I have already forgotten what we were talking about."

  whatIsMyGreeting = (msg) ->
    [name, user] = userRepo.nameUser msg
    if user?.lang?
      msg.send buildGreeting greetings.find(user.lang), name
    else
      msg.reply "No greeting set."

  whatIsMyLanguage = (msg) ->
    user = userRepo.find userName msg
    if user?.lang?
      msg.reply "Your set language is " + greetings.find(user.lang).lang + "."
    else
      msg.reply "You have no language set."

  showGreetingFor = (msg) ->
    return unless allowGreetings
    lang = msg.match[1]
    name = userName msg
    greeting = greetings.find lang
    msg.send greeting && buildGreeting greeting, name || cantFindIt lang

  showGreetingForUser = (msg) ->
    if whiteList.isTeacher msg.robot, msg.message.user
      username = msg.match[1]
      otheruser = userRepo.find username
      if otheruser?.lang?
        msg.reply "#{username}'s language is #{greetings.find(otheruser.lang).lang}."

  setUserGreetingTo = (msg) ->
    if whiteList.isAdmin msg.robot, msg.message.user
      [username, lang] = msg.match[1..2]
      userRepo.updateLang username, lang
      msg.reply "#{username}'s language is now #{greetings.find(lang).lang}"

  unsetUserGreeting = (msg) ->
    if whiteList.isAdmin msg.robot, msg.message.user
      username = msg.match[1]
      userRepo.clearLang username
      msg.reply "#{username}'s language has been unset."

  greetingsOnOff = (msg) ->
    if whiteList.isTeacher msg.robot, msg.message.user
      state = msg.match[1]
      allowGreetings = state.toLowerCase() == 'on'
      msg.send "Greetings are now #{state}."

  greetingsStatus = (msg) ->
    msg.send "Greetings are currently #{allowGreetings && 'on' || 'off'}."

  showThrottle = (msg) ->
    return unless whiteList.isTeacher msg.robot, msg.message.user
    msg.send "Throttle time is set to #{THROTTLETIME} seconds."

  adjustThrottle = (msg) ->
    return unless whiteList.isTeacher msg.robot, msg.message.user
    seconds = msg.match[1]
    THROTTLETIME = seconds
    msg.send "Throttle time adjusted to #{seconds} seconds."

  userEnters = (msg) ->
    return if !allowGreetings or throttle 'userenters'
    name = userName msg

    if name.indexOf('laravelnewbie') > -1
      message = "Good morning #{name}, welcome to #{roomName(msg)}. Please type in \"/nick your_new_nick\" to change your name so we can distinguish you easily."
    else
      message = doUserGreet userRepo, greetings, name

    msg.send message if message


  robot.respond /clear last greet/i, clearLastGreet

  robot.respond /(?:greeting(?:s)?)$/i, respondGreetings

  robot.respond /greet ((?!me)[^@!\ ]*)(?: in (.+))?/i, greetUserInLanguage

  robot.respond /greet me/i, greetMe

  robot.respond /i speak (.+)/i, iSpeak

  robot.respond /forget me/i, forgetMe

  robot.respond /forget my greeting/i, forgetMyGreeting

  robot.respond /what is my greeting(\?)?/i, whatIsMyGreeting

  robot.respond /what is my language(\?)?/i, whatIsMyLanguage

  robot.respond /show greeting for (.+)/i, showGreetingFor

  robot.respond /show user greeting for (.+)/i, showGreetingForUser

  robot.respond /set greeting for ([^@!\ ]*) to (.+)/i, setUserGreetingTo

  robot.respond /unset greeting for (.+)/i, unsetUserGreeting

  robot.respond /greetings (on|off)$/i, greetingsOnOff

  robot.respond /greetings status$/i, greetingsStatus

  robot.respond /show throttle time/i, showThrottle

  robot.respond /set throttle to ([0-9.]+)$/i, adjustThrottle

  robot.enter userEnters
