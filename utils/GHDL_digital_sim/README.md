# GHDL Digital Sim — Makefile e strumenti per simulazione VHDL e gate-level

Questa cartella contiene il **Makefile** generico del corso PSEI e gli strumenti
associati per la simulazione digitale, gate-level e mixed-signal.

| File | Scopo |
|------|-------|
| `Makefile` | Simulazione RTL (GHDL), schemi Yosys, gate-level (iverilog), co-simulazione mixed-signal (Verilator + d_cosim) |
| `gl_tb_template.v` | Template testbench Verilog per simulazione gate-level SKY130A |
| `generate_sym.py` | Script Python per generare simboli xschem dalla netlist Verilog behavioral (co-simulazione) |

---

## Prerequisiti

Container IIC-OSIC-TOOLS v2025.07 con gli strumenti già nel PATH:

```bash
ghdl --version      # GHDL 6.x — simulazione RTL VHDL
yosys --version     # Yosys 0.55 — schemi RTL/sintesi + conversione VHDL→Verilog
iverilog -V         # Icarus Verilog 13 — simulazione gate-level
verilator --version # Verilator 5.038 — compilazione Verilog per co-simulazione
ngspice --version   # ngspice 44.2 — simulazione analogica + d_cosim
```

Il path di `vlnggen` (script ngspice per Verilator) non è nel PATH di default:

```bash
# Verifica presenza (deve rispondere con il path assoluto)
find /foss/tools -name "vlnggen" 2>/dev/null
# Atteso: /foss/tools/ngspice/share/ngspice/scripts/vlnggen
```

---

## Installazione

Copia il Makefile e gli script nella cartella radice del progetto:

```bash
cp /foss/designs/utils/GHDL_Digital_sim/Makefile \
   /foss/designs/<tuo_progetto>/Makefile
```

`generate_sym.py` viene usato automaticamente dal Makefile — non occorre
copiarlo manualmente. Il template `gl_tb_template.v` viene copiato da
`make setup_gl`.

Struttura attesa del progetto:

```
/foss/designs/<tuo_progetto>/
├── Makefile            ← copiato da qui
├── src/
│   ├── design.vhd      ← design under test (DUT)
│   └── design_tb.vhd   ← testbench (nome obbligatorio: *_tb.vhd)
├── xschem/             ← schemi xschem (creato manualmente)
│   ├── simulations/    ← creato da make cosim_setup (o da xschem al primo run)
│   │   ├── design_behav.v    ← Verilog behavioral (generato)
│   │   └── design_behav.so   ← shared library Verilator (generata)
│   └── design.sym      ← simbolo xschem (generato)
├── build/              ← generato da make
├── sim/                ← generato da make
├── gl/                 ← generato da make setup_gl
└── gds/                ← generato da make setup_gl
```

---

## Convenzioni automatiche

Il Makefile rileva sorgenti e top-level senza configurazione manuale:

- Cerca tutti i file `.vhd` in `src/`
- I file `*_tb.vhd` sono riconosciuti come testbench e analizzati per ultimi
- **Top-level simulazione:** il primo file `*_tb.vhd` trovato
- **Top-level schema:** `TOP` senza suffisso `_tb`
- **File intermedi:** tutti in `build/`
- **VCD RTL:** `sim/dump.vcd`
- **VCD gate-level:** `sim/dump_gl.vcd`
- **Schemi:** `build/` (`.dot` + `.pdf`)

---

## Comandi disponibili

### Simulazione RTL con GHDL

```bash
make              # analizza, elabora e simula (equivale a: make sim)
make sim          # analisi GHDL + elaborazione + simulazione
make wave         # apre GTKWave con sim/dump.vcd
make lint         # linting VHDL con GHDL (senza simulare)
make info         # mostra file trovati, top-level e parametri correnti
make clean        # rimuove build/ e sim/
make help         # elenco completo dei comandi
```

### Visualizzazione schemi (Yosys + plugin GHDL)

```bash
make rtl          # schema RTL comportamentale pre-sintesi
make fsm          # schema con estrazione esplicita della FSM
make synth_view   # schema post-sintesi con celle generiche Yosys
```

### Simulazione gate-level (iverilog + SKY130A)

Questi target richiedono che LibreLane abbia completato almeno un run nella cartella `runs/`.

