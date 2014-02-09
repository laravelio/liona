# Description:
# 	Search packagist.
# 
# Commands:
# 	hubot packagist me <query> - searched packagist for the query and returns the top result.
module.exports = (robot) ->
	robot.respond /(pkg|packagist)( me)? (.*)/i, (msg) ->
		query = msg.match[3]
		robot.http('https://packagist.org/search.json')
			.query({q: query})
			.get() (err, res, body) ->
				results = JSON.parse(body).results

				unless results?
					msg.send "No results for \"#{query}\""
					return

				result = results[0]
				resultstring = result.name + ' - ' + result.url + ' (' + result.downloads + ' downloads)'

				msg.send resultstring