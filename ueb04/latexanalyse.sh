#!/bin/sh

# Ein Skript, dass Latex-Dateien analysiert. Es werden alle 
# Graphik-, Structure- und Package-Befehle rausgefiltert 
# und nach Vorgaben ausgegeben
# cgt103579, cgt103557

#
# Gibt den Hilfetext formatiert aus
#
callHelp(){
echo 'Usage:
latexanalyse.sh -h | latexanalyse.sh --help

  prints this help and exits

latexanalyse.sh INPUT OPTION

  INPUT is a valid latex-File (.tex)

  and OPTION is one of

  -g, --graphics      prints a list of all included graphics

  -s, --structure     prints the structure of the input file

  -u, --usedpackages  prints a list of the used packages and their options'
}

#
# Löscht alle Kommentare aus einer übergebenen Datei
# @param $1 Datei dessen Kommentare entfernt werden sollen
# @out Die Datei ohne Kommentare
#
deleteComments(){
# Alles nach einem %-Zeichen inkl. des %-Zeichens werden duch einen
# leeren String ersetzt
sed 's/%.*//g'
}

# Prüft, ob Datei exisitiert oder lesbar ist und die richtige Anzahl 
# an Parametern angegeben wurde
if [ -r "$1" ] && [ $# -eq 2 ]; then
    case "$2" in           
        -g | --graphics)sed 's;\\includegraphics;\n\\includegraphics;g' "$1" |
                        deleteComments |
                        # Filtert alle Graphikzeilen raus und löscht
                        # alles hinter der } (inkl.)
                        grep '\\includegraphics' | sed 's;}.*;;g' |
                        # Löscht alles vor der { (inkl.) 
                        sed -e 's;.*{;;g';;

        -s | --structure)sed -e 's;\\chapter;\n\\chapter;g' \
                        -e 's;\\section;\n\\section;g' \
                        -e 's;\\subsection;\n\\subsection;g' "$1" |
                         deleteComments |
                         # Filtert alle Structurezeilen raus, die mit 
                         # chapter, section oder subsection betitelt sind
                         grep -E '\\chapter|\\section|\\subsection' |
                         # Ersetzt alles bis zur { durch die Vorgabe
                         # nicht immer ist "*" vorhanden
                         #
                         # Entfernt alles nach der } (inkl.)
                         sed -e 's;\\chapter[\*]\{0,1\}{; ;g' \
                         -e 's;\\section[\*]\{0,1\}{; |-- ;g' \
                         -e 's;\\subsection[\*]\{0,1\}{;     |-- ;g' \
                         -e 's;}.*;;g';;      
                                 
        -u | --usedpackages)sed -e 's;\\usepackage;\n\\usepackage;g' "$1" |
                            deleteComments |
                            # Schreibt das gesamte Dokument in eine Zeile
                            sed -z 's;\n;;g' | 
                            # Hebt die Packagebefehle hervor, indem vor
                            # diese ein Absatz eingeüfgt wird
                            #
                            # Hinter die geschlossene Klammer des Namen
                            # wird ebenfalls ein Abatz eingefügt
                            sed -e 's;\\usepackage;\n\\usepackage;g'\
                            -e 's;};}\n;g' | 
                            # Filtert alle Packagebefehle raus
                            grep "\\\usepackage" | 
                            # Entfernt alle Leerzeichen
                            #
                            # Entfernt alles vor der { oder [ (inkl.)
                            #
                            # Ersetzt die ] durch ein Leerzeihen, um
                            # später den Namen von den Optionen 
                            # unterscheiden zu können
                            #
                            # Ersetzt alles nach der } (inkl.) durch ein :
                            # um später, nach dem umsortieren den Namen
                            # von den Optionen unterscheiden zu können
                            #
                            # Tauscht den String, der alle Optionen 
                            # enthält mit dem String, der den Namen enthält
                            #
                            # Entfernt alle Leerzeichen
                            #
                            # Sortiert alle Einträge nach ihrem Namen
                            sed -e 's; ;;g' \
                            -e 's;\\usepackage[\[|{];;g' \
                            -e 's;[]]{; ;g' \
                            -e 's/}.*/:/g' \
                            -e 's;\([^ ]*\) *\([^ ]*\);\2\1;' \
                            -e 's; ;;g' |
                            sort -t":" -k1,1;;

        *)echo 'Error: Falscher Aufruf des Skripts.' 1>&2
          callHelp 1>&2
          exit 5;;
    esac

    elif [ "$1" = "-h" ] || [ "$1" = "--help" ];then
        if [ $# -eq 1 ]; then 
            callHelp                
            exit 0
        else 
            # Umleitung nach StdErr, automatische Ausgabe nach 
            # StdOut wird ins nichts geleitet
            echo 'Error: Zu viele Parameter angegeben.' 1>&2 
            callHelp 1>&2
            exit 1
        fi
        else
            echo 'Error: Datei existiert nicht, ist nicht lesbar oder wurde falsch aufgerufen.' 1>&2
            callHelp 1>&2
            exit 4 
fi
exit 0
