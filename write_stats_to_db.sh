#!/bin/bash
#

while getopts d: opt
do
  case $opt in 
    d) DB="${OPTARG}";;
    ?) echo "usage: $0 [-d database_file]"
      exit 1;;
  esac
done


# sqlite Datei
[ -z "$DB" ] && DB=/var/log/status.sqlite

# Zeitstempel auslesen
ts=`date +%s`

# Temperatur auslesen und überflüssige Zeichen entfernen
value=`vcgencmd measure_temp | cut -d'=' -f 2 | sed "s/'C//g"`

# Tabelle erstellen
# ts = Spalte mit Zeitstempel in sek seit 1.1.1970, z.B. ""
# temp = Spalte mit Temperatur z.B. "51.4"
sqlite3 "$DB" 'CREATE TABLE IF NOT EXISTS stats(id INTEGER PRIMARY KEY ASC AUTOINCREMENT, ts TIMESTAMP NOT NULL, temp STRING NOT NULL);'

# Trigger erstellen, der die Tabelle auf 3.153.600 Zeilen begrenzt, indem die
# ältesten nach dem Einfügen neuer Zeilen abgeschnitten werden
sqlite3 "$DB" 'CREATE TRIGGER IF NOT EXISTS hundret_rows_only AFTER INSERT ON stats   
  BEGIN
    DELETE FROM stats WHERE id IN (SELECT id FROM stats ORDER BY ts DESC LIMIT 3153600, -1);
  END;'

# Werte eintragen
sqlite3 "$DB" "INSERT INTO stats (ts,temp) VALUES($ts,$value);"
