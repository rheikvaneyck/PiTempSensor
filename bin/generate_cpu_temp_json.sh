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
# Die Datei liegt standardmäßig im Benutzerverzeichnis im Ordner 'PiTempSensor/log'
# Der Dateiname ist status.json
if [ -z "$JSON" ]; then
  JSONDIR="$HOME/PiTempSensor/log"
  [ ! -d "$JSONDIR" ] && mkdir -p "$JSONDIR"  
  JSON="$JSONDIR/status.json"
else
  JSONDIR=`dirname "$JSON"`
fi

if [ ! -d "$JSONDIR" ]; then 
  echo "Kann Verzeichnis $JSONDIR nicht finden"
  exit 1
fi

# DB-Datei 
# Die Datei liegt standardmäßig im Benutzerverzeichnis im Ordner 'PiTempSensor/log'
# Der Dateiname ist status.sqlite
if [ -z "$DB" ]; then
  DBDIR="$HOME/PiTempSensor/log"
  DB="$DBDIR/status.sqlite"
fi
echo "Lese Daten von $DB" 
  
if [ ! -f "$DB" ]; then
    echo "Kann die Datenbank $DB nicht finden"
    exit
fi

echo "[[" > $JSON
# Die Tabelle stats enthält die Spalten: id, ts, temp
# Für die Ausgabe wird die Zeit in Millisekunden umgerechnet, damit sie von 
# javascript-Funktionen direkt geparst werden kann.
sqlite3 -separator ',' $DB "SELECT (ts * 1000),temp FROM stats;" | sed 's/^/[/' | sed 's/$/],/' >> $JSON
printf 's/,$//\nw\nq\n' | ed -s $JSON
echo "]]" >> $JSON
