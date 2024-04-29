#!/bin/sh

# Ein kleines Skript, dass einen Unterordner 'info' erstellt, in welchem eine Textdatei 'mytextfiles.txt' erstellt wird, die 
# alle Dateinamen, mit der Endung '.txt', aus dem Ausführungsort des Skriptes enthält und sortiert.
# Es dient zum lernen der ersten Shell Befehle

mkdir --parents info  # --parents :  Erstellen des Ordners info, falls dieser schon vorhanden -> keine Fehlermeldung

#ls --indicator-style=slash --all | grep ".txt$" | sort -f > ./info/mytextfiles.txt (nur 93%, nachfragen wieso) 
find *.txt | sort --ignore-case > ./info/mytextfiles.txt  # Filtert Datein raus, die eine Dateiendung von "txt" haben, sortiert diese und ignoriert dabei Groß- und Kleinschreibung. Diese werden dann in eine Textdatei geschrieben.
                                                          # Ist diese schon vorhanden wird sie überschrieben, wenn nicht wird sie erstellt

