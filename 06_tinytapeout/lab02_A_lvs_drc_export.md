# Lab 02-A — LVS di integrazione, DRC, antenna check e export GDS/LEF

## Obiettivo

Verificare la correttezza del layout integrato con LVS a due passi, eseguire il DRC completo e l'antenna check, esportare GDS e LEF, e preparare il repository per le GitHub Actions.

---

## Prerequisiti di questo lab

- Lab01-A completato: tile Magic con i blocchi posizionati e connessi, `src/project.v` aggiornato
- Netlist schematica del blocco analogico disponibile in `xschem/simulation/` (generata da xschem con **Simulation → LVS netlist: Top level is a `.subckt`** attiva)

---

## Parte 1 — LVS Passo 1: verifica del blocco analogico standalone

Il Passo 1 verifica che il **layout del tuo blocco analogico** corrisponda allo **schematico xschem**. È identico al LVS eseguito nel Modulo 3 — stesso script, stessa procedura.

```bash
cd /foss/designs/modulo6/tt_um_psei_NOME/mag
make lvs PROJECT_NAME=mio_blocco_analogico \
         SCHEMATIC_SPICE=../xschem/simulation/mio_blocco_analogico.spice
```

> 💡 L'override `PROJECT_NAME=mio_blocco_analogico` da riga di comando è necessario qui perché il Makefile ha `PROJECT_NAME` impostato su `tt_um_psei_NOME` (il tile completo). Lo stesso pattern è usato nel Modulo 3 per eseguire il LVS su celle singole senza modificare il Makefile.

Lo script `lvs_netgen.tcl` usa il **Scenario 1** (singolo blocco): legge solo la netlist schematica del blocco senza caricare il Verilog di integrazione.

Leggi il report prodotto:

```bash
cat lvs.report | grep -A 5 "Final"
```

**Risultato del LVS Passo 1:** `MATCH` / `MISMATCH` → `?`

Se il risultato è `MISMATCH`, non procedere al Passo 2. Gli errori più comuni sono:

- Net con nome sbagliato nel layout (seleziona il net con `s`, digita `what`)
- Pin mancante nel layout (controlla che tutti i pin dello schematico abbiano una label nel layout)
- Transistor con W/L errato (verifica le dimensioni delle pcell)

<details>
<summary>Come leggere il report LVS di Netgen</summary>

Il report `lvs.report` contiene una serie di sezioni. Le più importanti:

```
Subcircuit summary:
Circuit 1: mio_blocco_analogico     Circuit 2: mio_blocco_analogico
...
Netlists match uniquely.
```
significa PASS. Se compaiono righe come:
```
Unmatched pins: ...
Device error: ...
```
significa MISMATCH — leggi quali pin o device non corrispondono.

Il numero di linee di output può essere grande. Filtra con:
```bash
grep -E "match|MATCH|error|ERROR|Unmatched" lvs.report
```

</details>

---

## Parte 2 — LVS Passo 2: verifica dell'integrazione top-level

Il Passo 2 verifica che i pin del tuo blocco siano correttamente connessi al wrapper TinyTapeout. Usa `src/project.v` come riferimento del top-level.

Questo passo richiede di modificare `mag/tcl/lvs_netgen.tcl` per usare lo **Scenario 3** (progetto TT analogico) o lo **Scenario 4** (TT mixed-signal con celle standard).

### 2.1 Scegli lo scenario corretto

Apri `mag/tcl/lvs_netgen.tcl`. Il file contiene quattro scenari: lo **Scenario 1** è attivo (riga non commentata); gli Scenari 2, 3 e 4 sono commentati. Per il LVS di integrazione TinyTapeout devi:

1. **Commentare** la riga attiva dello Scenario 1
2. **Decommentare** il blocco dello Scenario 3 o 4 che corrisponde al tuo progetto

**Scenario 3 — progetto analogico puro** (il `project.v` istanzia solo blocchi analogici custom, nessuna cella standard `sky130_fd_sc_hd`):

```tcl
# Commenta lo Scenario 1:
# readnet spice $schematic $source

# Decommenta lo Scenario 3 e adatta i path alle tue netlist:
readnet spice ../xschem/simulation/mio_blocco_analogico.spice $source
readnet verilog ../src/project.v $source
```

**Scenario 4 — progetto mixed-signal** (il `project.v` istanzia anche un gate-level con celle standard `sky130_fd_sc_hd`):

```tcl
# Commenta lo Scenario 1:
# readnet spice $schematic $source

# Decommenta lo Scenario 4 e adatta i path:
readnet spice $::env(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/spice/sky130_fd_sc_hd.spice $source
readnet spice ../xschem/simulation/mio_blocco_analogico.spice $source
readnet verilog ../src/project.v $source
```

