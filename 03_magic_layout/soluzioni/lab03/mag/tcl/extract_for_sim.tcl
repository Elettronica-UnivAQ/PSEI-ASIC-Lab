# extract_for_sim.tcl
# Adattato da: https://github.com/mattvenn/ttsky25b-analog-relax-oscillator
# Licenza originale: Apache-2.0 (Copyright © Tiny Tapeout LTD)
# Estrazione netlist SPICE con parassitici R+C per simulazione post-layout con Magic VLSI.
# Usa extresist per resistenze DISTRIBUITE (non lumped) — corretto per simulazione
# analogica SPICE. Le resistenze distribuite modellano i fili lunghi come reti di
# resistori fisici, a differenza della semplice soglia "rthresh" che produce un
# singolo R per nodo (approssimazione valida solo per simulazione digitale).
#
# Uso (dalla cartella mag/):
#   magic -dnull -noconsole -rcfile $PDK_ROOT/$PDK/libs.tech/magic/sky130A.magicrc \
#         tcl/extract_for_sim.tcl NOME_CELLA
#
# Oppure tramite Makefile:
#   make pex
#
# Output: NOME_CELLA.sim.spice (netlist con parassitici, subckt rinominato NOME_CELLA_parax)

set cell_name [lindex $argv $argc-1]

# Carica la cella e la appiattisce (flatten).
# extresist richiede una gerarchia piatta — non può calcolare R distribuite
# attraverso i confini gerarchici. Il flatten "esplode" tutta la gerarchia
# in un unico livello di geometrie primitive.
load $cell_name.mag
flatten ${cell_name}_flat
load ${cell_name}_flat
select top cell

# Rimuove la cella originale dalla sessione per evitare conflitti di nome
cellname delete $cell_name

# Rinomina la cella flat con suffisso _parax — convenzione che segnala
# la presenza di parassitici nella netlist risultante.
# In xschem, l'istanza della netlist post-layout userà questo nome come
# riferimento schematico, distinguendola dall'istanza pre-layout.
cellname rename ${cell_name}_flat ${cell_name}_parax

# Estrae tutta la geometria in file .ext
extract all

# Passo 1 — genera la netlist .sim (formato irsim con resistenze lumped).
# Questa netlist intermedia è necessaria per extresist come punto di partenza.
# "labels on" include le label di net nel file .sim.
ext2sim labels on
ext2sim

# Passo 2 — estrazione R distribuita con extresist.
# extresist legge i file .sim e .ext e calcola le resistenze distribuite
# per ogni net, sostituendo i fili con reti di resistori fisici.
# - "tolerance 10": inserisce una R esplicita quando il suo contributo al ritardo
#   supera il 10% del ritardo totale del nodo (soglia di compromesso tra
#   accuratezza e dimensioni della netlist)
extresist tolerance 10
extresist

# Passo 3 — genera la netlist SPICE finale con i parassitici.
# - "lvs"          : formato .subckt
# - "cthresh 0"    : include TUTTE le capacità parassite (nessuna soglia)
# - "extresist on" : incorpora le R distribuite calcolate da extresist
ext2spice lvs
ext2spice cthresh 0
ext2spice extresist on
ext2spice -o $cell_name.sim.spice

puts "Estrazione PEX completata: $cell_name.sim.spice"
quit -noprompt
