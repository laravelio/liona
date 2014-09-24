# Description:
#   LioBot really likes the Verve Pipe
#
# Commands:
#   for the life of me - Display Freshmen chorus lyrics
#
# Notes:
#   FOOOOOR THE LIFE OF MEEEEE!

module.exports = (robot) ->
  robot.hear /for the life of me/i, (msg) ->

    msg.reply "Fooor the life of meeee....IIII cannot remember what made us think that we were wise and we'd never compromise!"
    msg.reply "For the life of me....I cannot believe we'd ever die for these sins; we were merely freshmen."