> 💡 **Scenario 2** — visibile nel file Tcl ma non usato in questo modulo. Serve per design analogici standalone (non TinyTapeout) dove il top-level xschem istanzia subcelle le cui netlist SPICE non vengono incluse automaticamente nella netlist LVS generata da xschem. In quel caso occorre caricare manualmente la netlist di ogni sotto-blocco prima di quella del top-level. Nella pratica del corso questo scenario non si presenta mai: xschem, quando genera la netlist LVS del top-level con **Simulation → LVS netlist: Top level is a `.subckt`** attiva, espande automaticamente tutte le subcelle gerarchiche in un unico file — incluse quelle annidate a più livelli. Ad esempio, la netlist `sar_adc_top.spice` del Modulo 5 contiene inline le definizioni `.subckt` di `cdac_complete`, `strongarm`, `switch_bank`, `passgate`, `T_gate` e `inverter`: per il LVS basta un unico `readnet spice sar_adc_top.spice` (Scenario 1) e Netgen trova tutto.

> ⚠️ L'ordine è importante: le celle figlie devono essere caricate **prima** del top-level che le istanzia. Le celle standard `sky130_fd_sc_hd` vanno sempre per prime (Scenario 4).

> ⚠️ Dopo aver modificato `lvs_netgen.tcl`, ricorda di ripristinare lo Scenario 1 se vuoi tornare al LVS standalone del Passo 1 — oppure tieni i due passi in run separate con `git stash` o una copia del file.

### 2.2 Esegui il LVS di integrazione

```bash
make clean lvs
```

> 💡 `PROJECT_NAME` e `SCHEMATIC_SPICE` non vanno specificati qui: il Makefile usa già `tt_um_psei_NOME`, e per gli Scenari 3/4 i path delle netlist sono scritti direttamente in `lvs_netgen.tcl`.

**Risultato del LVS Passo 2:** `MATCH` / `MISMATCH` → `?`

### 2.3 Errori tipici del LVS di integrazione

Gli errori del Passo 2 sono diversi da quelli del Passo 1 e riguardano l'interfaccia tra il tuo blocco e il wrapper TT:

- **"Unmatched pin: ua[0]"** — il pin `ua[0]` del layout non è connesso alla stessa net del `project.v`. Verifica che la label nel layout corrisponda al nome nel Verilog.
- **"Device count mismatch"** — il `project.v` istanzia un blocco che non è presente nel layout estratto. Verifica che tutte le istanze nel Verilog abbiano un corrispettivo fisico.
- **"Netgen crash: wrong # args"** — il nome del modulo top-level in `project.v` non corrisponde al `PROJECT_NAME` usato nel Makefile. Verifica che siano identici.
- **"Verilog is too complex for Netgen"** — il `project.v` contiene costrutti che Netgen non gestisce. Semplifica il Verilog (rimuovi `generate`, `always`, ecc.) — il `project.v` deve contenere solo dichiarazioni wire e istanze.

---

## Parte 3 — DRC completo

Il DRC interattivo di Magic (Parte 6 del Lab01-A) è un controllo parziale. Il DRC completo si esegue in batch con `make drc`:

```bash
make drc
```

Lo script `drc.tcl` usa lo stile `drc(full)` e stampa un riepilogo delle violazioni diviso per tipo di regola. L'output finisce a terminale e in `drc.report`.

**Numero totale di violazioni DRC:** `?`

Se ci sono violazioni, riapri il layout con `make magic`, individua le zone problematiche e correggile. Le violazioni più frequenti in questa fase:

- **`nwell.4`** — mancanza di contatto di bulk per il nwell; aggiungi un guard ring PMOS o un tap cell
- **`li.7` / `mcon.4`** — via fuori griglia; usa lo snap-to-grid di Magic (menu → Options → Grid 0.005)
- **`m3.2`** — metallo 3 troppo stretto; allarga il wire
- **`capm.15`** — violazione di spacing della capacità MiM; aumenta la distanza da altri layer

Dopo ogni correzione, riesegui `make drc` fino a ottenere zero violazioni.

> ⚠️ Le GitHub Actions TinyTapeout eseguono il loro DRC (con Klayout precheck) che può rivelare violazioni diverse da quelle di Magic. Un design DRC-clean in Magic è necessario ma non sempre sufficiente. Il precheck TT è la verifica definitiva — vedi Lab03.

---

## Parte 4 — Antenna check

Le antenna violations si verificano quando fili metallici lunghi connessi a gate MOSFET accumulano carica durante la fabbricazione, rischiando di danneggiare il gate oxide. Il PDK definisce un rapporto massimo (PAR, Perimeter Antenna Ratio) tra la lunghezza del filo e l'area del gate.

