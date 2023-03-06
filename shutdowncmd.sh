#!/bin/bash -e
# Default Shutdown Command Script
# Executed once "ups.state==BL" (battery low)
# By default, this will only set a flag (that could be read by the host system)
# You possibly choose to do more here...

echo 1 > /var/run/nut/shutdownflag
