# extract_for_lvs.tcl
# Adattato da: https://github.com/mattvenn/ttsky25b-analog-relax-oscillator
# Licenza originale: Apache-2.0 (Copyright © Tiny Tapeout LTD)
# Estrazione netlist SPICE per LVS (Layout vs Schematic) con Magic VLSI.
# Produce una netlist topologica senza parassitici — solo device e connessioni.
#
# Uso (dalla cartella mag/):
#   magic -dnull -noconsole -rcfile $PDK_ROOT/$PDK/libs.tech/magic/sky130A.magicrc \
#         tcl/extract_for_lvs.tcl NOME_CELLA
#
# Oppure tramite Makefile:
#   make lvs
#
# Output: NOME_CELLA.lvs.spice

# Legge il nome della cella dall'ultimo argomento da riga di comando
set cell_name [lindex $argv $argc-1]

# Resetta la box di selezione prima del caricamento
box 0 0 0 0

# Carica la cella top-level
load $cell_name.mag

# Scrive i file .ext nella cartella corrente (mag/) invece che accanto ai .mag.
# Necessario perché le pcell del PDK si trovano in cartelle di sola lettura.
extract do local

# Rende unici i nomi di net nella gerarchia escludendo i port del top-level.
# Evita collisioni di nomi tra celle figlie diverse che usano le stesse label interne
# (ad esempio due istanze di "inverter" hanno entrambe una net chiamata "mid").
extract unique notopports

# Estrae la cella e tutte le figlie in file .ext separati.
# "all" bypassa l'estrazione incrementale — garantisce .ext freschi da zero.
extract all

# Configura ext2spice per la modalità LVS:
# - "lvs"           : disabilita capacità parassite (non servono per il confronto topologico)
# - "cthresh inf"   : sopprime tutte le C residue (soglia infinita = nessuna capacità)
# - "short resistor": modella i cortocircuiti come resistori anziché come fili ideali
# - "-d"            : elimina dalla netlist i device non connessi (floating)
# - "-o"            : specifica il file di output direttamente (evita la rinomina successiva)
ext2spice lvs
ext2spice cthresh infinite
ext2spice short resistor
ext2spice -d -o $cell_name.lvs.spice

# Salva eventuali warning di estrazione per revisione
feedback save $cell_name.fb.txt

puts "Estrazione LVS completata: $cell_name.lvs.spice"
quit -noprompt
