# Description:
#   LioBot gets you tip top information from the Laravel documentation
#
# Commands:
#   !docs <version?> <query> - Perform a google search against laravel docs for 
#       <query>, version can be either a numeric version number, 'api' to
#       search the api docs, or blank for the latest docs pages.
#
# Notes:
#   None

module.exports = (robot) ->
  robot.hear /!docs\s?([0-9.]+|api|dev)? (.*)/i, (msg) ->
    version = msg.match[1].trim()
    query = msg.match[2].trim()
 
    # quick and dirty urlify version string
    # (beware if we get into 2 digit minor vers)
    if (version != 'dev' or version != 'api')
      if version.length > 1
        version = version.replace(/[\.]/g, "-")
        version = version.substr(0, 3)
      else if version == '4'
        version = ''

    if version.match(/^3(.*)/i)
      query = "site:three.laravel.com/docs #{query}"    
    else if version == 'api'
      query = "site:laravel.com/api/4.1 #{query}"
    else if version?
      query = "site:laravel.com/docs/#{version} #{query}"
    else 
      query = "site:laravel.com/docs #{query}"

    robot.http('http://ajax.googleapis.com/ajax/services/search/web')
      .query({
          v: '1.0'
          q: query
      })
      .get() (err, res, body) ->
        results = JSON.parse(body).responseData.results
        if results[0]?
          msg.send results[0].url
        else 
          msg.send "No results for \"#{query}\""
