#!/bin/bash
# Uninstall Routine

CRONCMD="$BINDIR/logtemp 2> $APPDIR/cron_errors > /dev/null"

echo "Entferne cronjob: $CRONCMD"

( crontab -l | grep -v "$CRONCMD" ) | crontab -
