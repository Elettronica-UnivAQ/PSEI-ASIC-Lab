# mag_scripts — Script per il flusso layout analogico SKY130A

Questa cartella contiene il Makefile e gli script Tcl per automatizzare
le operazioni principali del flusso di layout analogico nel corso PSEI.
Progettata per essere usata identica dal Modulo 3 al Modulo 6 (TinyTapeout)
— nessuna sostituzione di file tra moduli, solo funzionalità aggiuntive
che si attivano quando servono.

Adattata dall'approccio di Matt Venn per i progetti analogici TinyTapeout.

## Come usarla

**Copia questa cartella nella tua cartella `mag/` del progetto:**

```bash
cp -r utils/mag_scripts/ /foss/designs/mio_progetto/mag/
```

Struttura risultante:

```
mio_progetto/
└── mag/
    ├── mia_cella.mag
    ├── Makefile
    └── tcl/
        ├── extract_for_lvs.tcl
        ├── extract_for_sim.tcl
        ├── lvs_netgen.tcl
        ├── drc.tcl
        ├── antenna.tcl
        ├── update_gds_lef.tcl
        └── tt_analog_setup.tcl
```

## Configurazione

Modifica le prime due variabili nel Makefile oppure passale da riga di comando:

```bash
# Nel Makefile (modifica una volta per progetto):
PROJECT_NAME    ?= buffer
SCHEMATIC_SPICE ?= ../xschem/simulation/buffer.spice

# Oppure da riga di comando:
make lvs PROJECT_NAME=buffer SCHEMATIC_SPICE=../xschem/simulation/buffer.spice
```

## Target disponibili

| Comando | Quando usarlo | Modulo |
|---|---|---|
| `make magic` | Apre Magic con la cella del progetto | 3, 5, 6 |
| `make drc` | DRC completo in batch | 3, 5, 6 |
| `make antenna` | Verifica antenna rule violations | 3*, 5*, 6 |
| `make lvs` | Estrazione LVS + confronto Netgen | 3, 5, 6 |
| `make pex` | Estrazione post-layout con parassitici R+C | 3, 5, 6 |
| `make update_gds` | Esporta GDS e LEF per il tapeout | 6 |
| `make start` | Inizializza tile TinyTapeout | 6 |
| `make clean` | Rimuove file intermedi e generati (non `.mag`, non GDS/LEF) | 3, 5, 6 |

*Introdotto nel Modulo 3, approfondito nel Modulo 6.

## Script Tcl — descrizione

### `extract_for_lvs.tcl`
Estrae la netlist topologica (senza parassitici) per il confronto LVS.
Produce `NOME.lvs.spice`. Comandi chiave:
- `extract do local` — scrive i `.ext` nella cartella corrente
- `extract unique notopports` — evita collisioni di nomi tra celle figlie
- `ext2spice short resistor` — modella i cortocircuiti come resistori
- `ext2spice -d` — elimina i device non connessi

### `extract_for_sim.tcl`
Estrae la netlist post-layout con parassitici R+C per simulazione ngspice.
Produce `NOME.sim.spice` (subckt rinominato `NOME_parax`). Usa il flusso
completo con `extresist` per **resistenze distribuite** (più accurato delle
resistenze lumped per simulazione analogica SPICE):
`extract all` → `ext2sim` → `extresist` → `ext2spice extresist on`

### `lvs_netgen.tcl`
Esegue il confronto Netgen tra la netlist estratta e quella schematica.
Produce `lvs.report`. Usa il pattern `readnet spice /dev/null` per
costruire il database source in modo incrementale — supporta questi scenari:

**Scenario 1 — Design analogico standalone** (Moduli 3 e 5):
```tcl
# Basta la netlist top-level — le subcelle sono già incluse in buffer.spice
# perché xschem le incorpora automaticamente nella netlist LVS del top-level
readnet spice $schematic $source
```

**Scenario 2 — Design multi-blocco** (subcelle con netlist separate):
Serve quando il top-level istanzia subcelle le cui netlist NON sono incluse
automaticamente (IP esterni, subcelle aggiunte manualmente nel layout):
```tcl
readnet spice ../xschem/simulation/ota.spice $source
readnet spice ../xschem/simulation/comparatore.spice $source
readnet spice $schematic $source
```

**Scenario 3 — TinyTapeout analogico** (Modulo 6):
Su TinyTapeout il top-level è **sempre** un file `project.v` — anche per
progetti puramente analogici. È uno stub Verilog obbligatorio che definisce
l'interfaccia standard TT e istanzia i blocchi analogici custom. Il Verilog
non descrive la topologia interna dei blocchi analogici, quindi vanno caricati
separatamente come SPICE. Non servono le celle digitali se il progetto è
puramente analogico.
```tcl
# Blocchi analogici custom istanziati nel project.v
readnet spice ../xschem/simulation/osc.spice $source
readnet spice ../xschem/simulation/vfollower.spice $source
# Stub Verilog top-level obbligatorio TinyTapeout
readnet verilog ../src/project.v $source
```

**Scenario 4 — TinyTapeout mixed signal** (Modulo 6):
Come lo scenario 3, ma `project.v` contiene anche logica digitale con celle
standard `sky130_fd_sc_hd` — vanno caricate come SPICE di riferimento:
```tcl
# Celle digitali standard SKY130A
readnet spice $PDK_ROOT/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice $source
# Blocchi analogici custom
readnet spice ../xschem/simulation/mio_blocco_analogico.spice $source
# Stub Verilog top-level
readnet verilog ../src/project.v $source
```

