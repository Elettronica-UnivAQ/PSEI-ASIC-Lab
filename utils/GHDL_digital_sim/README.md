# GHDL Digital Sim — Makefile per simulazione e visualizzazione VHDL

Questa cartella contiene un `Makefile` generico per la compilazione, simulazione e visualizzazione di design VHDL con **GHDL** e **Yosys** nel container IIC-OSIC-TOOLS.

---

## Prerequisiti

- Container IIC-OSIC-TOOLS v2025.07 avviato e funzionante
- File sorgenti VHDL nella sottocartella `src/` del progetto

Verifica che gli strumenti siano disponibili:

```bash
ghdl --version    # atteso: GHDL 4.x.x o superiore
yosys --version   # atteso: Yosys 0.x (per make rtl / fsm / synth_view)
```

---

## Installazione

Copia il Makefile nella cartella radice del progetto:

```bash
cp /foss/designs/utils/GHDL_Digital_sim/Makefile \
   /foss/designs/<tuo_progetto>/Makefile
```

Struttura attesa del progetto:

```
/foss/designs/<tuo_progetto>/
├── Makefile            ← copiato da qui
└── src/
    ├── design.vhd      ← design under test (DUT)
    └── design_tb.vhd   ← testbench (nome obbligatorio: *_tb.vhd)
```

---

## Convenzioni automatiche

Il Makefile rileva sorgenti e top-level senza configurazione manuale:

- Cerca tutti i file `.vhd` in `src/`
- I file `*_tb.vhd` sono riconosciuti come testbench e analizzati per ultimi
- **Top-level simulazione:** il primo file `*_tb.vhd` trovato (es. `design_tb`)
- **Top-level schema:** `TOP` senza suffisso `_tb` (es. `design`)
- **File intermedi** (`.o`, `.cf`, eseguibile): tutti in `build/`
- **File VCD:** in `sim/dump.vcd`
- **File schemi:** in `build/` (`.dot` + `.pdf`)

---

## Comandi disponibili

```bash
# Simulazione
make              # analizza, elabora e simula (equivale a: make sim)
make sim          # analisi GHDL + elaborazione + simulazione
make wave         # apre GTKWave con il VCD prodotto
make info         # mostra file trovati, top-level e parametri correnti
make clean        # rimuove build/ e sim/
make help         # elenco comandi con i valori correnti dei parametri

# Visualizzazione schemi (richiede Yosys + plugin GHDL)
make rtl          # schema RTL comportamentale pre-sintesi
make fsm          # schema con estrazione esplicita della FSM
make synth_view   # schema post-sintesi con celle generiche Yosys
```

---

## Visualizzazione schemi

Il Makefile integra Yosys con il plugin GHDL per generare schemi del design direttamente dal codice VHDL. Ogni target salva un file `.dot` e un `.pdf` in `build/` e apre xdot in modo interattivo (rotella = zoom, click+drag = pan).

### `make rtl` — Schema RTL comportamentale

Mostra il design come descritto nel VHDL: flip-flop, mux e registri come primitivi astratti (`$adff`, `$pmux`). Utile per verificare la struttura generale del design prima della sintesi.

### `make fsm` — Schema con estrazione FSM

In teoria, Yosys individua il registro di stato e lo rappresenta come un **nodo FSM compatto** con gli archi di transizione esplicitati. In pratica, produce lo stesso schema di `make rtl` nei design ASIC-style perché `fsm_detect` non riconosce i flip-flop con **reset asincrono** (`$adff`) come registri di stato FSM — funziona solo con reset sincrono (`$dff`).

Poiché il reset asincrono è la scelta corretta per ASIC (e per la sintesi SKY130A), questo è un limite strutturale nel contesto di questo corso. Il target rimane nel Makefile come strumento generico — potrebbe dare risultati diversi su design con reset sincrono o con tool chain diverse.

