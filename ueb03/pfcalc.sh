#!/bin/sh

# Das Skript soll Funktionen eines einfachen Taschenrechners vorweisen 
# und auf Befehl die Rechnung mit Ergebnis ausgeben. 
# Ebenso soll man sich eine Hilfsseite anzeigen lassen koennen. 
# cgt103557, cgt103579 (Christopher Ploog, Mario da Graca)


#
# Konvertiert Operatoren- die als Parameter uebergeben werden, zu ihrem 
# ANSI Aequivalent
# @param $1 (Verwendung nur in MOD/DIV) Teiler
# @param $2 zu uebersetzendes Zeichen
# @return Bei Division durch null oder bei falscher Angabe eines 
# Parameters wird ein return code > 0 zurueckgegeben
#
convert(){
local var=$2
case $var in
    ADD)echo -n "+";; 

    SUB)echo -n "-";;

    MUL)echo -n "*";;

    DIV)if [ $1 -ne 0  ]
        then echo -n "/"
        else return 1         
        fi;;

    MOD)if [ $1 -ne 0  ]
        then echo -n "%"
        else return 1         
        fi;;
        
    *)return 2;;
esac
}

#
# Gibt den Hilfetext formatiert aus
#
callHelp(){
echo 'Usage:
pfcalc.sh -h | pfcalc.sh --help

  prints this help and exits

pfcalc.sh [-i | --visualize] NUM1 NUM2 OP [NUM OP] ...

  provides a simple calculator using a postfix notation. A call consists of
  an optional parameter, which states whether a visualization is wanted,
  two numbers and an operation optionally followed by an arbitrary number
  of number-operation pairs.

  NUM1, NUM2 and NUM are treated as integer numbers.

  NUM is treated in the same way as NUM2 whereas NUM1 in this case is the
  result of the previous operation.

  OP is one of:

    ADD - adds NUM1 and NUM2

    SUB - subtracts NUM2 from NUM1

    MUL - multiplies NUM1 and NUM2

    DIV - divides NUM1 by NUM2 and returns the integer result

    MOD - divides NUM1 by NUM2 and returns the integer remainder

  When the visualization is active the program additionally prints the
  corresponding mathematical expression before printing the result.'
}

# Pruefung, wie Berechnung verarbeitet werden soll
case "$1" in
    # Ausgabe der Hilfe
    # Bei falschem Aufruf, wird Skript beendet 
    -h | --help)if [ $# -eq 1 ]
                then 
                    callHelp                
                    exit 0
                else 
                    # Umleitung nach StdErr, automatische Ausgabe nach 
                    # StdOut wird ins nichts geleitet
                    echo 'Error: Zu viele Parameter angegeben.' 1>&2 
                    callHelp 1>&2
                    exit 1
                fi;;

    # Visualisierung des Terms nach Vorschrift
    # mit -i oder --visualize wird nicht gearbeitet
    *)if [ "$1" = "-i" ] || [ "$1" = "--visualize" ]
      then
          visualize=1
          shift
      else
          visualize=0   
      fi
       
      # Bei falschem Aufruf, wird Skript mit exit code > 0
      # beendet
      if [ $(($# % 2)) -ne 1 ] || [ $# -eq 1 ]
      then 
          echo 'Error: Falsche Anzahl an Parametern.' 1>&2 
          callHelp 1>&2 
          exit 2

      else 
          Zahl=$1
          shift
                  
          # negative Zahlen werden extra umklammert
          if [ $Zahl -lt 0 ]
          then String="($Zahl)"
          else String="$Zahl"
          fi
          
          while [ $# -ne 0 ]
          do  
              # Konvertierung des Operanden            
              operation=$(convert $1 $2)
              correctOperator=$?
                        
              # Bei Division durch 0, wird Skrip beendet 
              if [ $correctOperator -eq 1 ]
              then
                  echo 'Error: Keine Division durch 0 moeglich.' 1>&2
                  callHelp 1>&2
                  exit 4
                            
                  # Bei unbekanntem Operanden, wird Skript beendet      
              elif [ $correctOperator -eq 2 ]
              then 
                  echo 'Error: Unbekannter Operator.' 1>&2
                  callHelp 1>&2
                  exit 5
              else        
                  # Berechnung
                  Zahl=$(($Zahl $operation $1)) 
                           
                  # negatives Ergebnis wird extra umklammert
                  # und in Rest des Terms eingefügt
                  if [ $1 -lt 0 ] 
                  then
                      String="($String$operation($1))"
                  else     
                      String="($String$operation$1)"
                  fi
                    
                  # Berechnung fertig, nächste Berechnung folgt         
                  shift 2
              fi
                          
          done
          # Ausgabe 1. Term, 2. Ergebnis
          # Bei korrekter Eingabe und Berechnung wird Skript
          # mit exit code = 0 beendet
          if [ $visualize -eq 1 ]
          then
              echo "$String"
          fi
          echo "$Zahl"
          exit 0
      fi;;

esac
