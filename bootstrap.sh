#!/bin/bash
# bootstrap clam av service and clam av database updater
set -m

envsubst < /etc/clamav/clamd.conf.template > /etc/clamav/clamd.conf
envsubst < /etc/clamav/freshclam.conf.template > /etc/clamav/freshclam.conf

# start in background
echo "INFO: sudo will claim a password is needed, but it is not necessary here"
sudo -n -u clamav tini -s -g -- freshclam -d &
sudo -n -u clamav tini -s -g -- clamd
