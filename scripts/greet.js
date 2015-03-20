var fs = require('fs');

var storePath = '';
var storeInit = false;
var langs = {};
var users = {};

function readStore(data)
{
	data = JSON.parse(data);
	langs = data.langs;
	users = data.users;
	storeInit = true;
}

function updateStore()
{
	if (!storeInit || !storePath) return;
	data = {langs: langs, users: users};
	fs.writeFile(storePath, JSON.stringify(data), function(err) {
		if (err) {
			console.log("Error writing to " + storePath);
			throw err;
		} else {
			console.log("Wrote greeting data to " + storePath);
		}
	});
}

function setGreeting(language, greeting)
{
	if (!storeInit) return;
	langs[language] = greeting;
	updateStore();
}

function getGreeting(language)
{
	if (!storeInit) return;
	return langs[language];
}

function setReply(username, language)
{
	if (!storeInit) return;
	users[username] = language;
	updateStore();
}

function getReply(username)
{
	if (!storeInit) return;
	var language = users[username];
	if (language) return getGreeting(language);
}

module.exports = function(robot) {
	// @todo Get the path to the JSON file
	storePath = '..';
	var data = fs.readFile(storePath, function(err, data) {
		if (err) {
			console.log("Error reading greeting storage file: " + storePath);
			throw err;
		} else {
			readStore(data);
		}
	});

	robot.enter(function(msg) {
		var reply = getReply(msg.message.user.name);
		if (reply) {
			msg.send(reply);
		}
	})
};