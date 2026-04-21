# update_gds_lef.tcl
# Adattato da: https://github.com/mattvenn/ttsky25b-analog-relax-oscillator
# Licenza originale: Apache-2.0 (Copyright © Tiny Tapeout LTD)
# Esporta il layout in formato GDS-II e LEF per la submission al tapeout.
#
# - GDS-II (.gds): formato di interscambio standard per il layout fisico.
#   Contiene tutte le geometrie di tutti i layer. Viene inviato alla foundry.
# - LEF (Library Exchange Format): descrive il bounding box della cella e le
#   posizioni dei pin — usato dai tool di place & route per integrare il blocco
#   analogico in un design digitale top-level.
#   - "-pinonly": include solo le geometrie dei pin (non le geometrie interne)
#   - "-hide": nasconde le geometrie interne della cella (blackbox per il P&R)
#
# Uso tramite Makefile:
#   make update_gds
#
# Uso diretto:
#   magic -dnull -noconsole -rcfile $PDK_ROOT/$PDK/libs.tech/magic/sky130A.magicrc \
#         tcl/update_gds_lef.tcl NOME_CELLA
#
# Output: ../gds/NOME_CELLA.gds e ../lef/NOME_CELLA.lef

set cell_name [lindex $argv $argc-1]

load $cell_name

# Esporta il GDS nella cartella gds/ (al livello del repository, non dentro mag/)
gds write ../gds/$cell_name.gds

# Esporta il LEF con solo i pin visibili (blackbox per i tool digitali)
lef write ../lef/$cell_name.lef -pinonly -hide

quit -noprompt
