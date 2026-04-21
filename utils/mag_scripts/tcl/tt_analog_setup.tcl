# tt_analog_setup.tcl
# Adattato da: https://github.com/mattvenn/ttsky25b-analog-relax-oscillator
# Autore originale: Uri Shaked per Tiny Tapeout LTD — Licenza: Apache-2.0
# Inizializza un nuovo progetto analogico per TinyTapeout a partire dal template
# del tile analogico standard (tt_analog_1x2.def).
#
# Lo script legge il file .def che definisce il bounding box del tile TinyTapeout
# (160 x 225.76 µm per il tile 1x2), rinomina la cella template con il nome del
# progetto e disegna le power stripe verticali in met4 (VDPWR e VGND).
# Le power stripe sono connessioni obbligatorie per l'alimentazione del tile
# nell'architettura di TinyTapeout.
#
# PREREQUISITO: scaricare prima il template .def
#   wget https://raw.githubusercontent.com/TinyTapeout/tt-support-tools/ttsky25a/def/analog/tt_analog_1x2.def
#
# Uso tramite Makefile:
#   make start
#
# Uso diretto:
#   magic -dnull -noconsole -rcfile $PDK_ROOT/$PDK/libs.tech/magic/sky130A.magicrc \
#         tcl/tt_analog_setup.tcl tt_analog_1x2.def NOME_PROGETTO
#
# Output: NOME_PROGETTO.mag con il tile TT pronto per il layout

# Legge gli argomenti: template file (penultimo) e nome cella (ultimo)
set TOP_LEVEL_CELL [lindex $argv $argc-1]
set TEMPLATE_FILE  [lindex $argv $argc-2]

# Larghezza minima delle power stripe: 1.2 µm (minimo PDK), qui 2 µm per margine DRC
set POWER_STRIPE_WIDTH 2um

# Definizione delle power stripe: coppia NET_NAME POSIZIONE_X
# VDPWR: alimentazione analogica positiva
# VGND:  ground
set POWER_STRIPES {
    VDPWR 1um
    VGND  4um
}

# Per il template 3.3V aggiungere una terza stripe per VAPWR
if {[string first "3v3" $TEMPLATE_FILE] > 0} {
    puts "Template 3.3V rilevato — aggiunta stripe VAPWR"
    lappend POWER_STRIPES VAPWR 7um
}

# Legge il template .def — definisce bounding box e pin del tile TinyTapeout
def read $TEMPLATE_FILE

# Rinomina la cella template con il nome del progetto
cellname rename tt_um_template $TOP_LEVEL_CELL

# Procedura per disegnare una power stripe verticale in met4
proc draw_power_stripe {name x} {
    global POWER_STRIPE_WIDTH
    # La stripe occupa tutta l'altezza del tile (5 µm → 220.76 µm)
    box $x 5um $x 220.76um
    box width $POWER_STRIPE_WIDTH
    paint met4
    # Crea il port label per la stripe (necessario per LVS e P&R)
    label $name FreeSans 1u -met4
    port make
    port use [expr {$name eq "VGND" ? "ground" : "power"}]
    port class bidirectional
    port connections n s e w
}

# Disegna tutte le power stripe configurate
foreach {name x} $POWER_STRIPES {
    puts "Disegno power stripe $name in posizione $x"
    draw_power_stripe $name $x
}

# Salva il file .mag del progetto
save ${TOP_LEVEL_CELL}.mag

puts "Setup TinyTapeout completato: ${TOP_LEVEL_CELL}.mag"
quit -noprompt