```bash
make setup_gl             # prepara gl/ (netlist + template tb) e gds/
make setup_gl GL_RUN=tag  # usa un run con tag specifico (es. GL_RUN=util_40)
make lint_gl              # linting testbench Verilog con Verible
make sim_gl               # simulazione gate-level funzionale
make wave_gl              # apre GTKWave con sim/dump_gl.vcd
make clean_gl             # rimuove gl/ e gds/
```

**Workflow completo gate-level:**

```bash
# 1. (dopo librelane --flow VHDLClassic config.json)
make setup_gl
# → gl/design.pnl.v       netlist gate-level con define SKY130A embedded
# → gl/design_gl_tb.v     template testbench da completare
# → gds/design.gds        layout per KLayout
# → gds/design.mag        layout per Magic (Modulo 5)

# 2. Completa il testbench in VS Code
#    Apri gl/design_gl_tb.v e segui i passi [PASSO 1]..[PASSO 9]

# 3. Verifica e simula
make lint_gl              # → Verible segnala errori sintattici
make sim_gl               # → sim/dump_gl.vcd
make wave_gl              # → GTKWave
```

### Co-simulazione mixed-signal (Verilator + ngspice d_cosim)

Questi target implementano il flusso di co-simulazione del Modulo 5:
il design VHDL viene convertito in Verilog behavioral, compilato con
Verilator in una shared library, e integrato in xschem come blocco `d_cosim`.
ngspice simula i blocchi analogici (CDAC, comparatore Strong-ARM),
Verilator simula il controller digitale, con loop di retroazione chiuso.

```bash
make cosim_setup          # pipeline completa one-shot (passi 1+2+3)
make cosim_verilog        # solo passo 1: VHDL → Verilog behavioral
make cosim_build          # solo passo 2: Verilog → shared library .so
make cosim_sym            # solo passo 3: Verilog → simbolo xschem .sym
make clean_cosim          # rimuove i file generati dalla co-simulazione
```

**Workflow completo co-simulazione:**

```bash
# 1. Setup one-shot (da eseguire una volta, o dopo modifiche al VHDL)
make cosim_setup
# → xschem/simulations/design_behav.v    Verilog behavioral (da VHDL)
# → xschem/simulations/design_behav.so   shared library Verilator
# → xschem/design.sym                    simbolo xschem pronto all'uso

# 2. In xschem: apri o crea il testbench top-level
#    Place → Symbol → design.sym
#    Imposta l'attributo device_model sull'istanza:
#      device_model=".model ctrl d_cosim simulation=\"./design_behav.so\""
#    Aggiungi adc_bridge e dac_bridge per interfaccia analogico-digitale

# 3. Simulation → Run (ngspice lancia la co-simulazione)
#    Le forme d'onda si visualizzano direttamente in xschem

# Se il VHDL cambia: make cosim_setup di nuovo, poi ri-simulare in xschem
```

---

## Template testbench gate-level (`gl_tb_template.v`)

Il template viene copiato automaticamente in `gl/<design>_gl_tb.v` da `make setup_gl`. Contiene 9 passi numerati che guidano lo studente a:

1. Rinominare il modulo
2. Impostare `CLK_PERIOD`
3. Dichiarare i segnali (`reg` per ingressi, `wire` per uscite del DUT)
4. Gestire i wire `VPWR`/`VGND` (porte `inout` della netlist SKY130A)
5. Istanziare il DUT con tutte le porte
6. Generare il clock
7. Configurare il dump VCD
8. Scrivere i modelli di blocchi esterni con `always @(*)`
9. Scrivere la sequenza di stimoli

Una checklist finale ricorda tutti i punti da verificare prima di simulare.

> 💡 **Perché Verilog e non GHDL?** La simulazione mista VHDL+Verilog non è supportata dagli strumenti open source del container. I modelli delle celle SKY130A sono in formato Verilog e non convertibili automaticamente in VHDL. Il template Verilog è la soluzione più robusta.

---

## Script `generate_sym.py`

Genera il simbolo xschem `.sym` per la co-simulazione a partire dal Verilog
behavioral prodotto da `make cosim_verilog`. Segue il pattern di Stefan
Schippers (autore di xschem):

- **Notazione bus compatta**: `dac_p[7..0]` come pin singolo, non espanso
  bit per bit — il simbolo rimane leggibile anche con bus da 8 bit
- **Attributo `@model`**: nel `format=` del simbolo compare `@model` invece
  del path hardcoded del `.so`; il `device_model` con la riga `.model d_cosim`
  va impostato per istanza nello schema, permettendo di avere più istanze
  con librerie diverse senza duplicare il simbolo
