#!/bin/sh

git fetch
git reset --hard origin/`git rev-parse --abbrev-ref HEAD`
./bin/daemon.sh restart
