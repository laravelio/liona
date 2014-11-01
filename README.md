# Octobot

## October's irc bot for #october on freenode.

This version is designed to be deployed on Ubuntu.

### Installation

Install needed packages

    sudo apt-get install git-core curl build-essential openssl libssl-dev

Install node.js

    git clone https://github.com/joyent/node.git && cd node
    ./configure
    make
    sudo make install

Install npm

    curl http://npmjs.org/install.sh | sudo sh

Install CoffeeScript

    sudo  npm install -g coffee-script

Install Octobot

    cd /opt
    git clone git://github.com/daftspunk/Octobot.git octobot && cd octobot
    npm install

Export vars

    export HUBOT_IRC_SERVER="irc.freenode.net"
    export HUBOT_IRC_ROOMS="#october"

Run

    ./bot

### Scripting

Take a look at the scripts in the `./scripts` folder for examples.
Delete any scripts you think are useless or boring.  Add whatever functionality you
want hubot to have. Read up on what you can do with hubot in the [Scripting Guide](https://github.com/github/hubot/blob/master/docs/scripting.md).

### Screening

Check if screen is up

```
screen -r
```

Open new screen

```
screen

```

Detach from screen
```
Ctrl+A, D
```
