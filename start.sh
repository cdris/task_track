#!/bin/bash

export PORT=5101

cd ~/www/task_track
./bin/task_track stop || true
./bin/task_track start

