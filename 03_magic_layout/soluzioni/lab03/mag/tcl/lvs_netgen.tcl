# lvs_netgen.tcl
# Adattato da: https://github.com/mattvenn/ttsky25b-analog-relax-oscillator
# Licenza originale: Apache-2.0 (Copyright © Tiny Tapeout LTD)
# Esegue il confronto LVS tra la netlist estratta dal layout e la netlist schematica
# usando Netgen. Progettato per supportare design analogici standalone, mixed signal
# e progetti TinyTapeout (dove il top-level è sempre un file Verilog stub).
#
# Variabili richieste (impostate dal Makefile):
#   $project   — nome della cella top-level
#   $schematic — percorso della netlist LVS o file Verilog top-level
#
# Uso tramite Makefile:
#   make lvs
#
# Output: lvs.report

# ─── Caricamento netlist layout ────────────────────────────────────────────────
# Il layout è sempre il primo argomento (sinistra) in Netgen per convenzione.
set layout [readnet spice $project.lvs.spice]

# ─── Costruzione netlist schematica di riferimento ────────────────────────────
# Si inizializza con /dev/null e si aggiungono le netlist necessarie tramite
# readnet aggiuntivi — consente di combinare più netlist in un unico database.
set source [readnet spice /dev/null]

# ─── SCENARIO 1: Design analogico standalone (Moduli 3 e 5) ───────────────────
# La netlist top-level (buffer.spice) include già tutte le subcelle perché
# xschem le incorpora automaticamente quando genera la netlist LVS del top-level.
# Basta caricare un solo file.
readnet spice $schematic $source

# ─── SCENARIO 2: Progetto multi-blocco (subcelle con netlist separate) ────────
# Usare quando il top-level istanzia subcelle le cui netlist NON sono incluse
# automaticamente (blocchi IP esterni, subcelle aggiunte manualmente nel layout).
# Aggiungere un readnet per ogni blocco e caricare il top-level per ultimo.
#
# readnet spice ../xschem/simulation/blocco1.spice $source
# readnet spice ../xschem/simulation/blocco2.spice $source
# readnet spice $schematic $source

# ─── SCENARIO 3: TinyTapeout analogico (Modulo 6) ────────────────────────────
# Il top-level è sempre project.v (stub Verilog obbligatorio TT) che istanzia
# i blocchi analogici custom. Le SPICE dei blocchi analogici vanno caricate
# separatamente perché il Verilog non descrive la loro topologia interna.
# Non servono le celle digitali sky130_fd_sc_hd se il progetto è puramente analogico.
#
# readnet spice ../xschem/simulation/osc.spice $source
# readnet spice ../xschem/simulation/vfollower.spice $source
# readnet verilog ../src/project.v $source

# ─── SCENARIO 4: TinyTapeout mixed signal (Modulo 6) ─────────────────────────
# Come lo scenario 3, ma il project.v contiene anche logica digitale con celle
# standard sky130_fd_sc_hd — vanno caricate come netlist SPICE di riferimento.
#
# readnet spice $::env(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice $source
# readnet spice ../xschem/simulation/mio_blocco_analogico.spice $source
# readnet verilog ../src/project.v $source

# ─── Confronto LVS ────────────────────────────────────────────────────────────
# - "$layout $project"  : netlist estratta + nome top-cell
# - "$source $project"  : netlist schematica + nome top-cell (deve coincidere)
# - sky130A_setup.tcl   : regole di equivalenza PDK (alias device, pin matching)
# - lvs.report          : file di output con il report completo
# - -blackbox           : celle non riconosciute trattate come blackbox
#   (necessario per TinyTapeout dove alcune celle del wrapper non sono caricate)
lvs "$layout $project" \
    "$source $project" \
    $::env(PDK_ROOT)/sky130A/libs.tech/netgen/sky130A_setup.tcl \
    lvs.report \
    -blackbox
