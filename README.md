PiTempSensor
============

Protokolliere die CPU-Temperatur des Raspberry Pi per cron job 

##Was ist das?

Per script werden die Temperatur-Werte des Raspberry Pi ausgelesen und in eine kleine Datenbank geschrieben. Die Daten können dann als CSV-Datei exportiert werden, um sie z. B. in einer Tabellenkalkulation ein Diagramm draus zu bauen. Damit die Scripte laufen muss sqlite installierte sein (`sudo apt-get install sqlite3`). Die Temperaturwerte werden mit `vcgencmd` ausgelesen. Das muss natürluich auch laufen. 

##Die Skripte

Hier sind zwei Scripte enthalten:

* write_stats_to_db.sh
* generate_cpu_temp_csv.sh

Diese Scripte führen sqlite-Kommandos aus 
Die Datei `crontab` zeigt in Zeile 11 wie das Skript direkt in als cron-job alle 5 Minuten ausgeführt wird:

    */5 *   * * *   root    /var/run/write_stats_to_db.sh

##Skript 1: write_stats_to_db.sh

Das Script führt die Datenbank-Kommandos mit `sqlite3` aus. 





