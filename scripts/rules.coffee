# Description:
#   Fetch all rules or a single room for a user
#
# Commands:
#   hubot rules - Reply with a link to the rules
#   hubot rules <key> - to reply with a specific rule
#   hubot rules <key> to <nick> - to send a rule to a user - 'all' for link

RULES_URL = "http://goo.gl/Tl77U2"
RULES =
  research:  "Do your research before hand. Your question may be answerable with a quick Google search or by simply experimenting. If it's a concept you're confused about, first check out our docs. If you're using a method in Laravel, you can look it up in the API docs."
  explain:   "If you've tried Googling, explain what terms you've tried to use so people can better help you. Saying that something \"doesn't work\" is completely useless to the people who are trying to help you. Please show all available information you have that indicates to you that something doesn't work."
  paste:     "Anything more than 2 lines goes in a paste. Spamming the channel with walls of text is not welcome. Clearly explain what is happening on http://help.laravel.io to better explain yourself, or just a simple paste or gist if you are just creating a simple example."
  nopb:      "Do not use any paste service that is not http://laravel.io/bin or http://gist.github.com to post code. Pastebin, for example has a tiny font and it has ads on it which cause the page to load slowly. Other paste services generally look like crap."
  english:   "Remember that using English is preferable, as the majority of people in the channel speak it. Asking in other languages may give you a response, but English is best."
  polite:    "Treat people in a considerate manner, as they are volunteering *their* time to help *you*. If you're being annoying you may be muted by one of the channel ops."
  eccentric: "Do not use excessive punctuation. This includes question marks (?), exclamation marks (!) and ellipsis (...)."
  begging:   "Do not beg / plead with people to help you. This includes asking questions like \"Any ideas?\" after posting your original question."
  repeating: "Do not repeat your question every few minutes expecting somebody to answer it. If you do not get a reply after the first few tries at least 5-10 minutes apart, perhaps posting your question on StackOverflow would help you. Linking to the question in the channel after you've posted it is OK."
  pm:        "Do not PM members of the channel without first asking if that is OK."
  ops:       "Do not PM room operators with Laravel related questions.  It is OK to PM an op if you have Laravel.io account issues, or are being trolled or harassed by other room members."
  all:       "Please review our room rules: #{RULES_URL}"

specificRule = (rule) ->
  return RULES[rule] if ruleExists(rule)
  "I'm sorry, I couldn't find a rule for #{rule}"

ruleExists = (rule) ->
  RULES[rule]?

module.exports = (robot) ->
  robot.respond /rule(?:s)?\s?(\w+)?(?: to ([^\s!]+)+)?/i, (msg) ->
    rule = msg.match[1] || 'all'
    user = msg.match[2]

    return msg.reply "I'm sorry, I couldn't find a rule for #{rule}" if rule and !ruleExists(rule)

    response = ""
    response += "#{user}: " if user
    response += specificRule(rule)

    msg.send response
