#!/bin/bash
# Install the scripts with default configuration 

APPDIR="$HOME/PiTempSensor"
BINDIR="$APPDIR/bin"
LOGDIR="$APPDIR/log"

if [ ! -d "$BINDIR" ];
then
  echo "Erstelle $BINDIR"
  mkdir -p "$BINDIR"
fi

if [ ! -d "$LOGDIR" ];
then
  echo "Erstelle $LOGDIR"
  mkdir -p "$LOGDIR"
fi

if [ ! -d "$BINDIR" ];
then
  echo "Verzeichnis $BINDIR konnte nicht erstellt und Skripte nicht installiert werden"
  exit 1
fi

CURRDIR=`dirname $0`
echo "kopiere $CURRDIR/bin nach $APPDIR"
cp -r "$CURRDIR/bin" "$APPDIR"
echo "kopiere $CURRDIR/js nach $APPDIR"
cp -r "$CURRDIR/js" "$APPDIR"
echo "kopiere $CURRDIR/css nach $APPDIR"
cp -r "$CURRDIR/css" "$APPDIR"
echo "kopiere $CURRDIR/status_ajax.heml nach $APPDIR"
cp "$CURRDIR/status_ajax.html" "$APPDIR"

CRONCMD="$BINDIR/logtemp 2> $APPDIR/cron_errors > /dev/null"
CRONJOB="*/5 *   * * *  $CRONCMD"

echo "Richte cronjob ein:"
echo "$CRONJOB"

( crontab -l | grep -v "$CRONCMD" ; echo "$CRONJOB" ) | crontab -
