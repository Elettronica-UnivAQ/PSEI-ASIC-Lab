# antenna.tcl
# Adattato da: https://github.com/mattvenn/ttsky25b-analog-relax-oscillator
# Licenza originale: Apache-2.0 (Copyright © Tiny Tapeout LTD)
# Verifica le antenna rule violations con Magic VLSI.
#
# Le "antenna rules" limitano la lunghezza massima di filo metallico connessa
# a un gate MOSFET durante il processo di fabbricazione. Durante l'etching
# del metallo, un filo lungo accumula carica che può danneggiare il gate oxide
# se non è protetto da un diodo di antenna. Il rapporto tra l'area del filo
# e l'area del gate (PAR — Poly Antenna Ratio) deve rimanere sotto un limite
# definito dal PDK.
#
# Uso tramite Makefile:
#   make antenna
#
# Uso diretto:
#   magic -dnull -noconsole -rcfile $PDK_ROOT/$PDK/libs.tech/magic/sky130A.magicrc \
#         tcl/antenna.tcl NOME_CELLA
#
# Output: stampa a console le violazioni trovate

set cell_name [lindex $argv $argc-1]

load $cell_name.mag
select top cell

# Estrae le geometrie necessarie per il calcolo delle antenne
extract all

# "debug": stampa i dettagli di ogni net analizzata (utile per debugging)
# Rimuovere "debug" per output più sintetico in produzione
antennacheck debug
antennacheck

quit -noprompt
