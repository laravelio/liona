# Description:
#   A way to interact with the Google Images API.
#
# Commands:
#   hubot image me (-) <query> - The Original. Queries Google Images for <query> and returns a random top result.
#   hubot animate me (-) <query> - The same thing as `image me`, except adds a few parameters to try to return an animated GIF instead.

module.exports = (robot) ->
  robot.respond /(image|img)( me)?( -)? (.*)/i, (msg) ->
    imageMe msg, msg.match[4], msg.match[3]?, null, (url) ->
      msg.send url

  robot.respond /animate( me)?( -)? (.*)/i, (msg) ->
    imageMe msg, msg.match[3], msg.match[2]?, 'animated', (url) ->
      msg.send url

imageMe = (msg, query, norandom, type, cb) ->
  q = v: '1.0', rsz: '8', q: query
  q.imgtype = type if type?
  msg.http('http://ajax.googleapis.com/ajax/services/search/images')
    .query(q)
    .get() (err, res, body) ->
      images = JSON.parse(body)
      images = images.responseData?.results
      if images?.length > 0
        image = if norandom then images[0] else msg.random images
        cb "#{image.unescapedUrl}#.png"

