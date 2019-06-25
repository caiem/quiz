#!/usr/bin/env bash
echo "Reloading..."
cmd=$(pidof quiz_reload_master)
echo "$cmd"
kill -USR1 "$cmd"
echo "Reloaded"