- **Template con default**: il template dell'istanza propone
  `model=./design_behav.so` come valore di default modificabile

Invocazione diretta (normalmente eseguito da `make cosim_sym`):

```bash
python3 /foss/designs/utils/GHDL_Digital_sim/generate_sym.py \
    xschem/simulations/sar_controller_behav.v \
    xschem/sar_controller.sym
```

---

## Visualizzazione schemi

### `make rtl` — Schema RTL comportamentale

Mostra il design come descritto nel VHDL: flip-flop, mux e registri come primitivi astratti. Utile per verificare la struttura generale prima della sintesi.

### `make fsm` — Schema con estrazione FSM

Yosys tenta di individuare il registro di stato e rappresentarlo come nodo FSM compatto. Nei design ASIC-style con reset asincrono (`$adff`) produce lo stesso schema di `make rtl` — `fsm_detect` non riconosce i flip-flop con reset asincrono.

> ⚠️ Il registro di stato non deve avere inizializzazione esplicita:
> ```vhdl
> signal state : state_t;              -- ASIC: corretto
> signal state : state_t := ST_RESET;  -- FPGA: non funziona con make fsm
> ```

### `make synth_view` — Schema post-sintesi

Yosys mappa il design su AND, OR, NOT e DFF elementari. Più dettagliato di `make fsm`, rappresenta più fedelmente la logica che verrà implementata in silicio.

### Limiti pratici

| Design | `make rtl` | `make fsm` | `make synth_view` |
|--------|-----------|-----------|------------------|
| FF singolo, mux semplice | ✅ Ottimo | — | ✅ Ottimo |
| FSM 3–5 stati, uscite semplici | ✅ Leggibile | ✅ Ottimo | ✅ Leggibile |
| FSM 10+ stati con bus larghi | ❌ Inutilizzabile | ✅ Utile | ❌ Inutilizzabile |

---

## Co-simulazione — dettagli tecnici

### Perché non si usa iverilog per la co-simulazione

Icarus Verilog nel container IIC-OSIC-TOOLS v2025.07 è compilato in modalità
standard: produce script VVP interpretati da `vvp`, non shared library. La
modalità `ivlng` di ngspice richiede invece che Icarus sia compilato con
`--enable-libvvp`, opzione non presente. Si usa quindi Verilator, disponibile
al path `/foss/tools/bin/verilator` (versione 5.038).

### `make cosim_verilog` — VHDL → Verilog behavioral

Usa lo stesso plugin GHDL di Yosys già sfruttato da `make rtl`, fermandosi
al passo `proc` (conversione processi comportamentali) senza procedere alla
tech-mapping su celle standard. Il Verilog risultante è leggibile da Verilator,
che lo compila in C++ e poi in shared library.

```bash
yosys -m ghdl -p "ghdl --std=08 src/design.vhd -e design; proc; write_verilog ..."
```

### `make cosim_build` — Verilog → shared library

Invoca `vlnggen` tramite ngspice come interprete di script. Il comando deve
essere eseguito dalla cartella dove si vuole il `.so` (convenzione di vlnggen):

```bash
cd xschem/simulations && ngspice /foss/tools/ngspice/share/ngspice/scripts/vlnggen \
    design_behav.v
# → produce design_behav.so nella cartella corrente
```

Il `.so` deve trovarsi nella cartella `simulations/` che xschem crea
automaticamente quando esegue una simulazione, in modo che il path relativo
`./design_behav.so` nel `device_model` sia valido.

### Interfaccia analogico-digitale in xschem

La co-simulazione richiede componenti bridge per convertire tra il dominio
SPICE (tensioni continue) e il dominio digitale (valori logici 0/1). Nel
corso PSEI si usano i bridge del corso IHP Analog Academy, adattati ai
livelli di tensione SKY130A (VDD = 1.8 V):

| Componente | Uso | Parametri SKY130A |
|---|---|---|
| `adc_bridge_sky130.sym` | Segnale analogico → logica digitale (es. `comp_out`) | `in_low=0.7  in_high=1.1` |
| `dac_bridge_sky130.sym` | Logica digitale → segnale analogico (es. `dac_p[i]`) | `out_low=0   out_high=1.8` |

Ogni uscita bus del controller (`dac_p[7..0]` e `dac_n[7..0]`) richiede un
`dac_bridge` separato — in tutto 16 istanze bridge per i segnali di controllo
del CDAC.

---

## Simulazione gate-level — dettagli

### `make setup_gl`

Individua l'ultimo run LibreLane in `runs/` e:

