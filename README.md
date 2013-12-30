PiTempSensor
============

Protokolliere die CPU-Temperatur des Raspberry Pi per cron job 

###Was ist das?

Mit einem kleinen Script sollen die Temperaturwerte der CPU auf dem Raspberry Pi überwacht werden. Das Script soll regelmäßig im Abstand von wenigen Minuten die Temperatur auslesen und aufzeichen. Um das Datenhandling zu vereinfachen, werden die Daten in eine SQlite-Datenbank geschrieben. Dadurch können Auswertungen oder eine Auswahl der Daten per SQL-Befehle durchgeführt werden. Außerdem ist es einfacher, die Datensammlung auf einen bestimmten Zeitraum zu begrenzen.    

<p align="center">
   <img alt="Übersicht" src="https://dl.dropboxusercontent.com/u/40629133/Status.png"/>
</p>

Das Script liest die Temperatur-Werte des Raspberry Pi mit Hilfe von `vcgencmd` aus schreibt sie in eine kleine Datenbank. Die Daten können später als CSV-Datei exportiert werden, um sie z. B. in einer Tabellenkalkulation ein Diagramm draus zu bauen. Mit der Sqlite-Erweiterung `libsqlite3-mod-impexp` können die Daten auch im JSON-Format ausgegeben werden. In diesem Format können Diagramme mit [**jgPlot**](http://www.jqplot.com/index.php) in Webseiten erstellt werden.

Damit die Scripte laufen, müssen die Pakete `sqlite3` und `libsqlite3-mod-impexp` installiert sein:

    sudo apt-get install sqlite3 libsqlite3-mod-impexp

In diesem Repository sind die Scripte enthalten, mit denen die Daten ausgelesen, in die sqlite-Datenbank geschrieben und zur Weiterverarbeitung in verschiedene Formate exportiert werden können. 

###Die Skripte

Hier sind zwei Scripte enthalten:

Scriptname                 |  Erläuterung
---------------------------|------------------------------------------------------------------
write_stats_to_db.sh       |  Liest die CPU-Temperatur aus und schreibt sie in eine SQLite-DB
generate_cpu_temp_csv.sh   |  Exportiert die Daten aus der SQLite-DB in eine CSV-Datei
crontab                    |  Enthält beispielhaft einen Eintrag für die Abfrage alle 5 Minuten


Die Datei `crontab` zeigt in Zeile 11 wie das Skript `write_stats_to_db.sh` direkt als cron-job alle 5 Minuten ausgeführt wird:

    */5 *   * * *   root    /var/run/write_stats_to_db.sh







