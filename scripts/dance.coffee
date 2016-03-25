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
        moves[Math.floor(Math.random() * moves.length)];

    msg.send maneuver.join(' ')
