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
	@echo "  Makefile VHDL — GHDL + Yosys + LibreLane gate-level"
	@echo "  ======================================================"
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
	@echo "    GL_RUN=$(GL_RUN)  (vuoto = ultimo run; es: GL_RUN=util_40)"
	@echo ""
	@echo "  Esempi:"
	@echo "    make STOP_TIME=10us"
	@echo "    make setup_gl GL_RUN=util_40"
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
