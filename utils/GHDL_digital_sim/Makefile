# =============================================================================
# Makefile — Simulazione e visualizzazione VHDL con GHDL e Yosys
# =============================================================================
#
# CONVENZIONI AUTOMATICHE:
#   - Sorgenti cercati in src/*.vhd
#   - File *_tb.vhd analizzati per ultimi (dopo i DUT)
#   - Top-level simulazione : primo file *_tb.vhd trovato in src/
#   - Top-level schema      : TOP senza suffisso _tb (es. sar_controller)
#   - File intermedi (.o, .cf, eseguibile) in build/
#   - File VCD in sim/
#   - Schemi RTL/sintesi in build/ (PDF)
#
# OVERRIDE DA RIGA DI COMANDO:
#   make TOP=altro_tb         → forza il top-level simulazione
#   make DUT=altro_dut        → forza il top-level per gli schemi
#   make STOP_TIME=10us       → cambia il tempo di stop
#   make STD=--std=93         → cambia lo standard VHDL (default: 08)
#
# GERARCHIA MULTIPLA:
#   Per gerarchie profonde, sovrascrivere SRCS nel Makefile locale:
#
#   include /foss/designs/utils/GHDL_Digital_sim/Makefile
#   SRCS = src/livello_basso.vhd \
#          src/livello_medio.vhd \
#          src/top.vhd \
#          src/top_tb.vhd
#
# =============================================================================

GHDL      = ghdl
YOSYS     = yosys
STD       = --std=08
BUILD_DIR = build
SIM_DIR   = sim
VCD       = $(SIM_DIR)/dump.vcd
STOP_TIME = 100us

