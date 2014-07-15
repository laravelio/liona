#!/bin/bash

# Set up the environment
export HUBOT_IRC_ROOMS="#october"
export HUBOT_IRC_SERVER="irc.freenode.net"

# Fire up nodejs
#. /opt/nvm/nvm.sh
#nvm use v0.6.15

# Start hubot in the background
cd /opt/octobot/
bin/hubot -a irc -n Octobot\`
