#!/usr/bin/env bash

echo "container start initiated"
echo "resetting /var/run/nut/shutdownflag"
echo "0" > /var/run/nut/shutdownflag

stop() {
  echo "container stop initiated"
  echo "stopping upsmon"
  /usr/sbin/upsmon -c stop
  echo "stopping upsd"
  /usr/sbin/upsd -u root -c stop
  echo "stopping upsdrvctl"
  /usr/sbin/upsdrvctl -u root stop
  echo "stop completed"
}
echo "registering signal trap"
trap 'stop' SIGTERM
trap 'stop' SIGINT

UPSD_UPDATE_RANDOM_PASSWORD=${UPSD_UPDATE_RANDOM_PASSWORD:-true}
if [ "$UPSD_UPDATE_RANDOM_PASSWORD" == "true" ] ; then 
	UPSD_RANDOM_PASSWORD=$(dd if=/dev/urandom bs=1K count=4 2>/dev/null | sha256sum | cut -d ' ' -f1)
	sed -i "s/__UPS_MON_PASSWORD__/$UPSD_RANDOM_PASSWORD/" /etc/nut/upsd.users
	sed -i "s/__UPS_MON_PASSWORD__/$UPSD_RANDOM_PASSWORD/" /etc/nut/upsmon.conf
fi

echo "starting upsdrvctl"
/usr/sbin/upsdrvctl -u root start
echo "starting upsd"
/usr/sbin/upsd -u root &
echo "starting upsmon"
/usr/sbin/upsmon -D
