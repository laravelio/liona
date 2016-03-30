# Description:
#   Dance girl, dance
#
# Commands:
#   hubot dance

moves = ['(>*-*)>', '^(*-*)^', '<(*-*<)', '~(*-*)~']
limit = 5

module.exports = (robot) ->
  robot.respond /dance/i, (msg) ->
    num = limit+1
    maneuver = while num -= 1
        msg.random moves

    msg.send maneuver.join(' ')
