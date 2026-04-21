# Makefile per flusso layout analogico — PSEI-ASIC-Lab
# Compatibile con SKY130A nel container IIC-OSIC-TOOLS v2025.07
# Adattato dall'approccio di Matt Venn (TinyTapeout analog projects)
#
# USO:
#   1. Copia questa cartella (mag_scripts/) nella tua cartella mag/ del progetto
#   2. Imposta PROJECT_NAME e SCHEMATIC_SPICE qui sotto (o passali da riga di comando)
#   3. Usa i target disponibili:
#
#      make magic      — apre Magic con la cella del progetto
#      make drc        — DRC completo in batch
#      make antenna    — verifica antenna rule violations
#      make lvs        — estrazione LVS + confronto Netgen
#      make pex        — estrazione post-layout con parassitici R+C
#      make update_gds — esporta GDS e LEF per il tapeout
#      make start      — inizializza tile TinyTapeout (Modulo 6)
#      make clean      — rimuove tutti i file generati
#
# ESEMPIO da riga di comando:
#   make lvs PROJECT_NAME=buffer SCHEMATIC_SPICE=../xschem/simulation/buffer.spice

# ─── Configurazione progetto ───────────────────────────────────────────────────
# Nome della cella top-level (file .mag nella cartella mag/)
PROJECT_NAME ?= buffer

# Netlist LVS dello schematico (generata da xschem con opzione LVS netlist attiva)
SCHEMATIC_SPICE ?= ../xschem/simulation/$(PROJECT_NAME).spice

# ─── Configurazione ambiente ───────────────────────────────────────────────────
MAGIC_RC := $(PDK_ROOT)/sky130A/libs.tech/magic/sky130A.magicrc

# ─── Configurazione TinyTapeout (usata solo dal target 'start') ───────────────
# Template del tile analogico TinyTapeout (scaricato automaticamente da 'start')
TT_TEMPLATE_FILE := tt_analog_1x2.def
TT_TEMPLATE_URL  := https://raw.githubusercontent.com/TinyTapeout/tt-support-tools/ttsky25a/def/analog/tt_analog_1x2.def

# ─── Target principali ─────────────────────────────────────────────────────────
.PHONY: magic drc antenna lvs pex update_gds start clean

# Apre Magic in modalità interattiva con la cella del progetto
magic:
	magic -rcfile $(MAGIC_RC) $(PROJECT_NAME).mag

# DRC completo in batch — stampa il conteggio e il dettaglio degli errori
drc:
	magic -dnull -noconsole -rcfile $(MAGIC_RC) tcl/drc.tcl $(PROJECT_NAME)

# Verifica antenna rule violations
# Le antenna rules limitano la lunghezza massima di filo connessa a un gate
# durante la fabbricazione — fili troppo lunghi accumulano carica e danneggiano
# il gate oxide. Questo check diventa rilevante nel Modulo 6 (tapeout).
antenna:
	magic -dnull -noconsole -rcfile $(MAGIC_RC) tcl/antenna.tcl $(PROJECT_NAME)
	rm -f *.ext

# ─── LVS ───────────────────────────────────────────────────────────────────────
# Estrae la netlist LVS dal layout
$(PROJECT_NAME).lvs.spice: $(PROJECT_NAME).mag
	magic -dnull -noconsole -rcfile $(MAGIC_RC) \
	      tcl/extract_for_lvs.tcl $(PROJECT_NAME)
	rm -f *.ext *.sim *.nodes

# Estrazione LVS + confronto Netgen con riepilogo del risultato
lvs: $(PROJECT_NAME).lvs.spice
	netgen -batch eval \
	  "set project $(PROJECT_NAME) ; \
	   set schematic $(SCHEMATIC_SPICE) ; \
	   source tcl/lvs_netgen.tcl"
	@echo ""
	@echo "─── Risultato LVS ───────────────────────────────"
	@match=0; prop=1; port=1; \
	 if grep -q "match uniquely" lvs.report; then match=1; fi; \
	 if grep -q "Netlists do not match" lvs.report; then match=0; fi; \
	 if grep -qi "property errors" lvs.report; then prop=0; fi; \
	 if grep -q "port errors" lvs.report; then port=0; fi; \
	 if grep -q "failed pin matching" lvs.report; then port=0; fi; \
	 if [ $$match -eq 1 ]; then echo "✓ Match:      PASS"; else echo "✗ Match:      FAIL"; fi; \
	 if [ $$prop  -eq 1 ]; then echo "✓ Properties: PASS"; else echo "✗ Properties: FAIL"; fi; \
	 if [ $$port  -eq 1 ]; then echo "✓ Port:       PASS"; else echo "✗ Port:       FAIL"; fi
	@echo "─────────────────────────────────────────────────"
	@echo "Report completo: lvs.report"

# ─── PEX ───────────────────────────────────────────────────────────────────────
# Estrae la netlist post-layout con parassitici R+C (resistenze distribuite
# tramite extresist — più accurato delle resistenze lumped per SPICE analogico)
$(PROJECT_NAME).sim.spice: $(PROJECT_NAME).mag
	magic -dnull -noconsole -rcfile $(MAGIC_RC) \
	      tcl/extract_for_sim.tcl $(PROJECT_NAME)
	rm -f *.ext *.sim *.nodes

pex: $(PROJECT_NAME).sim.spice
	@echo "Estrazione PEX completata: $(PROJECT_NAME).sim.spice"

# ─── Export GDS + LEF ──────────────────────────────────────────────────────────
# Esporta il layout per il tapeout:
# - GDS: inviato alla foundry per la fabbricazione
# - LEF: usato dai tool di P&R per integrare il blocco in un design digitale
update_gds:
	mkdir -p ../gds ../lef
	magic -dnull -noconsole -rcfile $(MAGIC_RC) \
	      tcl/update_gds_lef.tcl $(PROJECT_NAME)
	@echo "GDS: ../gds/$(PROJECT_NAME).gds"
	@echo "LEF: ../lef/$(PROJECT_NAME).lef"

# ─── TinyTapeout setup ─────────────────────────────────────────────────────────
# Scarica il template del tile analogico TinyTapeout e inizializza il layout.
# Crea il file .mag con il bounding box del tile e le power stripe in met4.
# Usato nel Modulo 6 — non necessario per i Moduli 3 e 5.
$(TT_TEMPLATE_FILE):
	wget $(TT_TEMPLATE_URL)

start: $(TT_TEMPLATE_FILE)
	magic -dnull -noconsole -rcfile $(MAGIC_RC) \
	      tcl/tt_analog_setup.tcl $(TT_TEMPLATE_FILE) $(PROJECT_NAME)

# ─── Pulizia ───────────────────────────────────────────────────────────────────
clean:
	rm -f lvs.report *.lvs.spice *.sim.spice *.fb.txt *.ext *.sim *.nodes
