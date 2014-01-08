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
[ -z "$JSON" ] &&  JSON=/var/log/status.json
# DB-Datei 
[ -z "$DB" ] &&  DB=/var/log/status.sqlite

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
