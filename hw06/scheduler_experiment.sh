#!/bin/bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
	echo "Запусти через sudo"
	exit 1
fi

sudo nice -n -10  dd if=/dev/urandom of=/dev/null bs=1M count=200 2>/dev/null &
PID_HIGH=$!
sudo nice -n 19 dd if=/dev/urandom of=/dev/null bs=1M count=200 2>/dev/null &
PID_LOW=$!
wait