```bash
make antenna
```

Il report indica le violazioni e il rapporto misurato vs il limite. Violazioni con rapporto superiore a 2× il limite massimo sono da correggere prima del tapeout.

**Correttivi tipici:**

- Inserisci un diodo di antenna (via `sky130_fd_sc_hd__diode_2`) vicino al gate violante
- Spezza il filo metallico lungo con un cambio di layer (ogni cambio di layer resetta il contatore antenna)

> 💡 L'antenna check è meno critico dei DRC errors per un primo tapeout. Violazioni lievi (< 2× il limite) sono accettabili se non è possibile correggerle senza significativo rerouting.

---

## Parte 5 — Export GDS e LEF

Quando DRC e LVS sono entrambi PASS:

```bash
make update_gds
```

Questo script:
- Esporta `gds/tt_um_psei_NOME.gds` — il file inviato alla foundry per la fabbricazione
- Esporta `lef/tt_um_psei_NOME.lef` — il blackbox con solo i pin, per i tool di P&R

Verifica che i file siano stati creati:

```bash
ls -lh gds/ lef/
```

**Dimensione del GDS esportato:** `?` MB

> ⚠️ Ogni modifica al layout richiede di rieseguire `make update_gds`. Se il `.mag` cambia ma il GDS non viene rigenerato, le GitHub Actions verificheranno il GDS vecchio. Il messaggio nelle Actions "GDS file not up to date" indica questo problema.

> ⚠️ Controlla l'output del comando `make update_gds`. Se compare "1 problems occurred — see feedback entry", apri il `.mag` in Magic, seleziona tutta la cella (`ctrl+a`), e digita `feedback why` nella command window Tcl per vedere il dettaglio del problema.

---

## Parte 6 — LVS opzionale sul GDS finale (extra robustezza)

Come verifica aggiuntiva, è possibile eseguire il LVS sul GDS esportato invece che sul `.mag`. Questo cattura eventuali discrepanze tra il database Magic interno e il GDS scritto su disco.

Apri `mag/tcl/extract_for_lvs.tcl` e sostituisci la riga di caricamento del `.mag`:

```tcl
# Riga originale (commenta):
# load $cell_name.mag

# Aggiungi subito dopo:
gds read ../gds/${cell_name}.gds
```

Poi esegui:

```bash
make clean lvs
```

Ripristina la riga originale dopo la verifica. Se questo LVS è PASS, il GDS è pronto per la sottomissione.

> 💡 Questo passo è **fortemente consigliato** ma non obbligatorio. Saltarlo in un primo tapeout è accettabile se il LVS sul `.mag` è già PASS.

---

## Parte 7 — Simulazione full-tile con modello pad e mux (fortemente consigliata per progetti analogici)

Il flusso fatto fin qui verifica il layout del tile dal punto di vista geometrico (DRC) e topologico (LVS), ma le simulazioni che hai fatto nei moduli precedenti sono state condotte **senza** considerare gli elementi parassiti che esistono tra il tuo blocco e il pin esterno del chip. Tra il nodo interno del tuo design e il piedino del package ci sono almeno tre elementi che possono modificare il comportamento del circuito:

- **Bond wire** del package (~1 Ω serie + ~1 nH di induttanza)
- **Capacità di pad e di routing** (~5 pF totale verso massa)
- **Multiplexer TinyTapeout** — passgate CMOS a 5V che selezionano quale tile è attivo, con **resistenza di canale ~50 Ω** in serie e non-linearità dipendenti dalla tensione

Per progetti analogici questi parassiti contano sempre, anche se la frequenza di taglio del filtro RC equivalente (~640 MHz) sembra distante dalla banda del segnale. La resistenza serie altera l'impedenza vista in uscita (un buffer o un oscillatore percepiscono un carico diverso da quello che hai simulato in standalone), e i passgate del mux introducono distorsione non-lineare dipendente dal livello del segnale.

> 💡 Per un approfondimento sull'architettura del chip TinyTapeout — come il multiplexer seleziona il tile attivo tra le centinaia presenti, e come le power gate isolano i tile non in uso — leggi [docs/INFO.md del tt-multiplexer](https://github.com/TinyTapeout/tt-multiplexer/blob/main/docs/INFO.md).

### 7.1 Copia il modello del pad nel tuo progetto

Il repository PSEI fornisce un modello SPICE del pad TinyTapeout completo di bond wire, capacità di pad, ESD/protezione e multiplexer. Copialo nella cartella `xschem/` del tuo progetto:

```bash
cd /foss/designs/modulo6/tt_um_psei_NOME
cp /foss/designs/PSEI-ASIC-Lab/utils/tt_pad_model/*.sym xschem/
cp /foss/designs/PSEI-ASIC-Lab/utils/tt_pad_model/*.sch xschem/
```

