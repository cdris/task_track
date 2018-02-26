#!/bin/bash

export PORT=5101
export MIX_ENV=prod
export GIT_PATH=/home/task_track/src/task_track

PWD=`pwd`
if [ $PWD != $GIT_PATH ]; then
	echo "Error: Must check out git repo to $GIT_PATH"
	echo "  Current directory is $PWD"
	exit 1
fi

if [ $USER != "task_track" ]; then
	echo "Error: must run as user 'task_track'"
	echo "  Current user is $USER"
	exit 2
fi

mix deps.get
(cd assets && npm install)
(cd assets && ./node_modules/brunch/bin/brunch b -p)

mix ecto.create
mix ecto.migrate

mix phx.digest
mix release --env=prod

mkdir -p ~/www
mkdir -p ~/old

NOW=`date +%s`
if [ -d ~/www/task_track ]; then
	echo mv ~/www/task_track ~/old/$NOW
	mv ~/www/task_track ~/old/$NOW
fi

mkdir -p ~/www/task_track
REL_TAR=~/src/task_track/_build/prod/rel/task_track/releases/0.0.1/task_track.tar.gz
(cd ~/www/task_track && tar xzvf $REL_TAR)

crontab - <<CRONTAB
@reboot bash /home/task_track/src/task_track/start.sh
CRONTAB

#. start.sh
