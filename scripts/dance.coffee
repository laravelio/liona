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

    last = n = 0

    maneuver = while num -= 1
        while n is last
            n = msg.random moves
        last = n

    msg.send maneuver.join(' ')
