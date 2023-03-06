#!/usr/bin/env bash

SHUTDOWNFLAG=/var/run/nut/shutdownflag

function run_shutdown() {
	run-parts --exit-on-error /bin/shutdown.d
}

echo "waiting for filesystem write notifications on $SHUTDOWNFLAG"
while inotifywait -e close_write $SHUTDOWNFLAG; do
  echo "notified for $SHUTDOWNFLAG"
  signal=$(cat $SHUTDOWNFLAG)
  if [ "$signal" == "1" ]; then 
	echo "shutdown signal received. executing shutdown actions..."
    run_shutdown
	echo "shutdown actions completed. resetting signal"
    echo "0" >$SHUTDOWNFLAG
  fi
done
echo "notified with $? for $SHUTDOWNFLAG. Error, thus terminating"