### `drc.tcl`
DRC completo in batch con stile `drc(full)`. Stampa conteggio totale e
dettaglio per tipo di regola violata.

### `antenna.tcl`
Verifica le antenna rule violations: durante la fabbricazione, fili metallici
lunghi connessi a gate MOSFET accumulano carica elettrostatica che può
danneggiare il gate oxide. Il PDK definisce un rapporto massimo tra l'area
del filo e l'area del gate (PAR). Introdotto nel Modulo 3, approfondito
nel Modulo 6 prima del tapeout.

### `update_gds_lef.tcl`
Esporta il layout per la submission al tapeout:
- **GDS** (`../gds/`): inviato alla foundry per la fabbricazione
- **LEF** (`../lef/`): blackbox con solo i pin, per i tool di P&R

### `tt_analog_setup.tcl`
Inizializza un tile analogico TinyTapeout a partire dal template `.def`
(160 × 225.76 µm per il tile 1×2). Disegna le power stripe obbligatorie
in `met4` (VDPWR e VGND). Usato solo nel Modulo 6.

## `make clean` — file rimossi

```
lvs.report          ← report Netgen
*.lvs.spice         ← netlist LVS estratta
*.sim.spice         ← netlist PEX estratta
*.fb.txt            ← warning di estrazione
*.ext               ← file intermedi Magic
*.sim               ← file intermedi ext2sim
*.nodes             ← file intermedi extresist
```

**Non vengono rimossi:** i file `.mag`, il `.gds` nella cartella locale,
i file nelle cartelle `../gds/` e `../lef/`.

## Esempio completo di utilizzo

```bash
# Copia gli script nella cartella mag/ del progetto
cp -r utils/mag_scripts/ /foss/designs/modulo3/lab03/mag/

cd /foss/designs/modulo3/lab03/mag

# Configura il Makefile (o passa le variabili da riga di comando)
# PROJECT_NAME    ?= buffer
# SCHEMATIC_SPICE ?= ../xschem/simulation/buffer.spice

# 1. Apri Magic per il layout
make magic

# 2. Verifica DRC
make drc

# 3. Verifica LVS (estrazione + Netgen)
make lvs

# 4. Estrai parassitici per simulazione post-layout
make pex

# 5. Pulizia file intermedi
make clean

# Per un progetto diverso senza modificare il Makefile:
make lvs PROJECT_NAME=strongarm          SCHEMATIC_SPICE=../xschem/simulation/strongarm.spice
```

## LVS in due passi — Modulo 6 (TinyTapeout)

Nel Modulo 6 il LVS si esegue in due passi distinti con obiettivi diversi:

**Passo 1 — LVS di design** (come nei Moduli 3 e 5):
Verifica che il layout del tuo blocco corrisponda allo schematico.
Usa lo Scenario 1 in `lvs_netgen.tcl` (solo netlist SPICE del blocco).

```bash
make lvs PROJECT_NAME=mio_blocco          SCHEMATIC_SPICE=../xschem/simulation/mio_blocco.spice
```

**Passo 2 — LVS di integrazione** (specifico TinyTapeout):
Verifica che i pin del tuo blocco siano correttamente connessi ai pin
del wrapper TinyTapeout (`ua[0]`, `uo_out[0]`, `VPWR`, `VGND` ecc.).
Usa lo Scenario 3 (o 4) in `lvs_netgen.tcl`, con `project.v` come top-level.

```bash
make lvs PROJECT_NAME=tt_um_mio_progetto
# (schematic = project.v, configurato nello Scenario 3 di lvs_netgen.tcl)
```

I due passi catturano errori diversi:
- **Passo 1**: filo mancante nel routing, W/L sbagliato, cortocircuito interno
- **Passo 2**: pin invertiti, alimentazione errata, `ua[0]` invece di `ua[1]`, net non connessa al wrapper

Se il Passo 1 è PASS, il Passo 2 è spesso PASS automaticamente — ma
non sempre. Errori di integrazione come un pin analogico connesso al net
sbagliato nel `project.v` superano il Passo 1 e vengono catturati solo dal Passo 2.

---

## Crediti

Gli script in `tcl/` sono stati adattati dal lavoro di [Matt Venn](https://github.com/mattvenn), in particolare dal progetto [ttsky25b-analog-relax-oscillator](https://github.com/mattvenn/ttsky25b-analog-relax-oscillator) pubblicato per TinyTapeout. I file originali sono rilasciati sotto licenza **Apache-2.0** (Copyright © Tiny Tapeout LTD). Le modifiche rispetto agli originali riguardano principalmente la parametrizzazione via `argv`, la generalizzazione per supportare più scenari di progetto e l'aggiunta di commenti in italiano.

## Note

- Tutti gli script vanno avviati dalla cartella `mag/` del progetto
- I file `.ext` intermedi vengono rimossi automaticamente dal Makefile
- La netlist schematica deve essere generata da xschem con
  **Simulation → LVS netlist: Top level is a `.subckt`** attiva
- `make lvs` dipende da `$(PROJECT_NAME).lvs.spice` — se il file è già
  presente e il `.mag` non è cambiato, Make non rigenera l'estrazione
