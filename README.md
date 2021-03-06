PiTempSensor
============

Protokolliere die CPU-Temperatur des Raspberry Pi per cron job 

###Überblick

Mit einem kleinen Script sollen die Temperaturwerte der CPU auf dem Raspberry Pi überwacht werden. Das Script soll regelmäßig im Abstand von wenigen Minuten die Temperatur auslesen und aufzeichen. Um das Datenhandling zu vereinfachen, werden die Daten in eine SQlite-Datenbank geschrieben. Dadurch können Auswertungen oder eine Auswahl der Daten per SQL-Befehle durchgeführt werden. Außerdem ist es einfacher, die Datensammlung auf einen bestimmten Zeitraum zu begrenzen.    

<p align="center">
   <img alt="Übersicht" src="https://dl.dropboxusercontent.com/u/40629133/PiTempSensor.png"/>
</p>

Das Script liest die Temperatur-Werte des Raspberry Pi mit Hilfe von `vcgencmd` aus schreibt sie in eine kleine Datenbank. Die Daten können später als CSV-Datei exportiert werden, um sie z. B. in einer Tabellenkalkulation ein Diagramm draus zu bauen. Mit dem Script `generate_cpu_temp_json.sh` können die Daten auch im JSON-Format ausgegeben werden. In diesem Format können Diagramme mit [**jgPlot**](http://www.jqplot.com/index.php) in html-Seiten eingebettet  werden:

<p align="center">
   <img alt="Temperatur Plot" src="https://dl.dropboxusercontent.com/u/40629133/LogTemp.png"/>
</p>

Damit die Scripte laufen, muss das Paket `sqlite3` installiert sein:

    sudo apt-get install sqlite3

In diesem Repository sind die Scripte enthalten, mit denen die Daten ausgelesen, in die sqlite-Datenbank geschrieben und zur Weiterverarbeitung in verschiedene Formate exportiert werden können. 

###Die Skripte

Im Verzeichnis `bin/` sind vier Scripte enthalten:

Scriptname                 |  Erläuterung
---------------------------|------------------------------------------------------------------
write_stats_to_db.sh       |  Liest die CPU-Temperatur aus und schreibt sie in eine SQLite-DB
generate_cpu_temp_csv.sh   |  Exportiert die Daten aus der SQLite-DB in eine CSV-Datei
generate_cpu_temp_json.sh  |  Exportiert die Daten aus der SQLite-DB in eine JSON-Datei
logTemp                    |  fasst die scripte zum Speichern und Exportieren für den cron-job zusammen.


Die Datei `crontab` enthält den Eintrag für einen cron-job, um das Skript `logtemp` alle 5 Minuten auszuführen:

    */5 * * * *   ~/PiTempSensor/bin/logtemp

Dieser Eintrag wird mit `crontab -u pi -e` in die crontab-Datei des Benutzers pi eingetragen. Der Pfad zum Script muss natürlich so angepasst werden, dass er zum Script zeigt. 

Ein einfacher Web-Server zum Abrufen der Daten mit einem Browser ist mit einem python-Aufruf möglich:

    nohup python -m SimpleHTTPServer > /dev/null 2>&1 &

Der Web-Server ist dann über den hostnamen auf Port 8000 erreichbar, wenn Ihr eine Fritz!Box habt - z.B. [http://pi:8000/](http://pi:8000/) - oder über die IP-Adresse des Raspberry Pi, z.B. http://192.168.0.100:8000/

Das Zusammenspiel der Scripte ist in der Abbildung oben dargestellt. 