1. Copia `runs/.../final/pnl/*.pnl.v` → `gl/` — aggiunge automaticamente le 5 righe di define/include SKY130A in testa alla netlist (approccio di Matt Venn):
   ```verilog
   `define UNIT_DELAY #1
   `define FUNCTIONAL
   `define USE_POWER_PINS
   `include ".../primitives.v"
   `include ".../sky130_fd_sc_hd.v"
   ```
2. Copia `gl_tb_template.v` → `gl/<design>_gl_tb.v`
3. Copia `runs/.../final/gds/*.gds` → `gds/`
4. Copia `runs/.../final/mag/*.mag` → `gds/` (se presente)

Per usare un run con tag specifico: `make setup_gl GL_RUN=util_40`

### `make sim_gl`

Compila con `iverilog -g2012 -I $(PDK_ROOT)/sky130A` e simula con `vvp`. La netlist è autocontenuta — non servono flag `-D` aggiuntivi. Produce `sim/dump_gl.vcd`.

---

## Parametri override da riga di comando

| Parametro | Default | Significato |
|-----------|---------|-------------|
| `TOP` | nome del file `*_tb.vhd` | top-level per la simulazione RTL |
| `DUT` | `TOP` senza suffisso `_tb` | top-level per schemi, gate-level e co-simulazione |
| `STOP_TIME` | `100us` | tempo di stop della simulazione RTL |
| `STD` | `--std=08` | standard VHDL |
| `GL_RUN` | *(vuoto = ultimo run)* | tag del run LibreLane da usare |
| `COSIM_DIR` | `xschem/simulations` | cartella per `.v` e `.so` della co-simulazione |
| `XSCHEM_DIR` | `xschem` | cartella per il simbolo `.sym` generato |
| `GEN_SYM` | `/foss/designs/utils/GHDL_Digital_sim/generate_sym.py` | path assoluto di `generate_sym.py` |

```bash
make STOP_TIME=500ns
make setup_gl GL_RUN=util_40
make DUT=altro_modulo rtl
make cosim_setup COSIM_DIR=sim/cosim XSCHEM_DIR=schemi
```

---

## Struttura delle cartelle dopo tutti i target

```
/foss/designs/<tuo_progetto>/
├── Makefile
├── src/
│   ├── design.vhd
│   └── design_tb.vhd
├── xschem/                              ← schemi xschem (cartella manuale)
│   ├── design.sym                       ← make cosim_sym
│   ├── simulations/                     ← make cosim_setup / xschem auto-crea
│   │   ├── design_behav.v               ← make cosim_verilog
│   │   └── design_behav.so              ← make cosim_build
│   └── top_tb.sch                       ← schema testbench mixed-signal
├── build/                               ← make sim / make rtl / ...
│   ├── design_tb                        ← eseguibile GHDL
│   ├── rtl_design.dot + .pdf
│   ├── fsm_design.dot + .pdf
│   ├── synth_design.dot + .pdf
│   └── sim_gl                           ← eseguibile iverilog gate-level
├── sim/
│   ├── dump.vcd                         ← forme d'onda RTL
│   └── dump_gl.vcd                      ← forme d'onda gate-level
├── gl/
│   ├── design.pnl.v                     ← netlist gate-level SKY130A
│   └── design_gl_tb.v                   ← testbench Verilog (da completare)
└── gds/
    ├── design.gds                       ← layout per KLayout
    └── design.mag                       ← layout per Magic (Modulo 5)
```

---

## Note tecniche — fasi di GHDL

```bash
ghdl -a --std=08 --workdir=build src/design.vhd       # analisi
ghdl -e --std=08 --workdir=build -o build/design_tb design_tb  # elaborazione
build/design_tb --vcd=sim/dump.vcd --stop-time=100us   # simulazione
```

---

## Riferimenti

- [GHDL — documentazione ufficiale](https://ghdl.github.io/ghdl/)
- [GTKWave — manuale](http://gtkwave.sourceforge.net/gtkwave.pdf)
- [Yosys — documentazione](https://yosyshq.readthedocs.io/projects/yosys/)
- [Icarus Verilog — documentazione](https://steveicarus.github.io/iverilog/)
- [VHDL-2008 — IEEE Std 1076-2008](https://ieeexplore.ieee.org/document/4772740)
- [ngspice d_cosim — esempi xschem](https://xschem.sourceforge.io/stefan/pg_Installing_xschem.html)
- [Verilator — documentazione ufficiale](https://verilator.org/guide/latest/)
