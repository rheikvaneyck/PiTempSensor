#!/bin/bash
# Tabelle als json ausgeben und
# Zeitstempel in lokale Zeit konvertieren

while getopts d:o:h opt
do
  case $opt in 
    d) DB="${OPTARG}";;
    o) JSON="${OPTARG}";;
    h) echo "usage: $0 [-d database_file] [-o json_file]"
      exit 0;;
    ?) echo "usage: $0 [-d database_file] [-o json_file]"
      exit 1;;
  esac
done

# JSON-Datei 
if [ -z "$JSON" ]; then
  FDIR=`dirname $0`
  LOGDIR="$FDIR/log"
  [ ! -d "$LOGDIR" ] && mkdir "$LOGDIR"  
  JSON="$LOGDIR/status.json"
else
  LOGDIR=`dirname "$JSON"`
fi

if [ ! -d "$LOGDIR"]; then 
  echo "Kann Verzeichnis $LOGDIR nicht finden"
  exit 1
fi
 
# DB-Datei 
if [ -z "$DB" ]; then
  LOGDIR=`dirname $0`
  DB="$LOGDIR/status.sqlite"
fi
echo "Lese Daten von $DB" 
  
if [ ! -f "$DB" ]; then
    echo "Kann die Datenbank $DB nicht finden"
    exit
fi

echo "[[" > $JSON
# Die Tabelle stats enthält die Spalten: id, ts, temp
sqlite3 -separator ',' $DB "SELECT (ts * 1000),temp FROM stats;" | sed 's/^/[/' | sed 's/$/],/' >> $JSON
printf 's/,$//\nw\nq\n' | ed -s $JSON
echo "]]" >> $JSON
