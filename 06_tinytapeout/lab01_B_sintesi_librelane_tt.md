# Lab 01-B — Sintesi LibreLane VHDLClassic per il tile TinyTapeout

## Obiettivo

Configurare `rtl/config.json` per il tile TinyTapeout (con i vincoli fissi dettati dall'infrastruttura TT), eseguire la sintesi LibreLane VHDLClassic localmente, copiare il gate-level Verilog in `src/` e committarlo nel repository.

---

## Prerequisiti di questo lab

- Lab00-B completato: repository clonato, `.gitignore` configurato, `info.yaml` e documentazione compilati
- Design VHDL scritto e verificato con GHDL e il testbench VHDL (come nel Modulo 4)
- I file `.vhd` sorgenti sono in `rtl/src/`

> ⚠️ La sintesi TinyTapeout si basa sul design VHDL già validato. Se il testbench VHDL non passa, non procedere alla sintesi — gli errori logici non vengono corretti da LibreLane.

---

## Parte 1 — Il `config.json` per il tile TinyTapeout

### 1.1 Differenze rispetto al Modulo 4

Nel Modulo 4 hai configurato LibreLane con piena libertà: `DIE_AREA`, `FP_PIN_ORDER_CFG` e le constraint sui pin erano tuoi da definire. Nel contesto TinyTapeout queste variabili sono **fisse** — determinate dall'infrastruttura del tile e dal wrapper TT. Non vanno modificate.

| Parametro | Modulo 4 (standalone) | Modulo 6 (TinyTapeout) |
|---|---|---|
| `DIE_AREA` | libero, definito da te | fisso dal template TT |
| `FP_PIN_ORDER_CFG` | `pin_order.cfg` personalizzato | non necessario, pin gestiti da TT |
| `DESIGN_NAME` | qualsiasi | deve iniziare con `tt_um_` |
| `CLOCK_PORT` | libero | deve corrispondere al pin clock del wrapper TT |

### 1.2 Template `rtl/config.json`

Il template TinyTapeout digital include già un `config.json` pre-configurato. Se non è presente, crealo in `rtl/` con questa struttura:

```json
{
    "DESIGN_NAME": "tt_um_psei_NOME",

    "VHDL_FILES": [
        "rtl/src/mio_design.vhd"
    ],

    "CLOCK_PORT": "clk",
    "CLOCK_PERIOD": 50.0,

    "PL_TARGET_DENSITY": 0.65,

    "SYNTH_STRATEGY": "AREA 0",
    "SYNTH_MAX_FANOUT": 10
}
```

> ⚠️ `DESIGN_NAME` deve iniziare con `tt_um_` e corrispondere esattamente al nome del modulo in `src/project.v` e al valore `top_module` in `info.yaml`. Verifica questo vincolo prima di lanciare la sintesi.

> ⚠️ `DIE_AREA` e le constraint sui pin **non vanno aggiunte** al `config.json`: sono già impostate nel template del tile TT. Aggiungere valori diversi causa DRC o LVS failures nelle GitHub Actions.

> 💡 `PL_TARGET_DENSITY` (default ~0.5–0.6) può essere aumentata fino a ~0.70 se il design è grande e il placement fallisce per mancanza di spazio. Valori superiori a 0.75 causano problemi di routing. Se il design proprio non entra in un tile 1×2, la soluzione corretta è acquistare un secondo tile (`tiles: 2` in `info.yaml`) — non forzare la densità.

### 1.3 Elenco file VHDL

Assicurati che `VHDL_FILES` elenchi tutti i file sorgente del tuo design nell'ordine corretto (le entità usate per prime devono essere dichiarate per prime):

```json
"VHDL_FILES": [
    "rtl/src/pkg_costanti.vhd",
    "rtl/src/mio_design.vhd"
]
```

> ⚠️ I path in `VHDL_FILES` sono **relativi alla root del repository** (non a `rtl/`). Se il file è in `rtl/src/mio_design.vhd`, il path corretto è `"rtl/src/mio_design.vhd"` — non `"src/mio_design.vhd"`.

---

## Parte 2 — Sintesi locale

### 2.1 Avvia LibreLane VHDLClassic

```bash
cd /foss/designs/modulo6/tt_um_psei_NOME/rtl
librelane --flow VHDLClassic config.json
```

La sintesi dura tipicamente 2–5 minuti per design della complessità del SAR controller. Il log mostra le fasi in sequenza: synthesis (GHDL+Yosys), floorplan, placement, CTS, routing, signoff.

> 💡 Se LibreLane stampa errori nella fase `synthesis`, il problema è quasi sempre nel VHDL — un'entità non trovata, un tipo incompatibile, o un costrutto non sintetizzabile. Risolvi prima con GHDL in locale (`make sim`), poi rilancia la sintesi.

### 2.2 Leggi i report di timing e area

Al termine della sintesi, i report principali si trovano in `rtl/runs/RUN_*/`:

```bash
# Timing — verifica che WNS (Worst Negative Slack) sia >= 0
cat runs/RUN_*/logs/signoff/sta.log | grep "WNS"

# Area — numero di celle standard e area totale
cat runs/RUN_*/reports/synthesis/*/areaReport.txt 2>/dev/null | head -30

# Routing — verifica assenza di DRC violations nel routing
cat runs/RUN_*/logs/routing/*.log | grep -i "violation" | tail -10
```

**WNS (Worst Negative Slack):** `?` ns — deve essere ≥ 0. Se negativo, il design non rispetta il timing richiesto: aumenta `CLOCK_PERIOD` o ottimizza il VHDL.

**Numero totale di celle standard:** `?`

**Area totale del design:** `?` µm²

> ⚠️ Un WNS negativo non blocca LibreLane (la sintesi termina ugualmente), ma il chip potrebbe non funzionare alla frequenza impostata. Il messaggio nelle Actions TinyTapeout "timing not met" deriva da questo — correggi prima di committare il gate-level.

### 2.3 Visualizza il layout (opzionale)

```bash
openroad -gui runs/RUN_*/final/odb/tt_um_psei_NOME.odb
```

La GUI OpenROAD mostra il placement delle celle, il routing e la congestion map. Utile per capire se il design è troppo compatto (`PL_TARGET_DENSITY` troppo alta) o se ci sono problemi di routing localizzati.

---

## Parte 3 — Copia del gate-level in `src/`

### 3.1 Usa `make setup_gl`

Il Makefile VHDL in `rtl/` include il target `make setup_gl` che copia il gate-level dall'output di LibreLane alla cartella `rtl/gl/`:

```bash
cd rtl/
make setup_gl
```

Verifica che il file sia presente:

```bash
ls -lh rtl/gl/tt_um_psei_NOME.v
```

### 3.2 Copia il gate-level in `src/`

```bash
cp rtl/gl/tt_um_psei_NOME.v src/
```

Questo file è la **netlist gate-level** generata da LibreLane: contiene le istanze delle celle standard `sky130_fd_sc_hd` cablate secondo la logica del tuo design VHDL. Le GitHub Actions di TinyTapeout useranno questo file per il GDS action e per il test cocotb.

> ⚠️ Non modificare `src/tt_um_psei_NOME.v` manualmente — è un file generato. Se devi apportare correzioni al design, modifica il VHDL in `rtl/src/`, rilancia la sintesi e riesegui la copia.

---

## Parte 4 — Commit del gate-level

```bash
cd /foss/designs/modulo6/tt_um_psei_NOME

git add src/tt_um_psei_NOME.v
git add rtl/config.json
git add rtl/gl/tt_um_psei_NOME.v

git commit -m "feat: add synthesized gate-level (LibreLane VHDLClassic, WNS=? ns)"
git push
```

> 💡 Includi il WNS nel messaggio di commit — è utile per tracciare la storia delle sintesi nei commit successivi.

---

## Domande di riflessione

1. Qual è il WNS del tuo design alla frequenza di clock impostata? `?` ns
2. Quante celle standard utilizza il design sintetizzato? `?`
3. L'area del gate-level rientra nel tile 1×2 (160 × 225.76 µm)? Come lo verifichi dai report? `?`

Procedi al [Lab02-B](./lab02_B_projectv_cocotb.md).
