#!/bin/bash
# Uninstall Routine

APPDIR="$HOME/PiTempSensor"
BINDIR="$APPDIR/bin"

CRONCMD="$BINDIR/logtemp 2> $APPDIR/cron_errors > /dev/null"

echo "Entferne cronjob: $CRONCMD"

( crontab -l | grep -v "$CRONCMD" ) | crontab -
