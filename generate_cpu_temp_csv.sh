#!/bin/bash
# Tabelle als csv ausgeben und
# Zeitstempel in lokale Zeit konvertieren

DBDIR=/var/log
DB=$DBDIR/status.sqlite

# CSV-Datei 
if [[ $# -lt 2 ]]; then
  CSVDIR=/var/log
  CSV=$CSVDIR/status.csv
else
  CSV=$2
fi

echo "Lese Daten von $CSV" 
  
if [ ! -f "$2" ]; then
    echo "Kann die Datenbank $2 nicht finden"
    exit
fi

# Die Tabelle stats enthält die Spalten: id, ts, temp
sqlite3 -separator ',' -csv  -header $DB "SELECT id AS "ID",datetime(ts, 'unixepoch', 'localtime') AS "Zeit", temp AS "Temperatur" FROM stats;" > $CSV
