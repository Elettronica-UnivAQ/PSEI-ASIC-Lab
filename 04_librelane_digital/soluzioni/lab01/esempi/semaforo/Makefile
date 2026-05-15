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
.PHONY: all sim wave rtl synth_view fsm clean info help

all: sim

# -----------------------------------------------------------------------------
# help
# -----------------------------------------------------------------------------
help:
	@echo ""
	@echo "  Makefile VHDL — GHDL + Yosys"
	@echo "  =============================="
	@echo ""
	@echo "  Simulazione:"
	@echo "    make              → compila e simula (equivale a: make sim)"
	@echo "    make sim          → analisi GHDL + elaborazione + simulazione"
	@echo "    make wave         → apre GTKWave con il VCD prodotto"
	@echo ""
	@echo "  Visualizzazione schema (richiede Yosys + plugin GHDL):"
	@echo "    make rtl          → schema RTL comportamentale (pre-sintesi)"
	@echo "    make synth_view   → schema post-sintesi (celle ottimizzate Yosys)"
	@echo "    make fsm          → schema con estrazione esplicita della FSM"
	@echo ""
	@echo "  Utilità:"
	@echo "    make info         → mostra file trovati e parametri correnti"
	@echo "    make clean        → rimuove build/ e sim/"
	@echo "    make help         → mostra questo messaggio"
	@echo ""
	@echo "  Parametri correnti (sovrascrivibili da riga di comando):"
	@echo "    TOP=$(TOP)  (top-level simulazione)"
	@echo "    DUT=$(DUT)  (top-level schema)"
	@echo "    STOP_TIME=$(STOP_TIME)"
	@echo "    STD=$(STD)"
	@echo ""
	@echo "  Esempi:"
	@echo "    make STOP_TIME=10us"
	@echo "    make DUT=altro_modulo rtl"
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
