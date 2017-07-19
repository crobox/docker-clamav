#!/bin/bash
# bootstrap clam av service and clam av database updater shell script
# presented by mko (Markus Kosmal<code@cnfg.io>)
set -m

# start clam service itself and the updater in background as daemon
freshclam -d &
clamd &

# recognize PIDs
pidlist=`jobs -p`

# initialize latest result var
latest_exit=0

# define shutdown helper
function trapshutdown() {
    trap "" SIGINT SIGTERM
    echo "Received SIGINT/SIGTERM stopping..."
    kill $pidlist 2>/dev/null
}

function trapchld() {
	trap "" CHLD
	echo "Received CHLD stopping..."
	kill $pidlist 2>/dev/null
}

# run shutdown
trap trapshutdown SIGINT SIGTERM
trap trapchld CHLD

wait

# return received result
exit $latest_exit
