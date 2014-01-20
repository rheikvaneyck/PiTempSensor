#!/bin/bash
# Install the scripts with default configuration 

APPDIR="~/PiTempSensor"
BINDIR="$APPDIR/bin"
LOGDIR="$APPDIR/log"

[ ! -d "$BINDIR" ] && mkdir -p "$BINDIR"
[ ! -d "$LOGDIR" ] && mkdir -p "$LOGDIR"

if [ -d "$BINDIR" ];
then
  CURRDIR=`dirname $0`
  cp -r "$CURRDIR/bin" "$BINDIR"
else
  echo "Verzeichnis $BINDIR konnte nicht erstellt und Skripte nicht installiert werden"
  exit 1
fi


CRONCMD="$BINDIR/logtemp 2>  $APPDIR/cron_errors > /dev/null"
CRONJOB="*/5 *   * * *  $CRONCMD"

echo "Richte cronjob ein:"
echo "$CRONJOB"

( crontab -l | grep -v "$CRONCMD" ; echo "$CRONJOB" ) | crontab -
