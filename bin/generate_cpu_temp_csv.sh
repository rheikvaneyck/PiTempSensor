#!/bin/bash
# Tabelle als csv ausgeben und
# Zeitstempel in lokale Zeit konvertieren

while getopts d:o:h opt
do
  case $opt in 
    d) DB="${OPTARG}";;
    o) CSV="${OPTARG}";;
    h) echo "usage: $0 [-d database_file] [-c csv_file]"
	   exit 0;;
    ?) echo "usage: $0 [-d database_file] [-c csv_file]"
     exit 1;;
  esac
done

# CSV-Datei 
if [ -z "$CSV" ]; then
  FDIR=`dirname $0`
  LOGDIR="$FDIR/log"
  [ ! -d "$LOGDIR" ] && mkdir "$LOGDIR"  
  CSV="$LOGDIR/status.csv"
else
  LOGDIR=`dirname "$CSV"`
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

# Die Tabelle stats enthält die Spalten: id, ts, temp
sqlite3 -separator ',' -csv  -header $DB "SELECT id AS "ID",datetime(ts, 'unixepoch', 'localtime') AS "Zeit", temp AS "Temperatur" FROM stats;" > $CSV
