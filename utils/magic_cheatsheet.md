# Magic VLSI — Cheatsheet per SKY130A

**Versione Magic:** 8.3 (IIC-OSIC-TOOLS v2025.07) — **PDK:** SKY130A  
Basato sul [cheatsheet di Harald Pretl (JKU)](https://github.com/iic-jku/osic-multitool/blob/main/magic-cheatsheet/magic_cheatsheet.pdf), con aggiunte specifiche per il corso PSEI.

> 💡 Per un elenco completo di tutti i macro definiti nella sessione corrente, digita nella command window:
> ```tcl
> macro layout
> ```

---

## Avvio di Magic

```bash
# Dalla cartella mag/ del lab (non serve .magicrc locale nel container)
cd /foss/designs/moduloX/labY/mag
magic -d XR &          # rendering OpenGL (consigliato)
magic -d X11 &         # alternativa se XR non disponibile
magic -dnull -noconsole scripts/nome.tcl   # batch, senza GUI
```

> ⚠️ Avvia sempre Magic dalla cartella `mag/` del progetto. Non creare un `.magicrc` locale nel container IIC-OSIC-TOOLS: il PDK è già configurato a livello di sistema e un secondo source di `sky130A.magicrc` causerebbe l'errore `can't rename to "closewrapperonly"`.

---

## Interfaccia

Magic ha tre elementi principali:

| Elemento | Descrizione |
|---|---|
| **Finestra di layout** | Area di disegno principale |
| **Pannello layer** (destra) | Lista dei layer; click sinistro = mostra, click destro = nasconde |
| **Command window Tcl** | Interprete Tcl per i comandi; il prompt è `%` |

> ⚠️ La command window **non supporta incolla** con `Ctrl+V`. Per comandi lunghi usa `:` nella finestra di layout (salta direttamente alla command window), oppure crea uno script `.tcl` ed eseguilo con `source nomefile.tcl`.

---

## Tasti — Visualizzazione e navigazione

| Azione | Tasto |
|--------|-------|
| Zoom in | `Z` |
| Zoom out | `z` |
| Full view (tutto il layout) | `v` oppure `f` |
| Zoom sulla box corrente | `Ctrl+Z` |
| Centra la finestra sulla box | `B` |
| Pan | Tasti **freccia** (`←` `→` `↑` `↓`) |
| Attiva/disattiva griglia normale | `g` |
| Attiva/disattiva griglia fine | `G` |
| Misura (righello) | `k` |
| Rimuovi righelli | `K` |
| Ridisegna la finestra | `redraw` (command window) |

### Visibilità layer rapida (IIC add-on)

| Layer | Tasto |
|-------|-------|
| Local interconnect (`li`) | `0` |
| Metal 1 | `!` |
| Metal 2 | `@` |
| Metal 3 | `#` |
| Metal 4 | `$` |
| Metal 5 | `%` |
| Tutti i layer | `9` |

---

## Tasti — Selezione

| Azione | Tasto |
|--------|-------|
| Seleziona oggetti sotto il cursore | `s` |
| Aggiunge oggetti sotto il cursore alla selezione | `S` |
| Deseleziona oggetti sotto il cursore | `Ctrl+S` |
| Seleziona istanza (cella) sotto il cursore | `i` |
| Aggiunge istanza alla selezione | `I` |
| Deseleziona istanza sotto il cursore | `Ctrl+I` |
| Seleziona tutto nella box corrente | `a` |
| Aggiunge tutto nella box alla selezione | `A` |
| Deseleziona tutto nella box | `Ctrl+A` |
| Cancella la selezione | `,` |
| Apri pannello parametri della pcell selezionata | `q` |
| Mostra cosa è nella box | `?` |
| Mostra info sulla selezione | `what` (command window) |

> 💡 `s` seleziona geometrie (layer); `i` seleziona istanze di celle. Per selezionare un transistor come oggetto unitario usa `i`. Per selezionare un rettangolo di metallizzazione usa `s`.

---

## Tasti — Editing

| Azione | Tasto |
|--------|-------|
| Copia la selezione | `c` |
| Sposta la selezione al cursore | `m` |
| Elimina la selezione | `d` |
| Elimina tutto nella box (layer + label) | `Ctrl+D` |
| Ruota 90° (senso antiorario) | `r` |
| Ruota -90° (senso orario) | `R` |
| Flip verticale (capovolgimento su/giù) | `F` |
| Flip orizzontale (specchio sinistra/destra) | `Ctrl+F` |
| Undo | `u` |
| Redo | `U` |
| Salva tutte le celle modificate | `w` |

### Spostamento con tastierino numerico

| Azione | Tasto |
|--------|-------|
| Sposta la selezione di 1 lambda verso nord | `KEYPAD-8` |
| Sposta verso sud | `KEYPAD-2` |
| Sposta verso est | `KEYPAD-6` |
| Sposta verso ovest | `KEYPAD-4` |
| Stretching nord/sud/est/ovest | `Shift + KEYPAD` corrispondente |

---

## Tasti — Tool

| Azione | Tasto |
|--------|-------|
| Cicla tra i tool (box → wiring → netlist → pick) | `Spazio` |
| Torna direttamente al box tool | `Shift+Spazio` |
| Avvia wiring path | `p` |

### I quattro tool di Magic

**Box tool** (cursore a croce) — il tool di default. Click sinistro e destro definiscono i due angoli di una box rettangolare. Serve per selezionare aree, disegnare geometrie con `paint`, cancellare con `erase`, creare via con `contact`.

**Wiring tool** (cursore a freccia) — per il routing. Click sinistro seleziona il materiale dal layer sotto il cursore, click centrale posa il filo, `Shift+LEFT click` cambia layer con via automatico. È il tool principale per connettere i componenti.

**Netlist tool** — per esplorare la connettività elettrica. Cliccando su un nodo, Magic traccia e evidenzia tutta la net connessa a quel punto — utile per verificare che due punti siano davvero connessi, o per individuare cortocircuiti accidentali. Non modifica nulla, è solo diagnostico.

**Pick tool** — per spostare selezioni complesse mantenendo le connessioni. A differenza del normale `m` (move), il pick tool trascina anche i fili collegati all'oggetto: spostando un transistor, i fili si allungano o accorciano di conseguenza. Funziona bene su geometrie semplici; usare con cautela su layout complessi.

---

## Tasti — DRC e verifica

| Azione | Tasto |
|--------|-------|
| Spiega errori DRC nella box corrente | `y` |
| Trova il prossimo DRC error e zooma su di esso | `=` |
| Aggiorna il contatore DRC | `drc catchup` (command window) |
| Conta gli errori DRC | `drc count` (command window) |

---

## Tasti — Gerarchia

| Azione | Tasto |
|--------|-------|
| Espandi celle (mostra geometrie interne) nella box | `x` |
| Comprimi celle (nascondi geometrie interne) nella box | `X` |
| Toggle visibilità celle nella box | `Ctrl+X` |
| Scendi nella cella selezionata (diventa edit cell) | `>` |
| Risali alla cella superiore | `<` |
| Apri la selezione in una nuova finestra | `o` |

---

## Operazioni mouse — Box tool (default)

| Azione | Mouse |
|--------|-------|
| Imposta angolo inferiore sinistro della box | `LEFT click` |
| Imposta angolo superiore destro della box | `RIGHT click` |
| Disegna (paint) il layer puntato dal cursore nella box | `MIDDLE click` |
| Cancella (erase) il layer puntato nella box | `Shift+MIDDLE click` |

---

## Operazioni mouse — Wiring tool (`Spazio`)

| Azione | Mouse |
|--------|-------|
| Seleziona materiale e larghezza del filo dal layer sotto il cursore | `LEFT click` |
| Posa il filo alla posizione del cursore | `MIDDLE click` |
| Cancella il filo in costruzione | `RIGHT click` |
| Sale di un layer + inserisce via automatico | `Shift+LEFT click` |
| Scende di un layer + inserisce via automatico | `Shift+RIGHT click` |
| Posa un via e continua sul layer superiore | `Shift+MIDDLE click` |

> 💡 Sequenza tipica per connettere due punti su layer diversi: `LEFT click` per partire → `Shift+LEFT click` per salire di layer (es. `li` → `met1`) → `MIDDLE click` per posare → `RIGHT click` per terminare.

---

## Pannello layer (destra)

| Azione | Mouse sul pannello |
|--------|-------------------|
| Mostra solo quel layer | `LEFT click` |
| Nasconde quel layer | `RIGHT click` |

---

## Celle e gerarchia — Command window

```tcl
# Creare e caricare celle
cellname create nomecel    # crea una nuova cella vuota
load nomecel               # carica una cella come cella corrente
cellname list              # elenca tutte le celle in memoria

# Istanziare celle esistenti (solo file .mag utente, NON pcell PDK)
getcell nomecel            # istanzia una cella nella cella corrente

# Navigazione gerarchica
expand                     # mostra geometrie interne (come tasto x)
unexpand                   # nasconde geometrie interne (come tasto X)

# Appiattimento della gerarchia
flatten nomecel_flat       # crea una versione flat della cella corrente
```

> ⚠️ `getcell` funziona solo per celle salvate come file `.mag` (celle create dall'utente). Le **pcell SKY130A** non sono file `.mag` — si istanziano esclusivamente dal menu **Devices 1** o **Devices 2**.

---

## Istanziazione pcell SKY130A — Menu Devices

Le pcell vengono generate dinamicamente dal Device Generator del PDK. Il flusso è:

1. Clicca su **Devices 1** o **Devices 2** nella barra dei menu
2. Seleziona il device dalla lista
3. Imposta i parametri nel pannello (W, L, NF, MF...)
4. Clicca **OK** e poi clicca nella finestra di layout per posizionare la pcell

Per modificare i parametri di una pcell già posizionata: selezionala con `i`, poi premi `q`.

### Corrispondenza nome tecnico → voce di menu

| Nome tecnico PDK | Menu → voce | Campo "Device type" nel pannello |
|---|---|---|
| `sky130_fd_pr__nfet_01v8` | **Devices 1 → nmos (MOSFET)** | `sky130_fd_pr__nfet_01v8` |
| `sky130_fd_pr__pfet_01v8` | **Devices 1 → pmos (MOSFET)** | `sky130_fd_pr__pfet_01v8` |
| `sky130_fd_pr__res_xhigh_po_0p35` | **Devices 2 → poly resistor - 2000 Ohm/sq** | — |
| `sky130_fd_pr__res_high_po_0p35` | **Devices 2 → poly resistor - 319.8 Ohm/sq** | — |
| `sky130_fd_pr__res_generic_po` | **Devices 2 → poly resistor - 48.2 Ohm/sq** | — |
| `sky130_fd_pr__cap_mim_m3_1` | **Devices 2 → MiM cap - 2fF/um^2 (metal3)** | — |
| `sky130_fd_pr__cap_mim_m4_1` | **Devices 2 → MiM cap - 2fF/um^2 (metal4)** | — |

Il pannello **params** apre una finestra separata. I campi variano per tipo di device:

**Transistor (nfet/pfet):** `Width (um)` (per finger), `Length (um)`, `Fingers`, `M`, `Device type` + opzioni contatti e guard ring.

**Resistore poly:** `Value (ohms)` (calcolato automaticamente, include effetti contatti), `Length (um)`, `Width (um)` (fissa), `X Repeat`, `Y Repeat`, `Use snake geometry` (geometria serpentina per resistori lunghi), opzioni guard ring.

**Capacità MiM:** `Value (fF)` (per singola cella, calcolato automaticamente), `Total capacitance (pF)` (totale con repeat), `Length (um)`, `Width (um)`, `X Repeat`, `Y Repeat` (equivalente a MF in xschem), `Square capacitor` (forza L=W), `Connect bottom/top plates in array`.

Il pulsante **Create** posiziona la pcell automaticamente sul canvas; **Create and Close** posiziona e chiude il pannello; **Reset** riporta i valori di default. Dopo il posizionamento: `i` per selezionare, `q` per riaprire il pannello e modificare i parametri.

### Guard ring: connessione a li

I contatti di source, drain e gate delle pcell transistor e i terminali del resistore sono già provvisti di contatti interni fino a `li` — si può salire direttamente a `met1` con `Shift+LEFT click` nel wiring tool.

I **guard ring** (`psubstratepdiff` per NMOS, `nsubstratendiff` per PMOS) espongono invece solo il layer di diffusione senza contatti preformati. Per collegarli:
1. Con il box tool, disegna una box sopra il guard ring nel punto desiderato
2. Nella command window: `contact viali` — crea il via da diffusione a `li`
3. Con il wiring tool, parti da quel punto verso il rail GND/VDD su `met1`

### Nota sulla convenzione Width/Fingers

Nel pannello **params** di Magic, **Width** è la larghezza **per finger**. Con `Fingers=2` e `Width=2µm`, la W totale è 4µm. In xschem invece `W` è la larghezza **totale** — con `nf=2` ogni finger vale `W/nf`. Questa differenza si applica solo all'istanziazione manuale; con **File → Import SPICE** la conversione è automatica.

---

## Import netlist SPICE → layout schematic-driven

Il flusso standard per partire da uno schematico xschem:

**Passo 1 — genera la netlist LVS in xschem:**
- In xschem: **Simulation → LVS netlist: Top level is a `.subckt`** (deve comparire il segno di spunta)
- **Simulation → Netlist** (oppure `Ctrl+Shift+N`)
- La netlist viene salvata in `xschem/simulation/nomecel.spice`

**Passo 2 — importa in Magic:**
```tcl
cellname create nomecel
load nomecel
```
Poi usa il menu: **File → Import SPICE** → seleziona `../xschem/simulation/nomecel.spice`

> 💡 **File → Import SPICE** è visibile nel menu File confermato in Magic 8.3 con PDK SKY130A nel container IIC-OSIC-TOOLS v2025.07.

Magic istanzia automaticamente le pcell con i parametri W/L/NF corretti. Le connessioni (routing) rimangono a carico del progettista.

> ⚠️ **File → Import SPICE è un'operazione one-shot.** Una volta iniziato il routing, non è possibile reimportare la netlist senza perdere i progressi. Se modifichi lo schematico dopo l'import, aggiorna manualmente il layout: seleziona la pcell con `i`, apri i parametri con `q`, modifica il valore.

---

## Export GDS

**Via menu:** **File → Write GDS** → inserisci il nome del file

**Via command window:**
```tcl
# Salva prima il file .mag
save nomecel

# Esporta in GDS-II
gds write nomecel.gds
```

Il file `.gds` viene creato nella cartella `mag/` corrente.

Per aprire il GDS in KLayout:
```bash
klayout nomecel.gds &
```

> 💡 Nel container IIC-OSIC-TOOLS v2025.07 la tecnologia SKY130A è già caricata automaticamente — lo conferma la presenza del menu **Efabless sky130** nella barra dei menu.

---

## Pin label e port (necessari per LVS)

> ⚠️ Un semplice testo in Magic è visibile graficamente ma non genera un pin nella netlist estratta. Per il LVS servono i **port**: la differenza è il checkbox **Port: enable** nel dialogo **texthelper**.

**Metodo consigliato — via GUI:**

1. Disegna una piccola box sul layer `met1` nel punto del pin
2. **Edit → Text...**
3. Nel dialogo **texthelper**:
   - **Text string**: nome del pin
   - **Port: enable** → **spunta questa casella**
4. **Okay**

**Metodo alternativo — command window:**
```tcl
# Con la box sul layer met1 già selezionata:
label nomepin
port make
port class input     # oppure: output, inout
```

**Verifica:**
```tcl
port first    # stampa il primo port trovato nella cella
port next     # passa al successivo
```

I tipi di pin riconosciuti da Netgen: `input`, `output`, `inout`, `bidirectional`.

> 💡 Il nome del port nel layout deve corrispondere esattamente (case-sensitive) al nome nella netlist SPICE. Usa `grep '\.subckt' file.spice` per verificare i nomi prima di creare i port.

> 💡 Se `port first` non stampa nulla, la label è stata creata senza spuntare **Port: enable**. Cancella con `d` e ricrea.

---

## Estrazione netlist per LVS e PEX

Gli script di estrazione vengono eseguiti in batch da terminale. Devono essere lanciati dalla cartella `mag/`.

### Estrazione per LVS (senza parassitici)

```bash
magic -dnull -noconsole \
      -rcfile $PDK_ROOT/$PDK/libs.tech/magic/sky130A.magicrc \
      scripts/extract_lvs.tcl
```

Contenuto di `extract_lvs.tcl`:
```tcl
set cell_name "nomecel"
load $cell_name
select top cell
extract all
ext2spice lvs
ext2spice cthresh infinite
ext2spice subcircuit top on
ext2spice
file rename -force $cell_name.spice $cell_name.lvs.spice
foreach f [glob -nocomplain *.ext] { file delete $f }
quit
```

### Estrazione con parassitici R+C (PEX)

```tcl
set cell_name "nomecel"
flatten ${cell_name}_flat        # necessario per le R parassite
load ${cell_name}_flat
select top cell
extract all
ext2spice cthresh 0.01           # soglia capacità: 0.01 fF
ext2spice rthresh 0.01           # soglia resistenza: 0.01 Ω
ext2spice subcircuit top on
ext2spice
file rename -force ${cell_name}_flat.spice $cell_name.sim.spice
foreach f [glob -nocomplain *.ext] { file delete $f }
quit
```

> 💡 Il `flatten` prima della PEX è necessario perché Magic non può calcolare le resistenze parassite attraverso i confini gerarchici.

---

## LVS con Netgen

```bash
# Dalla cartella mag/
netgen -batch lvs \
    "nomecel.lvs.spice nomecel" \
    "../xschem/simulation/nomecel.spice nomecel" \
    $PDK_ROOT/$PDK/libs.tech/netgen/sky130A_setup.tcl \
    lvs.report

cat lvs.report
```

### Lettura del report LVS

| Campo | 1 = PASS | 0 = FAIL |
|---|---|---|
| **Match** | Topologia identica | Net aperta, cortocircuito, device in più o in meno |
| **Properties** | W/L uguali | W/L estratto ≠ W/L schematico |
| **Port** | Pin identici per nome e numero | Pin mancante o nome diverso |

Il report va letto dall'alto verso il basso: prima le subcelle, poi la top-cell.

---

## DRC e LVS con KLayout

**DRC:**
- **Efabless sky130 → Run DRC (BEOL)** — solo layer metallici (veloce)
- **Efabless sky130 → Run DRC (FEOL)** — solo layer attivi e poly
- **Efabless sky130 → Run DRC (Full)** — DRC completo

**LVS:**
- **Efabless sky130 → Run LVS** → seleziona la netlist SPICE di riferimento

**Import Netlist:**
- **Efabless sky130 → Import Netlist** → visualizza connettività sovrapposta al GDS (solo diagnostica)

> ⚠️ Il LVS di KLayout e il LVS di Netgen usano algoritmi diversi. Per il tapeout, Netgen è il riferimento ufficiale per SKY130A.

---

## Riferimento menu Magic 8.3 (IIC-OSIC-TOOLS v2025.07)

| Azione | Menu | Comando Tcl equivalente |
|---|---|---|
| Apri file `.mag` | **File → Open...** | `load nomecel` |
| Salva cella con nome | **Cell → Save as...** | `save nomecel` |
| Annulla modifiche non salvate | **File → Flush changes** | `flush` |
| Importa netlist SPICE | **File → Import SPICE** | — |
| Leggi GDS | **File → Read GDS** | `gds read file.gds` |
| Scrivi GDS | **File → Write GDS** | `gds write file.gds` |
| Salva tutto ed esci | **File → Save All and Quit** | `writeall; quit` |
| Esci senza salvare | **File → Quit** (`Ctrl+Shift+Q`) | `quit -nocheck` |
| Nuova cella | **Cell → New...** | `cellname create nome; load nome` |
| Istanzia una cella utente | **Cell → Place Instance** | `getcell nomecel` |
| Modifica cella figlia in-place (Loaded = padre, Editing = figlia) | **Cell → Edit** (`e`) | — |
| Scendi completamente nella cella figlia (Loaded = Editing = figlia) | — | `>` |
| Risali alla cella superiore | **Cell → Up hierarchy** (`<`) | — |
| Espandi celle nella box | **Cell → Expand** (`x`) | `expand` |
| Comprimi celle nella box | **Cell → Unexpand** (`X`) | `unexpand` |

---

## Comandi utili — Command window

```tcl
# Geometria
paint met1                      # disegna met1 nella box
erase met1                      # cancella met1 nella box
erase *                         # cancella tutti i layer (non le label)
contact viali                   # crea un via li→met1 nella box
contact ndc                     # crea un contatto ndiff→li (guard ring NMOS)
contact pdc                     # crea un contatto pdiff→li (guard ring PMOS)

# Misurazione
box                             # stampa le dimensioni della box corrente
measure hor                     # crea un righello orizzontale nella box

# Layer
see no met2                     # nasconde met2
see met2                        # mostra met2
see no *                        # nasconde tutti i layer
see *                           # mostra tutti i layer

# Connettività
select short label1 label2      # trova il percorso che connette due nodi
findlabel nomepin               # centra la box sul pin nomepin

# Celle
identify cell-id                # rinomina l'istanza selezionata
array 2 1                       # crea un array 2×1 della selezione (spacing = box)
dump nomecel                    # copia una cella nella cella corrente

# Salvataggio e uscita
save nomecel                    # salva la cella corrente (= Cell → Save as...)
gds write nomecel.gds           # esporta GDS (= File → Write GDS)
flush                           # annulla modifiche non salvate (= File → Flush changes)
quit                            # esci da Magic (= File → Save All and Quit)
quit -nocheck                   # esci senza salvare (= File → Quit)
```

---

## Layer stack SKY130A — riepilogo

| Layer Magic | Nome fisico | Sheet resistance | Via verso il layer superiore |
|---|---|---|---|
| `poly` | Polisilicio gate | — | `polyc` (poly → li) |
| `li` | Local Interconnect | 12.2 Ω/□ | `viali` (li → met1) |
| `met1` | Metal 1 | 125 mΩ/□ | `via1` (met1 → met2) |
| `met2` | Metal 2 | 125 mΩ/□ | `via2` (met2 → met3) |
| `met3` | Metal 3 | 47 mΩ/□ | `via3` (met3 → met4) |
| `met4` | Metal 4 | 47 mΩ/□ | `via4` (met4 → met5) |
| `met5` | Metal 5 (top) | 29 mΩ/□ | — |
| `capm` | Cap Metal (MiM top plate) | — | — |

---

## Spostare un progetto Magic tra cartelle

Quando copi o sposti un progetto Magic da una cartella all'altra (ad esempio da `lab02/mag/` a `lab03/mag/`), copia **sempre tutti i file `.mag`** presenti nella cartella sorgente — non solo i file delle celle principali:

```bash
cp /foss/designs/modulo3/lab02/mag/*.mag /foss/designs/modulo3/lab03/mag/
```

Oltre ai file delle tue celle (`buffer.mag`, `inverter.mag` ecc.) troverai file con nomi come `sky130_fd_pr__nfet_01v8_5H57NF.mag`. Sono le **varianti delle pcell** salvate localmente da Magic con i parametri W/L specifici che hai usato. Magic le cerca prima nella cartella corrente: se mancano, non riesce a caricare correttamente la gerarchia e il layout si apre con celle mancanti o con parametri errati.

---

## Errori comuni e soluzioni

| Errore | Causa | Soluzione |
|---|---|---|
| `can't rename to "closewrapperonly"` | `.magicrc` locale sorgenta `sky130A.magicrc` che è già caricato | Rimuovi il `.magicrc` locale |
| `Cell X couldn't be read` con `getcell` | Si cerca di caricare una pcell PDK con `getcell` | Usa il menu **Devices 1/2** |
| `"X" has a zero timestamp` | Cella salvata senza timestamp | Esegui `save X` |
| `Error parsing ".magicrc"` | Il `.magicrc` usa variabili bash (`$PDK_ROOT`) invece di Tcl (`$env(PDK_ROOT)`) | Correggi in `$env(PDK_ROOT)/$env(PDK)/...` oppure rimuovi il file |
| LVS: `Properties: 0` | W/L nel layout ≠ W/L nello schematico | Verifica i parametri con `i` + `q` |
| LVS: `Port: 0` | Nome port nel layout ≠ nome nella netlist (case-sensitive) | Controlla con `grep '\.subckt' file.spice` |
| LVS: `Match: 0` — numero net diverso | Net disconnessa (filo mancante) o cortocircuito | Usa `select short` per trovare il percorso |

---

## Riferimenti

- [Documentazione ufficiale Magic](http://opencircuitdesign.com/magic/userguide.html)
- [Magic cheatsheet — Harald Pretl (JKU)](https://github.com/iic-jku/osic-multitool/blob/main/magic-cheatsheet/magic_cheatsheet.pdf)
- [SKY130A PDK — device details](https://skywater-pdk.readthedocs.io/en/main/rules/device-details.html)
- [SKY130A PDK — design rules](https://skywater-pdk.readthedocs.io/en/main/rules/periphery.html)
- [Netgen — documentazione](http://opencircuitdesign.com/netgen/)
