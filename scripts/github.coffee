# Description:
# 	Search github.
# 
# Commands:
# 	hubot github me <query> - searches the laravel/framework github repo and returns a link to the top result.
module.exports = (robot) ->
	robot.respond /(gh|github)( me)? (.*)/i, (msg) ->
		query = 'site:github.com/laravel/framework/tree ' + msg.match[3]
		robot.http('http://ajax.googleapis.com/ajax/services/search/web')
			.query({
				v: '1.0'
				q: query
			})
			.get() (err, res, body) ->
				results = JSON.parse(body).responseData.results

				unless results?
					msg.send "No results for \"#{query}\""
					return

				msg.send result[0].url