La sequenza di passate è `proc → opt → fsm_detect → fsm_extract → fsm_opt → show`, che si ferma prima di `fsm_map` (quella passata rimapperebbe l'eventuale nodo FSM in logica elementare, rendendo lo schema identico a `make rtl`).

> ⚠️ **Requisito ASIC per `make fsm`:** il registro di stato non deve avere inizializzazione esplicita. Yosys `fsm_detect` non riconosce come FSM un segnale dichiarato con `:= valore_iniziale`.
>
> ```vhdl
> -- FPGA (non funziona con make fsm):
> signal state : state_t := ST_RESET;
>
> -- ASIC corretto (funziona con make fsm):
> signal state : state_t;   -- reset gestito da if rst_n = '0'
> ```
>
> Questa distinzione è anche architetturalmente corretta: su ASIC i flip-flop non hanno un valore di power-on garantito — lo stato iniziale deve essere imposto esclusivamente dal segnale di reset.

### `make synth_view` — Schema post-sintesi

Yosys ottimizza il design e lo mappa su AND, OR, NOT e DFF elementari. Più dettagliato di `make fsm`, rappresenta più fedelmente la logica che verrà implementata in silicio. Diverso dalla sintesi SKY130A di LibreLane: qui si usano celle generiche per una visualizzazione più leggibile.

### Limiti pratici

L'utilità degli schemi dipende dalla dimensione del design:

| Design | `make rtl` | `make fsm` | `make synth_view` |
|--------|-----------|-----------|------------------|
| Inverter, FF singolo | ✅ Ottimo | — | ✅ Ottimo |
| FSM 3–5 stati, uscite semplici | ✅ Leggibile | ✅ Ottimo | ✅ Leggibile |
| FSM 10+ stati con bus di uscita largo | ❌ Inutilizzabile | ✅ Utile | ❌ Inutilizzabile |

Per design con molti stati e bus di uscita larghi (es. un SAR controller a 8 bit), `make fsm` è l'unico target che produce uno schema leggibile.

---

## Parametri override da riga di comando

| Parametro | Default | Significato |
|-----------|---------|-------------|
| `TOP` | nome del file `*_tb.vhd` | top-level per la simulazione |
| `DUT` | `TOP` senza suffisso `_tb` | top-level per gli schemi Yosys |
| `STOP_TIME` | `100us` | tempo di stop della simulazione |
| `STD` | `--std=08` | standard VHDL |

```bash
make STOP_TIME=500ns
make TOP=altro_tb STOP_TIME=2us
make DUT=altro_modulo rtl
make STD=--std=93
```

---

## Struttura delle cartelle dopo `make`

```
/foss/designs/<tuo_progetto>/
├── Makefile
├── src/
│   ├── design.vhd
│   └── design_tb.vhd
├── build/                      ← generato da make
│   ├── design.o
│   ├── design_tb.o
│   ├── work-obj08.cf
│   ├── design_tb               ← eseguibile di simulazione
│   ├── rtl_design.dot          ← schema RTL (make rtl)
│   ├── rtl_design.pdf
│   ├── fsm_design.dot          ← schema FSM (make fsm)
│   ├── fsm_design.pdf
│   ├── synth_design.dot        ← schema post-sintesi (make synth_view)
│   └── synth_design.pdf
└── sim/                        ← generato da make
    └── dump.vcd                ← forme d'onda per GTKWave
```

---

## Gestione della gerarchia

Per design a due livelli (DUT + testbench) il rilevamento automatico funziona sempre. Per gerarchie più profonde, crea un Makefile locale che include quello generico e sovrascrive `SRCS` con l'ordine esplicito (dal livello più basso al più alto):

```makefile
include /foss/designs/utils/GHDL_Digital_sim/Makefile

SRCS = src/alu.vhd        \
       src/datapath.vhd   \
       src/controller.vhd \
       src/top.vhd        \
       src/top_tb.vhd
```

---

## Note tecniche — fasi di GHDL

```bash
ghdl -a --std=08 --workdir=build src/design.vhd   # analisi
ghdl -e --std=08 --workdir=build -o build/design_tb design_tb  # elaborazione
build/design_tb --vcd=sim/dump.vcd --stop-time=100us            # simulazione
```

La gerarchia viene risolta nella fase `-e`: GHDL cerca nella libreria `work` tutte le entità istanziate. L'unico requisito è che ogni entità venga analizzata prima di chi la istanzia — garantito dall'ordine DUT-prima-TB del Makefile.

---

## Caratteri validi nelle stringhe VHDL

VHDL accetta solo caratteri Latin-1 (ISO 8859-1) nei messaggi `report`/`assert`. Usa sempre trattino corto `-` (non `—`), virgolette ASCII `"` (non `"` `"`) e lettere non accentate.

---

## Riferimenti

- [GHDL — documentazione ufficiale](https://ghdl.github.io/ghdl/)
- [GTKWave — manuale](http://gtkwave.sourceforge.net/gtkwave.pdf)
- [Yosys — documentazione](https://yosyshq.readthedocs.io/projects/yosys/)
- [VHDL-2008 — IEEE Std 1076-2008](https://ieeexplore.ieee.org/document/4772740)
