# drc.tcl
# Adattato da: https://github.com/mattvenn/ttsky25b-analog-relax-oscillator
# Licenza originale: Apache-2.0 (Copyright © Tiny Tapeout LTD)
# Esegue il DRC completo in batch con Magic VLSI.
#
# Uso (dalla cartella mag/):
#   magic -dnull -noconsole -rcfile $PDK_ROOT/$PDK/libs.tech/magic/sky130A.magicrc \
#         tcl/drc.tcl NOME_CELLA
#
# Oppure tramite Makefile:
#   make drc
#
# Output: stampa a console il numero di errori DRC e i dettagli

set cell_name [lindex $argv $argc-1]

# Carica la cella
load $cell_name.mag
select top cell

# Abilita la distanza euclidea per il calcolo degli spacing
# (più preciso del metodo Manhattan per design curvi o a 45°)
drc euclidean on

# Imposta lo stile DRC completo (include tutte le regole del PDK)
drc style drc(full)

# Esegue il DRC
drc check

# Recupera e stampa tutti gli errori con la relativa spiegazione
set drc_result [drc listall why]
set error_count [drc list count total]

puts "DRC completato per: $cell_name"
puts "Numero totale di errori: $error_count"

if {$error_count > 0} {
    puts "\nDettaglio errori:"
    foreach {rule description} $drc_result {
        puts "  $rule: $description"
    }
}

quit -noprompt