I file copiati sono:

| File | Descrizione |
|------|-------------|
| `pad_model.sch` | Schematico del modello completo (bond wire + pad cap + mux passgate) |
| `pad_model.sym` | Simbolo da istanziare nel testbench |
| `vgnd_loc.sym`, `vpwr_loc.sym` | Simboli di alimentazione locale usati internamente dal modello |

### 7.2 Istanzia il modello nel testbench

Apri il testbench xschem del tuo blocco (quello che hai usato nel Modulo 5 per la verifica funzionale del sistema completo) e inserisci un'istanza di `pad_model` tra ogni uscita analogica del tuo design e il nodo che rappresenta il pin esterno.

Il simbolo `pad_model` ha tre pin:

| Pin del simbolo | A cosa connetterlo |
|---|---|
| `pin` | nodo esterno (lato package / bond wire) |
| `mod` | nodo interno del tile (uscita del tuo blocco) |
| `VGND` | massa locale del modello |

**Esempio per il SAR ADC del Modulo 5** (uscite differenziali `VOUTP` e `VOUTN`):

```
[Tuo design]                  [pad_model]                  [Mondo esterno]
  VOUTP (mod) ─────────► pad_model ────────────► VOUTP_ext (pin)
  VOUTN (mod) ─────────► pad_model ────────────► VOUTN_ext (pin)
```

Le sonde di misura nel testbench vanno spostate dal nodo interno (`VOUTP`) al nodo esterno (`VOUTP_ext`) — è quello che leggi sul piedino del chip una volta fabbricato.

> ⚠️ Il modello `pad_model` opera a 3.3V (`VAPWR`). Anche se il tuo design analogico è a 1.8V, il pad esterno è alimentato a 3.3V perché i mux TT usano transistor 5V — questa è una scelta architetturale del chip TinyTapeout, non un errore. Aggiungi al testbench una sorgente `VAPWR = 3.3V` per alimentare il modello.

### 7.3 Esegui la simulazione

Riesegui le simulazioni che hai fatto nel Modulo 5 (analisi transitoria del SAR ADC, AC analysis del filtro, ecc.) con il pad model inserito e confronta i risultati con quelli senza pad.

**Cosa cercare nel confronto:**

- **Variazione dell'impedenza vista in uscita** — se il blocco è un buffer o un driver, la pendenza della risposta a un gradino cambia rispetto alla simulazione standalone
- **Distorsione armonica** — se il segnale ha ampiezza confrontabile con `VAPWR/2`, l'attenuazione del passgate diventa non-lineare e compaiono armoniche di ordine pari (analizza con FFT)
- **Filtro RC nel range di interesse** — per segnali sub-MHz l'effetto è trascurabile; per segnali RF (>10 MHz) verifica l'attenuazione e adatta il design se serve

> 💡 Se il modello completo è troppo lento per simulazioni Monte Carlo o long-transient, puoi sostituirlo con un **modello semplificato**: una resistenza da 50 Ω in serie + un condensatore da 5 pF verso massa. Cattura l'effetto dominante del filtro RC ma non la non-linearità del passgate. Adatto per una prima verifica veloce; per il signoff finale usa il modello completo.

---

## Parte 8 — Commit dei file di layout

Committa i file prodotti in questo lab:

```bash
cd /foss/designs/modulo6/tt_um_psei_NOME

git add src/project.v
git add mag/tt_um_psei_NOME.mag
git add gds/tt_um_psei_NOME.gds
git add lef/tt_um_psei_NOME.lef

git commit -m "feat: tile Magic layout, integration LVS PASS, DRC clean, GDS export"
git push
```

> ⚠️ I file `.gds` possono essere grandi (decine di MB). Verifica che GitHub accetti il push — il limite è 100 MB per file. Se necessario, usa [Git LFS](https://git-lfs.com/) per i file grandi.

---

## Riepilogo dei risultati da verificare prima di procedere

| Verifica | Risultato atteso | Risultato ottenuto |
|---|---|---|
| LVS Passo 1 (blocco analogico) | MATCH | `?` |
| LVS Passo 2 (integrazione TT) | MATCH | `?` |
| DRC completo | 0 violazioni | `?` |
| Antenna check | 0 violazioni > 2× | `?` |
| GDS esportato | file presente in `gds/` | `?` |
| LEF esportato | file presente in `lef/` | `?` |
| Simulazione full-tile (analog) | comportamento entro le specifiche con pad model | `?` |

Quando tutta la tabella mostra i risultati attesi, procedi al [Lab03](./lab03_actions_submission.md).
