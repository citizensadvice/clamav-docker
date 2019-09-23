#!/bin/bash
# bootstrap clam av service and clam av database updater
set -m

envsubst < /etc/clamav/clamd.conf.template > /etc/clamav/clamd.conf
envsubst < /etc/clamav/freshclam.conf.template > /etc/clamav/freshclam.conf

# start in background
tini -s -g -- freshclam -d &
tini -s -g -- clamd