# -----------------------------------------------------------------------------
# Ricerca automatica dei sorgenti
# Ordine: DUT (non-TB, alfabetico) seguiti dai TB (alfabetico)
# -----------------------------------------------------------------------------
_ALL_SRCS = $(sort $(wildcard src/*.vhd))
_TB_SRCS  = $(sort $(wildcard src/*_tb.vhd))
_DUT_SRCS = $(filter-out $(_TB_SRCS), $(_ALL_SRCS))
SRCS     ?= $(_DUT_SRCS) $(_TB_SRCS)

# Top-level simulazione: primo file *_tb.vhd (es. sar_controller_tb)
TOP      ?= $(basename $(notdir $(firstword $(_TB_SRCS))))

# Top-level schema: TOP senza suffisso _tb (es. sar_controller)
# Può essere sovrascritto con: make DUT=altro_dut
DUT      ?= $(TOP:_tb=)

# -----------------------------------------------------------------------------
.PHONY: all sim wave rtl synth_view fsm clean info help lint \
        setup_gl sim_gl wave_gl clean_gl lint_gl

all: sim

# -----------------------------------------------------------------------------
# help
# -----------------------------------------------------------------------------
help:
	@echo ""
	@echo "  Makefile VHDL — GHDL + Yosys + LibreLane gate-level + d_cosim"
	@echo "  ================================================================"
	@echo ""
	@echo "  Simulazione RTL (GHDL):"
	@echo "    make              → compila e simula (equivale a: make sim)"
	@echo "    make sim          → analisi GHDL + elaborazione + simulazione"
	@echo "    make wave         → apre GTKWave con il VCD prodotto"
	@echo "    make lint         → linting VHDL con GHDL (senza simulare)"
	@echo ""
	@echo "  Visualizzazione schema (Yosys + plugin GHDL):"
	@echo "    make rtl          → schema RTL comportamentale (pre-sintesi)"
	@echo "    make synth_view   → schema post-sintesi (celle ottimizzate Yosys)"
	@echo "    make fsm          → schema con estrazione esplicita della FSM"
	@echo ""
	@echo "  Gate-level (iverilog + SKY130A, richiede run LibreLane in runs/):"
	@echo "    make setup_gl     → prepara gl/ (netlist + template tb) e gds/"
	@echo "    make lint_gl      → linting testbench Verilog con Verible"
	@echo "    make sim_gl       → simulazione gate-level funzionale"
	@echo "    make wave_gl      → apre GTKWave con il VCD gate-level"
	@echo "    make clean_gl     → rimuove gl/ e gds/"
	@echo ""
	@echo "  Co-simulazione mixed-signal (Verilator + ngspice d_cosim):"
	@echo "    make cosim_setup   → pipeline completa: VHDL→.v→.so + simbolo xschem"
	@echo "    make cosim_verilog → solo passo 1: VHDL → Verilog behavioral"
	@echo "    make cosim_build   → solo passo 2: Verilog → shared library .so"
	@echo "    make cosim_sym     → solo passo 3: Verilog → simbolo xschem .sym"
	@echo "    make clean_cosim   → rimuove .v .so .sym generati dalla co-simulazione"
	@echo ""
	@echo "  Utilità:"
	@echo "    make info         → mostra file trovati e parametri correnti"
	@echo "    make clean        → rimuove build/ e sim/"
	@echo "    make help         → mostra questo messaggio"
	@echo ""
	@echo "  Parametri correnti (sovrascrivibili da riga di comando):"
	@echo "    TOP=$(TOP)  (top-level simulazione)"
	@echo "    DUT=$(DUT)  (top-level schema e gate-level)"
	@echo "    STOP_TIME=$(STOP_TIME)"
	@echo "    STD=$(STD)"
	@echo "    GL_RUN=$(GL_RUN)  (vuoto = ultimo run; es: GL_RUN=util_40)"
	@echo "    COSIM_DIR=$(COSIM_DIR)  (output .v e .so)"
	@echo "    XSCHEM_DIR=$(XSCHEM_DIR)  (output .sym)"
	@echo ""
	@echo "  Esempi:"
	@echo "    make STOP_TIME=10us"
	@echo "    make setup_gl GL_RUN=util_40"
	@echo "    make DUT=altro_modulo rtl"
	@echo "    make cosim_setup"
	@echo "    make cosim_setup DUT=sar_controller  (forza il nome del modulo)"
	@echo ""

# -----------------------------------------------------------------------------
# info
# -----------------------------------------------------------------------------
info:
	@echo ""
	@echo "  Parametri correnti:"
	@echo "  =============================="
	@echo "  Sorgenti (ordine di analisi):"
	@for f in $(SRCS); do echo "    $$f"; done
	@echo "  Top simulazione : $(TOP)"
	@echo "  Top schema      : $(DUT)"
	@echo "  Stop time       : $(STOP_TIME)"
	@echo "  Standard        : $(STD)"
	@echo "  Build dir       : $(BUILD_DIR)/"
	@echo "  Output VCD      : $(VCD)"
	@echo ""
	@echo "  Gate-level:"
	@echo "  Run GL path     : $(_GL_RUN_PATH)"
	@echo "  GL netlist      : $(GL_NETLIST)"
	@echo "  GL testbench    : $(GL_TB)"
	@echo "  GL VCD          : $(GL_VCD)"
	@echo ""

# -----------------------------------------------------------------------------
# sim: analisi + elaborazione + simulazione
# -----------------------------------------------------------------------------
sim: $(VCD)

$(VCD): $(SRCS)
	@if [ -z "$(_TB_SRCS)" ]; then \
		echo "ERRORE: nessun file *_tb.vhd trovato in src/"; \
		echo "Crea un testbench con nome *_tb.vhd oppure usa: make TOP=nome_top"; \
		exit 1; \
	fi
	@mkdir -p $(BUILD_DIR) $(SIM_DIR)
	@echo "--> Analisi sorgenti VHDL (ordine: DUT prima, TB dopo)..."
	@for f in $(SRCS); do \
		echo "    ghdl -a $(STD): $$f"; \
		$(GHDL) -a $(STD) --workdir=$(BUILD_DIR) $$f || exit 1; \
	done
	@echo "--> Elaborazione top-level: $(TOP)..."
	$(GHDL) -e $(STD) --workdir=$(BUILD_DIR) -o $(BUILD_DIR)/$(TOP) $(TOP)
	@echo "--> Simulazione (stop: $(STOP_TIME))..."
	$(BUILD_DIR)/$(TOP) --vcd=$(VCD) --stop-time=$(STOP_TIME)
	@echo "--> VCD generato: $(VCD)"

# -----------------------------------------------------------------------------
# wave: apre GTKWave in background
# -----------------------------------------------------------------------------
wave: $(VCD)
	gtkwave $(VCD) &

# -----------------------------------------------------------------------------
# rtl: schema comportamentale pre-sintesi tramite Yosys + plugin GHDL
#
# Mostra il design come descritto nel VHDL: flip-flop, mux, registri come
# primitivi astratti — utile per verificare la struttura della FSM prima
# della sintesi tecnologica.
#
# Salva: build/rtl_<DUT>.dot e build/rtl_<DUT>.pdf
# Apre xdot in modo interattivo:
#   rotella del mouse = zoom   |   click sinistro + drag = pan
# Richiede: yosys con plugin GHDL (disponibile in IIC-OSIC-TOOLS)
# -----------------------------------------------------------------------------
rtl: $(_DUT_SRCS)
	@if [ -z "$(_DUT_SRCS)" ]; then \
		echo "ERRORE: nessun sorgente DUT trovato in src/"; exit 1; \
	fi
	@mkdir -p $(BUILD_DIR)
	@echo "--> Schema RTL comportamentale: $(DUT)"
	$(YOSYS) -m ghdl -p \
		"ghdl $(STD) $(_DUT_SRCS) -e $(DUT); \
		 proc; opt; \
		 show -colors 2 -width -signed -format dot \
		      -prefix $(BUILD_DIR)/rtl_$(DUT)"
	@dot -Tpdf $(BUILD_DIR)/rtl_$(DUT).dot > $(BUILD_DIR)/rtl_$(DUT).pdf
	@echo "--> PDF salvato: $(BUILD_DIR)/rtl_$(DUT).pdf"
	xdot $(BUILD_DIR)/rtl_$(DUT).dot &

# -----------------------------------------------------------------------------
# synth_view: schema post-sintesi con celle ottimizzate da Yosys
#
# Mostra il design dopo la sintesi logica generica: le strutture
# comportamentali vengono mappate su AND, OR, NOT, DFF e mux elementari.
# Diverso dalla sintesi SKY130A (quella la fa LibreLane nel lab02) — qui
# si usano celle generiche per una visualizzazione più leggibile.
#
# Salva: build/synth_<DUT>.dot e build/synth_<DUT>.pdf
# Apre xdot in modo interattivo:
#   rotella del mouse = zoom   |   click sinistro + drag = pan
# Richiede: yosys con plugin GHDL (disponibile in IIC-OSIC-TOOLS)
# -----------------------------------------------------------------------------
synth_view: $(_DUT_SRCS)
	@if [ -z "$(_DUT_SRCS)" ]; then \
		echo "ERRORE: nessun sorgente DUT trovato in src/"; exit 1; \
	fi
	@mkdir -p $(BUILD_DIR)
	@echo "--> Schema post-sintesi (celle generiche): $(DUT)"
	$(YOSYS) -m ghdl -p \
		"ghdl $(STD) $(_DUT_SRCS) -e $(DUT); \
		 synth -top $(DUT); \
		 show -colors 2 -width -signed -format dot \
		      -prefix $(BUILD_DIR)/synth_$(DUT)"
	@dot -Tpdf $(BUILD_DIR)/synth_$(DUT).dot > $(BUILD_DIR)/synth_$(DUT).pdf
	@echo "--> PDF salvato: $(BUILD_DIR)/synth_$(DUT).pdf"
	xdot $(BUILD_DIR)/synth_$(DUT).dot &

# -----------------------------------------------------------------------------
# fsm: schema con tentativo di estrazione esplicita della FSM
#
# Sequenza: proc → opt → fsm_detect → fsm_extract → fsm_opt → show
# Si ferma PRIMA di fsm_map (che rimapperebbe la FSM in logica elementare).
#
# Limitazione nota: fsm_detect non riconosce flip-flop con reset ASINCRONO
# ($adff). Nei design ASIC-style questo target produce uno schema identico
# a make rtl. Rimane nel Makefile come strumento generico per design con
# reset sincrono o tool chain diverse.
#
# Requisito per il funzionamento: segnale di stato senza inizializzazione
#   CORRETTO: signal state : state_t;
#   ERRATO:   signal state : state_t := ST_RESET;
#
# Salva: build/fsm_<DUT>.dot e build/fsm_<DUT>.pdf
# Apre xdot in modo interattivo
# -----------------------------------------------------------------------------
fsm: $(_DUT_SRCS)
	@if [ -z "$(_DUT_SRCS)" ]; then \
		echo "ERRORE: nessun sorgente DUT trovato in src/"; exit 1; \
	fi
	@mkdir -p $(BUILD_DIR)
	@echo "--> Schema FSM: $(DUT)"
	@echo "    Nota: con reset asincrono (ASIC-style) lo schema e' identico a make rtl."
	$(YOSYS) -m ghdl -p \
		"ghdl $(STD) $(_DUT_SRCS) -e $(DUT); \
		 proc; opt; fsm_detect; fsm_extract; fsm_opt; \
		 show -colors 2 -width -signed -format dot \
		      -prefix $(BUILD_DIR)/fsm_$(DUT)"
	@dot -Tpdf $(BUILD_DIR)/fsm_$(DUT).dot > $(BUILD_DIR)/fsm_$(DUT).pdf
	@echo "--> PDF salvato: $(BUILD_DIR)/fsm_$(DUT).pdf"
	xdot $(BUILD_DIR)/fsm_$(DUT).dot &

# -----------------------------------------------------------------------------
# clean
# -----------------------------------------------------------------------------
clean:
	@rm -rf $(BUILD_DIR) $(SIM_DIR)
	@echo "--> Pulizia completata (rimossi: $(BUILD_DIR)/ $(SIM_DIR)/)"

# =============================================================================
# SEZIONE GATE-LEVEL — LibreLane + iverilog
# =============================================================================
#
# Questi target richiedono che LibreLane abbia completato almeno un run
# nella cartella runs/ (creata da: librelane --flow VHDLClassic config.json)
#
# VARIABILI OVERRIDE:
#   make setup_gl GL_RUN=util_40   → usa il run con tag 'util_40'
#   make sim_gl                    → usa l'ultimo run disponibile
#
# =============================================================================

# Tool e path gate-level
IVERILOG   := iverilog
VVP        := vvp
PDK_ROOT   ?= /foss/pdks
SKY130_VLG := $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog

# Cartelle output gate-level
GL_DIR     := gl
GDS_DIR    := gds
GL_VCD     := $(SIM_DIR)/dump_gl.vcd
GL_EXE     := $(BUILD_DIR)/sim_gl

# Run di riferimento: vuoto = ultimo RUN_* cronologico; altrimenti usa il tag
GL_RUN     ?=

# Individua la cartella del run correttamente (tagged o timestamped)
_GL_RUN_PATH = $(if $(GL_RUN),\
    runs/$(GL_RUN),\
    $(shell ls -dt runs/RUN_* 2>/dev/null | head -1))

# Netlist e testbench gate-level
GL_NETLIST  = $(wildcard $(GL_DIR)/*.pnl.v)
GL_TB       = $(GL_DIR)/$(DUT)_gl_tb.v

# Tool linting
VERIBLE     := verible-verilog-lint
VERIBLE_CFG := verible.rules   # opzionale: crea questo file per customizzare le regole

# -----------------------------------------------------------------------------
# lint: linting dei sorgenti VHDL con GHDL
#
# Esegue l'analisi sintattica e semantica senza elaborazione né simulazione.
# -----------------------------------------------------------------------------
lint: $(_DUT_SRCS)
	@echo "--> Linting VHDL con GHDL..."
	@mkdir -p $(BUILD_DIR)
	$(GHDL) -a $(STD) --workdir=$(BUILD_DIR) \
		--warn-no-vital-generic --warn-unused $(SRCS)
	@echo "--> Linting VHDL completato: nessun errore."

# -----------------------------------------------------------------------------
# lint_gl: linting della netlist gate-level e del testbench Verilog
#
# Usa Verible — linter Verilog completo che controlla stile, naming
# conventions e struttura del codice, non solo la sintassi.
#
# Se esiste il file verible.rules nella cartella del progetto, viene usato
# per customizzare le regole attive. Altrimenti si usano i default.
#
# Per creare un file di configurazione di partenza:
#   verible-verilog-lint --generate_waiver_files gl/*.v
# -----------------------------------------------------------------------------
lint_gl:
	@if [ -z "$(GL_NETLIST)" ]; then \
		echo "ERRORE: nessuna netlist in $(GL_DIR)/. Esegui prima: make setup_gl"; \
		exit 1; \
	fi
	@if [ ! -f "$(GL_TB)" ]; then \
		echo "ERRORE: $(GL_TB) non trovato. Esegui prima: make setup_gl"; \
		exit 1; \
	fi
	@echo "--> Linting gate-level con Verible..."
	@echo "    Testbench: $(GL_TB)"
	@if [ -f "$(VERIBLE_CFG)" ]; then \
		echo "    Config   : $(VERIBLE_CFG)"; \
		$(VERIBLE) $(GL_TB) --rules_config $(VERIBLE_CFG); \
	else \
		$(VERIBLE) $(GL_TB); \
	fi
	@echo "--> Linting Verible completato."

# -----------------------------------------------------------------------------
# setup_gl: prepara la cartella gate-level dall'ultimo run LibreLane
#
# Crea:
#   gl/   ← netlist .pnl.v con define/include SKY130A embedded
#           + template testbench <DUT>_gl_tb.v da completare in VS Code
#   gds/  ← .gds e .mag (per integrazione layout nel Modulo 5)
#
# Override del run: make setup_gl GL_RUN=util_40
# -----------------------------------------------------------------------------
setup_gl:
	@if [ -z "$(_GL_RUN_PATH)" ]; then \
		echo "ERRORE: nessun run LibreLane trovato in runs/."; \
		echo "Esegui prima: librelane --flow VHDLClassic config.json"; \
		exit 1; \
	fi
	@echo "--> Run selezionato: $(_GL_RUN_PATH)"
	@mkdir -p $(GL_DIR) $(GDS_DIR)
	@# Copia netlist gate-level finale e prepende define/include SKY130A
	@PNL=$$(find $(_GL_RUN_PATH)/final/pnl -name "*.pnl.v" 2>/dev/null | head -1); \
	if [ -z "$$PNL" ]; then \
		echo "ERRORE: netlist .pnl.v non trovata in $(_GL_RUN_PATH)/final/pnl/"; \
		exit 1; \
	fi; \
	DEST=$(GL_DIR)/$$(basename $$PNL); \
	printf '// Gate-level defines e include celle SKY130A\n' > $$DEST; \
	printf '`define UNIT_DELAY #1\n' >> $$DEST; \
	printf '`define FUNCTIONAL\n' >> $$DEST; \
	printf '`define USE_POWER_PINS\n' >> $$DEST; \
	printf '`include "$(SKY130_VLG)/primitives.v"\n' >> $$DEST; \
	printf '`include "$(SKY130_VLG)/sky130_fd_sc_hd.v"\n' >> $$DEST; \
	printf '\n' >> $$DEST; \
	cat "$$PNL" >> $$DEST; \
	echo "--> Netlist preparata: $$DEST (con define/include SKY130A)"
	@# Copia GDS
	@GDS=$$(find $(_GL_RUN_PATH)/final/gds -name "*.gds" 2>/dev/null | head -1); \
	if [ -n "$$GDS" ]; then \
		cp "$$GDS" $(GDS_DIR)/; \
		echo "--> GDS copiato:     $(GDS_DIR)/$$(basename $$GDS)"; \
	fi
	@# Copia MAG (se esiste)
	@MAG=$$(find $(_GL_RUN_PATH)/final/mag -name "*.mag" 2>/dev/null | head -1); \
	if [ -n "$$MAG" ]; then \
		cp "$$MAG" $(GDS_DIR)/; \
		echo "--> MAG copiato:     $(GDS_DIR)/$$(basename $$MAG)"; \
	else \
		echo "    (nessun file .mag trovato)"; \
	fi
	@# Copia template testbench Verilog gate-level rinominato per il progetto
	@TEMPLATE=/foss/designs/utils/GHDL_Digital_sim/gl_tb_template.v; \
	DEST=$(GL_DIR)/$(DUT)_gl_tb.v; \
	if [ -f "$$TEMPLATE" ]; then \
		cp "$$TEMPLATE" "$$DEST"; \
		echo "--> Template testbench: $$DEST"; \
		echo "    Apri in VS Code e segui i passi [PASSO 1]..[PASSO 9]"; \
	else \
		echo "    (template non trovato: $$TEMPLATE)"; \
	fi
	@echo "--> setup_gl completato. Prossimo passo: modifica $(GL_DIR)/$(DUT)_gl_tb.v"

# -----------------------------------------------------------------------------
# sim_gl: simulazione gate-level con iverilog
#
# Prerequisiti: make setup_gl (poi completare il testbench in gl/)
# La netlist è autocontenuta: include già le celle SKY130A via define embedded.
# -----------------------------------------------------------------------------
sim_gl: $(GL_EXE)
	@mkdir -p $(SIM_DIR)
	@echo "--> Simulazione gate-level funzionale: $(DUT)"
	$(VVP) $(GL_EXE) -vcd $(GL_VCD)
	@echo "--> VCD salvato: $(GL_VCD)"
	@echo "    Visualizza con: make wave_gl"

$(GL_EXE): $(GL_NETLIST) $(GL_TB)
	@if [ -z "$(GL_NETLIST)" ]; then \
		echo "ERRORE: nessuna netlist in $(GL_DIR)/. Esegui prima: make setup_gl"; \
		exit 1; \
	fi
	@if [ ! -f "$(GL_TB)" ]; then \
		echo "ERRORE: $(GL_TB) non trovato."; \
		echo "Esegui make setup_gl e poi completa il testbench in $(GL_DIR)/"; \
		exit 1; \
	fi
	@mkdir -p $(BUILD_DIR)
	@echo "--> Compilazione iverilog gate-level..."
	@echo "    (celle SKY130A incluse via define nella netlist)"
	$(IVERILOG) -g2012 -I $(PDK_ROOT)/sky130A \
		-o $(GL_EXE) \
		$(GL_NETLIST) $(GL_TB)

# -----------------------------------------------------------------------------
# wave_gl: apre GTKWave con il VCD della simulazione gate-level
# -----------------------------------------------------------------------------
wave_gl:
	@if [ ! -f "$(GL_VCD)" ]; then \
		echo "ERRORE: $(GL_VCD) non trovato. Esegui prima: make sim_gl"; \
		exit 1; \
	fi
	gtkwave $(GL_VCD) &

# -----------------------------------------------------------------------------
# clean_gl: rimuove le cartelle gate-level (gl/ e gds/)
# -----------------------------------------------------------------------------
clean_gl:
	@rm -rf $(GL_DIR) $(GDS_DIR) $(GL_EXE)
	@echo "--> Pulizia gate-level completata (rimossi: $(GL_DIR)/ $(GDS_DIR)/)"

# =============================================================================
# SEZIONE CO-SIMULAZIONE MIXED-SIGNAL — Verilator + ngspice d_cosim
# =============================================================================
#
# Questi target estendono il Makefile con il flusso di co-simulazione
# analogico-digitale (Modulo 5). Il SAR controller VHDL viene:
#   1. Convertito in Verilog behavioral tramite Yosys + plugin GHDL
#   2. Compilato con Verilator in una shared library (.so)
#   3. Trasformato in un simbolo xschem con notazione bus
#
# Il blocco digitale compilato viene integrato in xschem come istanza
# d_cosim: ngspice simula i blocchi analogici (CDAC, comparatore) e
# Verilator simula il controller digitale, con loop di retroazione chiuso.
#
# DIPENDENZE (tutte presenti in IIC-OSIC-TOOLS v2025.07):
#   - Yosys + plugin GHDL  (già usati da make rtl/fsm/synth_view)
#   - Verilator 5.038
#   - ngspice 44.2 con vlnggen (path assoluto — non nel PATH di default)
#   - Python 3 con generate_sym.py (nella stessa cartella di questo Makefile)
#
# STRUTTURA OUTPUT:
#   $(COSIM_DIR)/$(DUT)_behav.v    ← Verilog behavioral (da VHDL via Yosys)
#   $(COSIM_DIR)/$(DUT)_behav.so   ← libreria Verilator (caricata da d_cosim)
#   $(XSCHEM_DIR)/$(DUT).sym       ← simbolo xschem (bus notation, @model)
#
# WORKFLOW (one-shot setup, poi si lavora interamente in xschem):
#   make cosim_setup
#   → apri xschem/top_tb.sch e simula normalmente con Simulation → Run
#
# PARAMETRI OVERRIDE:
#   make cosim_setup COSIM_DIR=altro/path
#   make cosim_sym   XSCHEM_DIR=altro/path
#   make cosim_build DUT=altro_modulo
#
# =============================================================================

# Path assoluto a vlnggen.
# Non è nel PATH di default in IIC-OSIC-TOOLS — va invocato tramite ngspice.
VLNGGEN     := /foss/tools/ngspice/share/ngspice/scripts/vlnggen

# Script Python per generare il simbolo xschem con notazione bus.
# Path assoluto fisso: generate_sym.py risiede in utils/GHDL_Digital_sim/
# accanto al Makefile originale. Sovrascrivibile da riga di comando:
#   make cosim_sym GEN_SYM=/altro/path/generate_sym.py
GEN_SYM     ?= /foss/designs/utils/GHDL_Digital_sim/generate_sym.py

# Cartella di simulazione xschem: xschem crea automaticamente questa cartella
# quando lancia ngspice. Il .so deve essere qui perché il device_model lo
# referenzia con il path relativo "./$(DUT)_behav.so".
COSIM_DIR   ?= xschem/simulation

# Cartella dove va il simbolo .sym generato (radice degli schemi xschem).
XSCHEM_DIR  ?= xschem

# _COSIM_DUT: DUT per i target cosim con fallback automatico.
# Se DUT è vuoto (nessun *_tb.vhd in src/), usa il nome del primo sorgente
# non-testbench trovato in src/. Permette di usare make cosim_setup anche
# senza testbench VHDL (lab mixed-signal con testbench in xschem).
# Override sempre possibile: make cosim_setup DUT=nome_modulo
_COSIM_DUT  := $(if $(DUT),$(DUT),$(basename $(notdir $(firstword $(_DUT_SRCS)))))

COSIM_V     := $(COSIM_DIR)/$(_COSIM_DUT)_behav.v
COSIM_SO    := $(COSIM_DIR)/$(_COSIM_DUT)_behav.so
COSIM_SYM   := $(XSCHEM_DIR)/$(_COSIM_DUT).sym

.PHONY: cosim_verilog cosim_build cosim_sym cosim_setup clean_cosim

# -----------------------------------------------------------------------------
# cosim_verilog: VHDL → Verilog behavioral tramite Yosys + plugin GHDL
#
# Usa la stessa pipeline già sfruttata da make rtl, ma si ferma al passo
# 'proc' (elaborazione dei processi comportamentali) senza procedere alla
# tech-mapping. Il risultato è Verilog behavioral compatibile con Verilator.
#
# Il file viene scritto in $(COSIM_DIR) perché vlnggen (passo successivo)
# deve essere eseguito dalla stessa cartella dove vuole scrivere il .so.
#
# Input:  src/*.vhd (DUT, senza testbench)
# Output: $(COSIM_V)
# -----------------------------------------------------------------------------
cosim_verilog: $(_DUT_SRCS)
	@if [ -z "$(_DUT_SRCS)" ]; then \
		echo "ERRORE: nessun sorgente DUT trovato in src/"; exit 1; \
	fi
	@mkdir -p $(COSIM_DIR)
	@echo "--> [1/3] VHDL → Verilog behavioral: $(_COSIM_DUT)"
	@echo "    Sorgenti: $(_DUT_SRCS)"
	$(YOSYS) -m ghdl -p \
		"ghdl $(STD) $(_DUT_SRCS) -e $(_COSIM_DUT); \
		 proc; \
		 write_verilog $(abspath $(COSIM_V))"
	@# Inject lint_off pragmas to suppress harmless Verilator warnings
	@# - WIDTHTRUNC: '!state' on multi-bit signals (correct semantics: NOR reduction)
	@# - CASEOVERLAP: priority encoder pattern from VHDL if-elsif (Yosys-generated)
	@sed -i '1i /* verilator lint_off WIDTHTRUNC */\n/* verilator lint_off CASEOVERLAP */' $(COSIM_V)
	@echo "--> Verilog behavioral scritto: $(COSIM_V)"

# -----------------------------------------------------------------------------
# cosim_build: Verilog behavioral → shared library Verilator (.so)
#
# Invoca vlnggen tramite ngspice (lo script interpreta il suo contenuto).
# DEVE essere eseguito dalla cartella $(COSIM_DIR) perché vlnggen scrive
# il .so nella directory corrente, usando il nome del file .v senza estensione
# come nome del modulo e del file .so prodotto.
#
# Richiede: cosim_verilog completato ($(COSIM_V) presente)
# Input:    $(COSIM_V)
# Output:   $(COSIM_SO)   (stessa cartella, nome: $(DUT)_behav.so)
# Tempo:    ~10–30 secondi (compilazione Verilator, one-shot)
# -----------------------------------------------------------------------------
cosim_build: cosim_verilog
	@echo "--> [2/3] Verilog → shared library Verilator: $(_COSIM_DUT)_behav.so"
	@echo "    Esecuzione in: $(COSIM_DIR)/"
	cd $(COSIM_DIR) && ngspice $(VLNGGEN) $(notdir $(COSIM_V))
	@if [ ! -f "$(COSIM_SO)" ]; then \
		echo "ERRORE: $(COSIM_SO) non generato. Verifica l'output di vlnggen."; \
		exit 1; \
	fi
	@echo "--> Shared library scritta: $(COSIM_SO)"

# -----------------------------------------------------------------------------
# cosim_sym: Verilog behavioral → simbolo xschem con notazione bus
#
# Genera il file .sym per xschem usando generate_sym.py (nella stessa
# cartella di questo Makefile). Il simbolo segue il pattern di Schippers:
#   - porte bus compatte: dac_p[7..0] invece di dac_p7,dac_p6,...,dac_p0
#   - attributo @model nel format= (il device_model si imposta per istanza)
#   - template con model=./$(DUT)_behav.so come default
#
# Il simbolo generato va in $(XSCHEM_DIR)/$(DUT).sym e va importato
# manualmente nello schema xschem (place → symbol).
#
# Richiede: cosim_verilog completato ($(COSIM_V) presente)
# Input:    $(COSIM_V)
# Output:   $(COSIM_SYM)
# -----------------------------------------------------------------------------
cosim_sym: cosim_verilog
	@if [ ! -f "$(GEN_SYM)" ]; then \
		echo "ERRORE: generate_sym.py non trovato in: $(GEN_SYM)"; \
		echo "Verifica che il file sia nella stessa cartella del Makefile."; \
		exit 1; \
	fi
	@mkdir -p $(XSCHEM_DIR)
	@echo "--> [3/3] Verilog → simbolo xschem: $(_COSIM_DUT).sym"
	python3 $(GEN_SYM) $(COSIM_V) $(COSIM_SYM)
	@if [ ! -f "$(COSIM_SYM)" ]; then \
		echo "ERRORE: $(COSIM_SYM) non generato."; exit 1; \
	fi
	@echo "--> Simbolo scritto: $(COSIM_SYM)"

# -----------------------------------------------------------------------------
# cosim_setup: pipeline completa one-shot (passi 1+2+3 in sequenza)
#
# Eseguire una volta prima di aprire xschem per la simulazione mixed-signal.
# Dopo cosim_setup, la .so e il .sym sono pronti — si lavora interamente
# in xschem senza tornare al terminale (a meno di modifiche al VHDL).
#
# Se il VHDL viene modificato: make cosim_setup per rigenerare tutto.
# Se si cambia solo il testbench xschem: non serve rieseguire cosim_setup.
# -----------------------------------------------------------------------------
cosim_setup: cosim_build cosim_sym
	@echo ""
	@echo "  ╔══════════════════════════════════════════════════════════════╗"
	@echo "  ║  cosim_setup completato — file pronti per xschem            ║"
	@echo "  ╠══════════════════════════════════════════════════════════════╣"
	@echo "  ║  Shared library : $(COSIM_SO)"
	@echo "  ║  Simbolo xschem : $(COSIM_SYM)"
	@echo "  ╠══════════════════════════════════════════════════════════════╣"
	@echo "  ║  Prossimo passo:                                             ║"
	@echo "  ║    1. Apri lo schema in xschem                               ║"
	@echo "  ║    2. Usa Place → Symbol e scegli $(_COSIM_DUT).sym      ║"
	@echo "  ║    3. Imposta device_model nell'istanza (vedi README)        ║"
	@echo "  ║    4. Simulation → Run                                       ║"
	@echo "  ╚══════════════════════════════════════════════════════════════╝"
	@echo ""

# -----------------------------------------------------------------------------
# clean_cosim: rimuove i file generati dalla pipeline di co-simulazione
#
# NON rimuove gli schemi xschem né i file sorgente VHDL.
# La cartella $(COSIM_DIR) viene rimossa solo se contiene esclusivamente
# file generati da cosim_setup (per evitare eliminazioni accidentali).
# -----------------------------------------------------------------------------
clean_cosim:
	@rm -f $(COSIM_V) $(COSIM_SO) $(COSIM_SYM)
	@# Rimuovi le cartelle intermedie generate da Verilator (obj_dir)
	@rm -rf $(COSIM_DIR)/obj_dir $(COSIM_DIR)/$(_COSIM_DUT)_behav_obj_dir
	@echo "--> Pulizia co-simulazione completata."
	@echo "    Rimossi: $(COSIM_V)"
	@echo "             $(COSIM_SO)"
	@echo "             $(COSIM_SYM)"

