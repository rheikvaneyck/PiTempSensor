#!/bin/bash
# Install the scripts with default configuration 

APPDIR="~/PiTempSensor"
BINDIR="$APPDIR/bin"
LOGDIR="$APPDIR/log"

[ ! -d "$BINDIR" ] && mkdir -p "$BINDIR"
[ ! -d "$LOGDIR" ] && mkdir -p "$LOGDIR"

if [ ! -d "$BINDIR" ];
then
  echo "Verzeichnis $BINDIR konnte nicht erstellt und Skripte nicht installiert werden"
  exit 1
fi

CURRDIR=`dirname $0`
cp -r "$CURRDIR/bin" "$APPDIR"
cp -r "$CURRDIR/js" "$APPDIR"
cp -r "$CURRDIR/css" "$APPDIR"
cp "$CURRDIR/status_ajax.html" "$APPDIR"

CRONCMD="$BINDIR/logtemp 2> $APPDIR/cron_errors > /dev/null"
CRONJOB="*/5 *   * * *  $CRONCMD"

echo "Richte cronjob ein:"
echo "$CRONJOB"

( crontab -l | grep -v "$CRONCMD" ; echo "$CRONJOB" ) | crontab -
