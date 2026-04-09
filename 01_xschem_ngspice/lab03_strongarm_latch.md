# Lab 3 — Design e simulazione del comparatore Strong-ARM Latch

**Tempo stimato:** 2.5 ore  
**Cartella di lavoro:** `/foss/designs/modulo1/lab03/xschem/`

---

## Obiettivo

In questo lab realizzeremo il comparatore Strong-ARM Latch dimensionato nel Lab 2 e lo verificheremo con tre livelli di simulazione progressivi: nominale, PVT e Monte Carlo.

Al termine saprai:
- Tradurre un dimensionamento gm/Id in un circuito xschem 
- Gestire le connessioni interne con etichette `lab_wire`
- Misurare il tempo di decisione nominale con `meas`
- Eseguire sweep parametrici di temperatura e VDD con `foreach` + `alterparam` + `reset`
- Simulare i corner di processo (TT, SS, FF, SF, FS)
- Impostare una simulazione Monte Carlo con il corner `tt_mm` di SKY130A per estrarre la distribuzione statistica dell'offset (estendibile agli altri corner `ss_mm`, `ff_mm`, `fs_mm`, `sf_mm`)
- Confrontare il σ_offset simulato con la previsione analitica della legge di Pelgrom

---

## Struttura delle cartelle del progetto

```bash
mkdir -p /foss/designs/modulo1/lab03/xschem
cd /foss/designs/modulo1/lab03/xschem

cat > xschemrc << 'EOF'
source /foss/pdks/sky130A/libs.tech/xschem/xschemrc
set netlist_dir [file normalize [file dirname [info script]]/simulation]
append XSCHEM_LIBRARY_PATH :[file dirname [info script]]
EOF
```

La struttura finale del lab:

```
/foss/designs/modulo1/lab03/
└── xschem/
    ├── xschemrc
    ├── strongarm.sch          ← schematico del comparatore
    ├── strongarm.sym          ← simbolo generato automaticamente
    ├── tb_op.sch              ← Parte 3: verifica punto di lavoro
    ├── tb_tran.sch            ← Parte 4: simulazione transitoria nominale
    ├── tb_pvt.sch             ← Parte 5: sweep 3T × 3VDD per corner
    ├── tb_corners.sch         ← Parte 5.4: corner ridotti (t_decision + t_precharge)
    ├── tb_mc.sch              ← Parte 6: Monte Carlo offset
    └── simulation/
```

Lancia xschem **sempre dalla cartella `xschem/` del lab**:

```bash
cd /foss/designs/modulo1/lab03/xschem
xschem &
```

---

## Teoria: le due fasi del comparatore

Il funzionamento del comparatore è trattato in dettaglio nella Parte 2 del Lab 2. Qui riportiamo solo lo stretto necessario per capire le connessioni da disegnare.

![strongarm_latch](../assets/images/strongarm_latch.png)

- **CLK = 0 — fase di reset:** MNT spento; MP1/MP2/MP3/MP4 accesi ($V_{GS}$ = −1.8V). I nodi `out_p`, `out_n`, `sp`, `sn` vengono riportati a VDD. Con entrambe le uscite a VDD, i gate di MP5/MP6 sono a VDD → MP5/MP6 spenti.
- **CLK = 1.8V — fase di valutazione:** MNT acceso; MP1/MP2/MP3/MP4 spenti. MN1/MN2 integrano la differenza di ingresso scaricando asimmetricamente `sp`/`sn` e quindi `out_p`/`out_n`. Il latch CMOS MN3/MN4 + MP5/MP6 (due inverter back-to-back) rigenera esponenzialmente: MN3/MN4 scaricano verso GND l'uscita perdente, MP5/MP6 tirano verso VDD l'uscita vincente.

**Connessioni chiave:**

| Net | Connessa a |
|-----|-----------|
| `out_p` | Drain MP1, Drain MP5, Drain MN3, Gate MN4, Gate MP6 |
| `out_n` | Drain MP2, Drain MP6, Drain MN4, Gate MN3, Gate MP5 |
| `sp` | Drain MP3, Source MN3, Drain MN1 |
| `sn` | Drain MP4, Source MN4, Drain MN2 |
| `tail` | Source MN1, Source MN2, Drain MNT |
| `clk` | Gate MNT, Gate MP1, Gate MP2, Gate MP3, Gate MP4 |

---

## Valori di dimensionamento di riferimento

Usa i valori che hai calcolato nel Lab 2. La tabella seguente riporta un esempio di risultati attesi dalla lettura delle curve gm/Id:

| Transistor | gm/Id | Id/W (da grafico) | Id | W | L |
|-----------|-------|-------------------|----|---|---|
| MN1, MN2 (coppia diff.) | 12 V⁻¹ | 12.9 µA/µm | 50 µA | 4 µm | 0.25 µm |
| MN3, MN4 (latch NMOS) | 7 V⁻¹ | 57 µA/µm | 50 µA | 1 µm | 0.15 µm |
| MP5, MP6 (latch PMOS) | 7 V⁻¹ | 20–25 µA/µm | 50 µA | 2 µm | 0.15 µm |
| MNT (coda) | 9 V⁻¹ | 12.1 µA/µm | 100 µA | 8 µm | 0.5 µm |
| MP1, MP2 (precarica `out`) | 10 V⁻¹ | 15–20 µA/µm | 50 µA | 3 µm | 0.15 µm |
| MP3, MP4 (precarica `sp`/`sn`) | 10 V⁻¹ | 15–20 µA/µm | 50 µA | 3 µm | 0.15 µm |

---

## Parte 1 — Schematico del comparatore (`strongarm.sch`)

### 1.1 Setup

Dopo aver aperto xschem, apri un nuovo Tab, quindi crea un nuovo schematico vuoto: **File → New Schematic** → salva subito come `strongarm.sch`.

### 1.2 Transistor NMOS

Aggiungi cinque NMOS con `Shift+I` → `sky130_fd_pr → nfet_01v8`. Disponi MN3/MN4 in alto (latch), MN1/MN2 al centro (coppia differenziale), MNT in basso al centro (coda). Imposta i parametri con doppio click:

| Istanza | `W` | `L` |
|---------|-----|-----|
| MN1, MN2 | `4u` | `0.25u` |
| MN3, MN4 | `1u` | `0.15u` |
| MNT | `8u` | `0.5u` |

Collega con `W` il pin **B** (body) di tutti gli NMOS a `GND`.

### 1.3 Transistor PMOS

Aggiungi sei PMOS con `Shift+I` → `sky130_fd_pr → pfet_01v8`. Il source del PMOS punta verso l'alto (verso VDD).

**MP1, MP2 — precarica uscite:** posizionali in cima, con il drain che si collega a `out_p`/`out_n`.

**MP3, MP4 — precarica nodi intermedi:** posizionali accanto a MP1/MP2, con il drain che si collega a `sp`/`sn`.

**MP5, MP6 — latch PMOS cross-coupled:** posizionali tra le uscite e i nodi intermedi. Drain di MP5 → `out_p`; Drain di MP6 → `out_n`. Gate di MP5 → `out_n`; Gate di MP6 → `out_p` (cross-coupling PMOS).

| Istanza | `W` | `L` | Funzione |
|---------|-----|-----|----------|
| MP1, MP2 | `3u` | `0.15u` | Precarica `out_p`/`out_n` a VDD |
| MP3, MP4 | `3u` | `0.15u` | Precarica `sp`/`sn` a VDD |
| MP5, MP6 | `2u` | `0.15u` | Latch PMOS cross-coupled |

Collega il pin **B** (body) e il pin **S** (source) di **tutti e sei i PMOS** a `VDD`.

### 1.4 Aggiungere `annotate_fet_params`

Per abilitare l'annotazione automatica dei parametri interni dei transistor dopo una simulazione `.op`, aggiungi un elemento `annotate_fet_params` dalla libreria `sky130_fd_pr` accanto a ciascun transistor dello schematico.

Con `Shift+I` → cerca `annotate_fet_params` nella libreria `sky130_fd_pr` → piazza un'istanza per ogni transistor. Per ciascuna, imposta il campo `ref` con il nome dell'istanza così come appare **sullo schematico** — non il nome netlist. Il componente ha `M1` come valore di default: aggiornalo per ogni istanza.

> 💡 In xschem il nome sullo schematico (es. `M1`) e il nome nella netlist (es. `XM1`) sono distinti: il campo `ref` di `annotate_fet_params` vuole il nome schematico. Se hai lasciato i nomi di default assegnati da xschem, la corrispondenza è quella seguente.

| Transistor | Nome sullo schematico (campo `ref`) |
|------------|-------------------------------------|
| MN1 | `M1` |
| MN2 | `M2` |
| MN3 | `M3` |
| MN4 | `M4` |
| MNT | `M5` |
| MP1 | `M6` |
| MP2 | `M7` |
| MP3 | `M8` |
| MP4 | `M9` |
| MP5 | `M10` |
| MP6 | `M11` |

> ⚠️ I numeri sopra valgono solo se hai inserito i transistor nell'ordine descritto nelle sezioni 1.2 e 1.3. Se hai rinominato le istanze o le hai inserite in ordine diverso, il nome sullo schematico può essere diverso.

### 1.5 Connessioni interne con etichette lab_wire

In xschem esistono due meccanismi distinti per denominare un nodo:

- **`lab_wire`** (`Shift+I` → libreria `devices` → cerca `lab_wire`) — etichetta di net per connessioni **interne** allo schematico. Non genera alcun pin nel simbolo.
- **`ipin` / `opin` / `iopin`** (`Shift+I` → libreria `devices`) — componenti pin che definiscono le **porte del simbolo gerarchico**. Sono questi che compaiono nel simbolo e nel `.subckt` della netlist.

Per `strongarm.sch` la regola è semplice: tutti i nodi che devono essere visibili dall'esterno (ingressi, uscite, alimentazioni) usano pin `ipin`/`opin`/`iopin`; tutti i nodi interni usano `lab_wire`.

Usa `W` per tracciare i fili. La cross-coupling si fa con etichette `lab_wire`, non con fili che si incrociano.

**Nodi interni — usa `lab_wire`:**
- Collega con `W` il source di MN3 al drain di MN1, poi aggiungi l'etichetta `sp` sul nodo comune
- Collega con `W` il source di MN4 al drain di MN2, poi aggiungi l'etichetta `sn` sul nodo comune
- Collega source MN1, source MN2 e drain MNT → etichetta `tail`

**Cross-coupling del latch NMOS — verifica con attenzione:**

`out_p` e `out_n` sono già definiti come `opin` — collega i gate del latch NMOS direttamente ai rispettivi pin con un filo `W`:
- Gate di MN3 → pin `out_n`
- Gate di MN4 → pin `out_p`

> ⚠️ Il gate di MN3 va a `out_n` (non `out_p`) e viceversa. Un'inversione produce un latch che non rigenera mai.

**Cross-coupling del latch PMOS (MP5/MP6) — verifica con attenzione:**

Anche MP5/MP6 sono cross-coupled, ma con gate e drain invertiti rispetto agli NMOS:
- Gate di MP5 → `out_n` (etichetta `lab_wire`)
- Gate di MP6 → `out_p` (etichetta `lab_wire`)
- Drain di MP5 → `out_p` (stesso nodo del drain di MP1 e MN3)
- Drain di MP6 → `out_n` (stesso nodo del drain di MP2 e MN4)

> ⚠️ La cross-coupling PMOS è nella direzione opposta a quella NMOS: MP5 ha gate=`out_n` e drain=`out_p`. Quando `out_p` va a 0 (uscita vincente), il gate di MP6 (=`out_p`) va a 0 → MP6 si accende → tira `out_n` a VDD.

### 1.6 Pin del simbolo — usa `ipin` e `opin`

I nodi che devono apparire nel simbolo vanno collegati tramite componenti pin, **non** con `lab_wire`. Aggiungi i pin con `Shift+I` → libreria `devices`:

| Componente | Nome | Dove collegarlo |
|------------|------|-----------------|
| `ipin` | `vin_p` | Gate di MN1 |
| `ipin` | `vin_n` | Gate di MN2 |
| `ipin` | `clk` | Gate di MNT, Gate di MP1, MP2, MP3, MP4 |
| `iopin` | `vdd` | Source e body di tutti i PMOS (MP1–MP6) |
| `iopin` | `gnd` | Source di MNT, body di tutti gli NMOS |
| `opin` | `out_p` | Drain di MP1, Drain di MP5, Drain di MN3 (nodo comune) |
| `opin` | `out_n` | Drain di MP2, Drain di MP6, Drain di MN4 (nodo comune) |

### 1.7 Verifica della netlist

**Ctrl+S** → **Netlist**. Per visualizzare la netlist generata, attiva **Simulation → Show netlist after netlist command** — da questo momento ogni click su **Netlist** apre automaticamente una finestra con il file SPICE completo.

Verifica che le righe di MN3 e MP5 mostrino la cross-coupling corretta:

```
X_MN3 out_p out_n sp gnd sky130_fd_pr__nfet_01v8 W=1e-6 L=150e-9 ...
X_MP5 out_p out_n vdd vdd sky130_fd_pr__pfet_01v8 W=2e-6 L=150e-9 ...
```

L'ordine dei pin è Drain–Gate–Source–Bulk. Nota che sia MN3 che MP5 hanno `out_n` come gate — ma MN3 ha drain su `out_p` mentre MP5 ha source su `vdd` e drain su `out_p`. Questo è il doppio latch convergente.

---

## Parte 2 — Simbolo (`strongarm.sym`)

Con `strongarm.sch` aperto, genera il simbolo con **Symbol → Make symbol from schematic** oppure tasto `A`.

Xschem genera automaticamente un simbolo con i pin posizionati sui bordi e la label `@symname` al centro — una volta istanziato, questa label mostrerà automaticamente il nome del file simbolo. Seleziona e riposiziona manualmente i pin (ciascuno è composto dal quadratino rosso, dal nome e dal segmento verde) in modo che ingressi siano a sinistra, uscite a destra e alimentazioni in alto/basso.

Salva con **Ctrl+S**.

---

## Parte 3 — Verifica del punto di lavoro (`tb_op.sch`)

Prima di qualsiasi simulazione dinamica, vale la pena verificare che i transistor stiano operando nel punto di lavoro previsto dal dimensionamento. Il comparatore Strong-ARM è un circuito **puramente dinamico** — non esiste una condizione DC in cui PMOS, coppia differenziale e tail siano tutti in regime stazionario simultaneamente. La `.op` richiede quindi un punto di lavoro **artificiale**.

Il metodo più pratico è:
1. Impostare `clk = 0` nel testbench → MP1/MP2/MP3/MP4 accesi (precarica attiva), MNT spento
2. Aggiungere un **generatore di corrente ideale da 100 µA** direttamente in parallelo a MNT, dentro `strongarm.sch` — questo forza la corrente di coda al valore di progetto senza bisogno di pilotare il gate di MNT

Il circuito risultante ha MP1/MP2 che tengono `out_p`/`out_n` a VDD e MP3/MP4 che tengono `sp`/`sn` a VDD, con la coppia differenziale MN1/MN2 alimentata dall'isource e il latch MN3/MN4 attivo. È un punto DC simmetrico e stabile che ngspice risolve senza problemi di convergenza.

> 💡 **MP5/MP6 sono spenti in questa condizione.** I loro gate sono collegati a `out_p` e `out_n`, che con CLK=0 vengono tenuti a VDD da MP1/MP2. Quindi gate di MP5 = `out_n` = VDD, source = VDD → $V_{GS}$ = 0 → MP5/MP6 spenti. Il latch PMOS non partecipa al punto di lavoro artificiale e i suoi parametri non sono leggibili da questa simulazione — è una limitazione nota e accettabile, perché lo scopo della `.op` è verificare la coppia differenziale e il latch NMOS.

> ⚠️ Il generatore di corrente va **rimosso** da `strongarm.sch` prima di eseguire qualsiasi altra simulazione (transitoria, PVT, Monte Carlo). È un elemento temporaneo di test.

### 3.1 Aggiungere il generatore di corrente in `strongarm.sch`

Apri `strongarm.sch`. Aggiungi un `isource` dalla libreria `devices` in parallelo a MNT:
- Polo positivo (`+`) collegato al net `tail`
- Polo negativo (`−`) collegato a `GND`
- `value = 100u`

Salva con **Ctrl+S**.

### 3.2 Creare `tb_op.sch`

Crea un nuovo schematico `tb_op.sch`. Istanzia `strongarm.sym` al centro con `Shift+I`.

**VVDD**: `value = 1.8`

**VCLK**: `value = 0` → PMOS accesi ($V_{GS}$ = 0 − 1.8 = −1.8V), MNT spento ($V_{GS}$ = 0)

**VVIN_P** e **VVIN_N**: entrambe `value = 0.9` (V_diff = 0)

**CL_P** e **CL_N** (`capa`): `value = 20f`

Aggiungi etichette `GND` ai poli negativi di tutte le sorgenti. Copia `TT_MODELS` da `top.sch`.

Copia la freccia **Generate .save lines** da `top.sch`, fai **`Ctrl+click`** su di essa per generare `tb_op.save`.

Aggiungi un `code_shown`:

```
value=".include tb_op.save
.options savecurrents

.control
  save all
  op
  remzerovec
  write tb_op.raw
.endc"
```

> ⚠️ `save all` va **dentro** `.control`. Il file `tb_op.save` generato dalla freccia specifica i parametri da salvare — `save all` garantisce che vengano salvati anche tensioni e correnti sui nodi, necessari per l'annotazione completa.

> ⚠️ Esegui **`Ctrl+click` sulla freccia prima di ogni simulazione** — se modifichi il circuito, il file `tb_op.save` va rigenerato.

**Ctrl+S** → **Netlist** → **Simulate**.

### 3.3 Annotare il punto di lavoro

Dopo la simulazione, carica l'annotazione OP con **Waves → Op Annotate** → seleziona `tb_op.raw`. Naviga dentro il blocco comparatore con `E` → click sull'istanza per vedere i parametri annotati su ogni transistor.

### 3.4 Tabella di verifica

Compila la tabella confrontando i valori simulati con quelli attesi:

| Transistor | Ruolo | $I_D$ atteso | $I_D$ simulato | $g_m$ atteso | $g_m$ simulato | $V_{DS} > V_{DSAT}$? |
|------------|-------|-------------|----------------|-------------|----------------|----------------------|
| MN1 (= MN2) | Coppia diff. | 50 µA | | 600 µA/V | | ✓ / ✗ |
| MN3 (= MN4) | Latch NMOS | — | — | — | — | — |
| MP1 (= MP2) | Precarica `out` | — | — | — | — | — |
| MP3 (= MP4) | Precarica `sp`/`sn` | ~50 µA | | — | — | — |
| MP5 (= MP6) | Latch PMOS | — | — | — | — | — |

**Cosa aspettarsi in questa condizione artificiale:**

**MN1/MN2** sono gli unici transistor verificabili in modo significativo. Con CLK=0 e l'isource attivo, la corrente di 50 µA scorre attraverso la coppia differenziale e si osservano i valori di progetto: $g_m$ ≈ 600 µA/V, $V_{DS}$ ≈ 0.6 V (leggermente inferiore ai 0.9 V delle curve gm/Id, per cui è normale uno scostamento del 5–15% su $g_m$).

**MN3/MN4 (latch NMOS)** risultano praticamente spenti. Con CLK=0, i nodi `sp`/`sn` e `out_p`/`out_n` sono entrambi tirati verso VDD dai rispettivi PMOS di precarica: il drain e il source di MN3/MN4 sono quasi allo stesso potenziale → $V_{DS}$ ≈ 0 → transistor in triodo profondo, $I_D$ ≈ 0, $g_m$ irrisoria (ordine femtoampere/V). Non è un problema: in questa condizione artificiale il latch non è nella sua condizione operativa reale.

**MP5/MP6 (latch PMOS)** sono spenti. I loro gate sono collegati a `out_p`/`out_n` che con CLK=0 vengono riportati a VDD da MP1/MP2 → $V_{GS}$ = VDD − VDD = 0 → spenti. Non producono corrente né $g_m$ leggibile.

**MP1/MP2 (precarica `out`)** hanno $V_{DS}$ ≈ 0. Una volta che `out_p`/`out_n` raggiungono VDD all'equilibrio DC, il dislivello drain-source si annulla → $I_D$ ≈ 0, pur essendo pienamente accesi in termini di $V_{GS}$ = −1.8 V. Non producono un valore di $g_m$ utile in questa condizione.

**MP3/MP4 (precarica `sp`/`sn`)** sono gli unici PMOS attivi e misurabili. I nodi `sp`/`sn` non sono a VDD perché la corrente di MN1/MN2 li abbassa: MP3/MP4 operano con un $V_{DS}$ non nullo e si leggono valori significativi di $g_m$ e $g_{ds}$. Questi valori non vanno confrontati con il dimensionamento di progetto (che è pensato per la fase di reset, non per questo punto artificiale).

> ⚠️ Il parametro `region` **non è disponibile** nei modelli BSIM4 di SKY130A. La regione di funzionamento si ricava confrontando `vds` e `vdsat`: se `vds > vdsat` il transistor è in saturazione, se `vds < vdsat` è in regione lineare.

### 3.5 Rimuovere il generatore di corrente prima di procedere

> ⚠️ **Passo obbligatorio prima di qualsiasi simulazione successiva.** Apri `strongarm.sch`, seleziona l'`isource` e cancellalo (`Delete`). Salva con `Ctrl+S`. Tutte le simulazioni successive — transitoria, PVT, Monte Carlo — devono usare il circuito originale senza il generatore di corrente: la sua presenza altererebbe il comportamento dinamico e renderebbe i risultati non significativi.

---

## Parte 4 — Testbench transitorio nominale (`tb_tran.sch`)

Questo testbench verifica il funzionamento del circuito in condizioni nominali (corner TT, T = 27 °C, VDD = 1.8 V) e misura il tempo di decisione con un ingresso differenziale di 10 mV.

### 4.1 Struttura del testbench

Crea `tb_tran.sch`. Istanzia `strongarm.sym` al centro (`Shift+I` → naviga fino alla cartella del lab).

Aggiungi le sorgenti dalla libreria `devices`:

**VVDD** (`vsource`): `value = 1.8`, tra `VDD` e `GND`.

**VCLK** (`vsource`): `value="PULSE(0 1.8 25n 100p 100p 25n 50n)"`
→ V_low=0, V_high=1.8V, TD=25ns, TR=100ps, TF=100ps, PW=25ns, PER=50ns — clock a 20 MHz, parte basso per i primi 25 ns.

Con CLK = 0 (precarica): MP1/MP2/MP3/MP4 accesi ($V_{GS}$ = 0 − 1.8 = −1.8V), MNT spento. I nodi `out_p`, `out_n`, `sp`, `sn` vengono riportati a VDD. MP5/MP6 hanno gate su `out_p`/`out_n` (non su CLK): con entrambe le uscite a VDD, i gate di MP5/MP6 sono a VDD → MP5/MP6 spenti.

Con CLK = 1.8V (valutazione): MP1/MP2/MP3/MP4 spenti ($V_{GS}$ = 0), MNT acceso. La coppia differenziale integra; il latch CMOS (MN3/MN4 + MP5/MP6) rigenera. Man mano che `out_p` scende, MP6 (gate=`out_p`) si accende → tira `out_n` a VDD. Viceversa se vincesse `out_n`.

> ⚠️ I doppi apici sono obbligatori per qualsiasi valore che contiene parentesi o spazi nel campo `value` di una sorgente xschem. Senza di essi ngspice non riconosce correttamente il comando `PULSE`.

**VVIN_P** (`vsource`): `value = 0.905` → V_CM + 5 mV

**VVIN_N** (`vsource`): `value = 0.895` → V_CM − 5 mV

Quindi V_in,diff = 10 mV, circa 10 volte il 1-LSB della specifica.

**CL_P** e **CL_N** (`cap`): tra `out_p`/`out_n` e `GND`, `value = 20f`.

Aggiungi etichette `GND` ai poli negativi di tutte le sorgenti.

**Blocco TT_MODELS:** copialo da `top.sch` come nel Lab 1:
1. Apri `top.sch` (**File → Open** oppure lascialo aprire all'avvio di xschem)
2. Individua il blocco `TT_MODELS` sul canvas → `Ctrl+C`
3. Torna a `tb_tran.sch` → `Ctrl+V`, posizionalo nell'angolo in basso a sinistra

> ⚠️ Il blocco `TT_MODELS` va **solo nel testbench**, non nello schematico `strongarm.sch`.

### 4.2 Blocco di simulazione

Aggiungi un `devices/code_shown`:

```
value=".options savecurrents

.control
  save all
  tran 10p 110n

  meas tran t_clk_rise  WHEN v(clk)=0.9    RISE=2
  meas tran t_out_fall  WHEN v(out_p)=0.9  FALL=2
  let t_decision = t_out_fall - t_clk_rise
  let t_dec_ns = t_decision * 1e9
  echo Tempo di decisione (nominale TT 27C 1.8V) = $&t_dec_ns ns

  write tb_tran.raw

  plot v(clk)+2 v(out_p) v(out_n)
  plot v(x1.sp) v(x1.sn)
.endc"
```



> ⚠️ I nodi `sp` e `sn` sono interni al subcircuito `strongarm`. Dal testbench si accede con il percorso gerarchico `v(x1.sp)` e `v(x1.sn)`, dove `x1` è il nome dell'istanza nel testbench. Verifica il nome esatto aprendo la netlist con **Simulation → Show netlist**.

### 4.3 Eseguire e osservare

**Ctrl+S** → **Netlist** → **Simulate**.

La simulazione copre 110 ns — due cicli completi di clock. Con `PULSE(0 1.8 25n 100p 100p 25n 50n)` e TD=25ns, il clock parte a 0 e sale per la prima volta a t=25ns. **Cosa osservare:**

- **0–25 ns:** CLK = 0, precarica — `out_p`, `out_n`, `sp`, `sn` salgono a 1.8 V (MP1/MP2 caricano le uscite, MP3/MP4 caricano i nodi intermedi)
- **25–50 ns:** CLK = 1.8 V, prima valutazione — `out_p` scende verso 0 V (uscita vincente), `out_n` sale verso 1.8 V (uscita perdente, tirata attivamente a VDD da MP6)
- **50–75 ns:** CLK = 0, seconda precarica — MP1/MP2/MP3/MP4 riportano tutte le uscite e i nodi intermedi a 1.8 V
- **75–100 ns:** CLK = 1.8 V, seconda valutazione — stesso risultato, circuito stabile

> 💡 **Nell'architettura a 11 transistor entrambe le uscite raggiungono i rail durante la valutazione.** Quando `out_p` scende verso 0V, il gate di MP6 (collegato a `out_p`) si porta a 0V → MP6 si accende → tira `out_n` attivamente verso VDD. Il latch CMOS (MN3/MN4 + MP5/MP6) è un circuito bistabile completo: MN3 e MN4 scaricano le uscite verso GND, mentre MP5 e MP6 le tirano verso VDD, in senso convergente. Questo garantisce uscite a rail piene in tutte le condizioni di processo.

Il tempo di decisione viene stampato in console.

---

## Parte 5 — Simulazione PVT (`tb_pvt.sch`)

### Cosa si intende per PVT

Un circuito integrato deve funzionare correttamente non solo nelle condizioni nominali, ma lungo tutta la sua vita operativa. Le tre dimensioni della variabilità sono:

**P — Process:** i parametri dei transistor variano da wafer a wafer in funzione del processo fotolitografico. SKY130A fornisce cinque corner: `tt` (tipico), `ss` (lento-lento), `ff` (veloce-veloce), `sf` (lento NMOS, veloce PMOS), `fs` (veloce NMOS, lento PMOS).

**V — Voltage:** VDD varia tipicamente di ±10% → 1.62–1.98 V per un design SKY130A a 1.8 V nominale.

**T — Temperature:** il range operativo consumer standard è −40 °C a +125 °C.

Il prodotto cartesiano completo (5 corner × 3 T × 3 VDD) darebbe 45 simulazioni. In pratica si riduce a un insieme di **corner significativi** che coprono i casi fisicamente rilevanti:

| # | Corner processo | VDD | T | Nome convenzionale | Cosa verifica |
|---|----------------|-----|---|--------------------|---------------|
| 1 | `tt` | 1.80 V | 27 °C | Nominale | Punto di progetto |
| 2 | `ss` | 1.62 V | 125 °C | Worst speed | t_decision massimo — la specifica < 10 ns deve tenere |
| 3 | `ff` | 1.98 V | −40 °C | Best speed | t_decision minimo |
| 4 | `fs` | 1.80 V | 27 °C | Cross corner | NMOS veloci, PMOS lenti — asimmetria integrazione/precarica |
| 5 | `sf` | 1.80 V | 27 °C | Cross corner | NMOS lenti, PMOS veloci — caso opposto |

Il **worst case** assoluto per la velocità del comparatore è la combinazione SS + VDD minima + T massima: transistor lenti, meno corrente di coda, mobilità ridotta.

### 5.1 Setup del testbench PVT

Crea `tb_pvt.sch`. Struttura identica a `tb_tran.sch` con due differenze:

**1. Il corner viene incluso esplicitamente** — al posto del blocco `TT_MODELS`, inserisci un `code_shown` separato che contiene solo la riga `.lib`:

```
value=".lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice tt"
```

Questo blocco è il **selettore di corner**: per cambiare corner fai doppio click e sostituisci `tt` con `ss`, `ff`, `fs` o `sf`.

**2. VDD diventa parametrica** — nella sorgente `VVDD` imposta `value` a `{vdd_param}`. Il nome `vdd_param` è scelto diverso dal net `VDD` per evitare conflitti con `alterparam`.

Per VCLK: dipende dalla filosofia di design, ovvero se il clock è esterno al chip, il range di tensione potrebbe rimanere costante e indipendente da VDD, altrimenti se generato internamente potrebbe seguire le variazioni di VDD. Noi ci attestiamo su questa seconda ipoptesi e impostiamo VCLK con `value="PULSE(0 {vdd_param} 25n 100p 100p 25n 50n)"`.

### 5.2 Blocco di simulazione — doppio sweep T e VDD

Aggiungi un secondo `code_shown` con il blocco `.control`:

```
value=".param vdd_param=1.8
.options savecurrents

.control
  save all
  set appendwrite
  shell rm -f tb_pvt.raw
  set outfile = pvt_tt.txt
  echo T_C,VDD_V,t_decision_ns > $outfile

  foreach T_val -40 27 125
    foreach VDD_val 1.62 1.8 1.98
      set t_save   = $T_val
      set vdd_save = $VDD_val
      alterparam vdd_param = $vdd_save
      reset
      set temp = $t_save

      tran 10p 110n
      let thresh = $vdd_save / 2
      meas tran t_clk_rise  WHEN v(clk)=thresh    RISE=2
      meas tran t_out_fall  WHEN v(out_p)=thresh  FALL=2
      let t_decision = t_out_fall - t_clk_rise
      let t_dec_ns = t_decision * 1e9
      echo $t_save,$vdd_save,$&t_dec_ns >> $outfile
      echo T=$t_save VDD=$vdd_save t_decision=$&t_dec_ns ns
      write tb_pvt.raw
    end
  end
.endc"
```

> ⚠️ `reset` cancella le variabili di loop del `foreach`. È necessario salvarle in variabili `set` prima di `reset` — le variabili `set` e `let` persistono, quelle di `foreach` no.

> ⚠️ Il parametro si chiama `vdd_param` e non `VDD` per evitare un conflitto con il net `VDD` della netlist.

> ⚠️ `RISE=2` e `FALL=2` saltano il primo ciclo di clock (potenzialmente "sporco" per condizioni iniziali). Il secondo ciclo è già in regime stazionario.

> 💡 Le soglie `{vdd_param/2}` invece di `0.9` sono necessarie per una misura corretta al variare di VDD. Con soglia fissa a 0.9V: `out_p` parte da VDD e deve raggiungere 0.9V — con VDD = 1.62V il percorso è di 0.72V, con VDD = 1.98V è di 1.08V. Questo renderebbe t_decision apparentemente più lungo a VDD più alta, mascherando il vero effetto fisico (più VDD → più corrente → decisione più rapida).

> 💡 `set outfile = pvt_tt.txt` usa un nome fisso — l'utente lo cambia comunque insieme alla riga `.lib`, **Per cambiare corner** modifica la stringa nel blocco `.lib` e `set outfile` in modo coerente.

### 5.3 Eseguire i corner significativi

Per ciascuno dei 5 corner della tabella:

1. Fai **doppio click** sul blocco `.lib` e modifica la stringa del corner; aggiorna anche `set outfile` di conseguenza
2. **Ctrl+S** → **Netlist** → **Simulate**
3. Leggi dalla console i 9 valori di t_decision (3T × 3VDD)
4. Compila la tabella dei risultati

> 💡 `shell rm -f tb_pvt.raw` all'inizio del blocco `.control` elimina automaticamente il file del corner precedente prima di ogni nuova esecuzione — senza questo, `set appendwrite` accumulerebbe curve di corner diversi nello stesso file rendendo i grafici in xschem incoerenti.

### 5.3.1 Visualizzare le curve con GTKWave

Con 9 dataset per corner (3T × 3VDD) e più corner simulati, il viewer integrato di xschem e quello di ngspice diventano poco pratici: le curve si sovrappongono tutte con la stessa scala e non è facile selezionare, colorare o confrontare i segnali di interesse.

xschem integra un accesso diretto a **GTKWave**, uno strumento di visualizzazione molto più avanzato: dal menu **Waves → External viewer** si apre GTKWave con il file `.raw` corrente già caricato. GTKWave permette di selezionare i segnali da visualizzare tra quelli disponibili nel file, assegnare colori diversi alle curve, zoomare in modo indipendente su ciascun segnale, posizionare marker e misurare ritardi direttamente sul grafico.

Per visualizzare le curve analogiche in GTKWave: dopo aver aperto il file, trascina i segnali di interesse (es. `out_p`, `clk`) dal pannello SST (Signal Search Tree) a sinistra verso il pannello delle waveform. Clicca con il tasto destro su una curva → **Data Format → Analog → Step** per visualizzarla come segnale analogico continuo invece che digitale.

**Riferimenti:**
- Documentazione ufficiale GTKWave: [gtkwave.github.io/gtkwave](https://gtkwave.github.io/gtkwave/)
- Repository GitHub: [github.com/gtkwave/gtkwave](https://github.com/gtkwave/gtkwave)
- User's Guide completo (PDF): [gtkwave.sourceforge.net/gtkwave.pdf](https://gtkwave.sourceforge.net/gtkwave.pdf)

**Tabella dei risultati da completare:**

| Corner | VDD | T | t_decision (ns) | < 10 ns? |
|--------|-----|---|----------------|----------|
| `tt` | 1.80 V | 27 °C | | |
| `ss` | 1.62 V | 125 °C | | |
| `ss` | 1.80 V | 27 °C | | |
| `ss` | 1.98 V | −40 °C | | |
| `ff` | 1.98 V | −40 °C | | |
| `ff` | 1.80 V | 27 °C | | |
| `fs` | 1.80 V | 27 °C | | |
| `sf` | 1.80 V | 27 °C | | |

Non è necessario completare tutte le celle — concentrati sul corner nominale TT e sul worst case SS + 1.62V + 125°C.

> 💡 Al corner `ss` la soglia degli NMOS è ~50 mV più alta e la mobilità più bassa: $I_{tail}$ inferiore → $g_{m,pair}$ inferiore → $\Delta V_0$ più piccolo → la rigenerazione parte da un valore più basso → t_decision più lungo. Se il worst case SS rispetta ancora la specifica, il design è robusto.

### 5.3 Corner ridotti: identificare le simulazioni significative

Il doppio sweep della sezione 5.2 produce 9 simulazioni per esecuzione, per un totale di 45 combinazioni se si eseguissero tutti i corner. Per il comparatore Strong-ARM, molte di queste combinazioni sono ridondanti perché le due fasi del circuito dipendono da transistor diversi:

- **t_decision** dipende principalmente dagli **NMOS** (MNT, MN1/MN2, MN3/MN4) e dal **latch PMOS MP5/MP6** — tutti attivi durante la fase di valutazione. MP1/MP2/MP3/MP4 sono spenti (gate = CLK = 1.8V) e non contribuiscono. Il worst case per t_decision è il corner con NMOS **e** PMOS più lenti: **SS**, con VDD minima e T massima.

- **t_precharge** dipende dai **PMOS di precarica** (MP1/MP2 per `out_p`/`out_n`, MP3/MP4 per `sp`/`sn`) — tutti attivi durante il reset, tutti con gate su CLK. Il parametro misurato (tempo perché `out_p` risalga a VDD/2 dal fronte di discesa del clock) è determinato principalmente da MP1/MP2; MP3/MP4 ricaricano `sp`/`sn` in parallelo e raramente sono il collo di bottiglia. Il worst case per t_precharge è il corner con PMOS più lenti: **FS** (Fast NMOS, Slow PMOS), con VDD minima e T massima.

Il corner **SF** non produce un worst case per nessuno dei due parametri — NMOS lenti penalizzano t_decision ma PMOS veloci accelerano t_precharge, e viceversa — e può essere omesso. Rimangono quindi **4 corner significativi**:

| # | Corner `.lib` | VDD | T | Parametro critico | Motivazione |
|---|--------------|-----|---|-------------------|-------------|
| 1 | `tt` | 1.80 V | 27 °C | Entrambi | Condizione nominale di riferimento |
| 2 | `ss` | 1.62 V | 125 °C | t_decision | NMOS lenti + VDD bassa + T alta |
| 3 | `fs` | 1.62 V | 125 °C | t_precharge | PMOS lenti + VDD bassa + T alta |
| 4 | `ff` | 1.98 V | −40 °C | Entrambi | Best case — margine di velocità massimo |

### 5.4 Script per i corner ridotti (`tb_corners.sch`)

Con `tb_pvt.sch` aperto, salvalo con un nuovo nome: **File → Save As** → `tb_corners.sch`. In questo modo il testbench è già completo con tutte le sorgenti — l'unica cosa da fare è sostituire il contenuto del `code_shown` con lo script qui sotto.

In questo modo avrai tre testbench distinti nella cartella del lab, ciascuno con uno scopo preciso:
- `tb_pvt.sch` — doppio sweep 3T × 3VDD per un singolo corner
- `tb_corners.sch` — misura puntuale di t_decision e t_precharge per i 4 corner significativi
- `tb_mc.sch` — Monte Carlo per l'offset

Per ciascuno dei 4 corner, modifica la riga `.lib` nel selettore di corner, poi usa questo blocco di simulazione che misura **entrambi** i parametri critici in un'unica esecuzione:

```
value=".param vdd_param=1.8
.options savecurrents

.control
  save all

  tran 10p 160n

  * --- Misura t_decision ---
  let thresh = 0.9
  meas tran t_clk_rise   WHEN v(clk)=thresh      RISE=2
  meas tran t_out_fall   WHEN v(out_p)=thresh    FALL=2
  let t_decision = t_out_fall - t_clk_rise
  let t_dec_ns = t_decision * 1e9

  * --- Misura t_precharge ---
  * Dal fronte di discesa del clock alla risalita di out_p a VDD/2
  meas tran t_clk_fall   WHEN v(clk)=thresh      FALL=1
  meas tran t_prech_rise WHEN v(out_p)=thresh    RISE=1
  let t_precharge = t_prech_rise - t_clk_fall
  let t_prech_ns = t_precharge * 1e9

  echo t_decision  = $&t_dec_ns ns
  echo t_precharge = $&t_prech_ns ns

  write tb_corners.raw

  plot v(clk)+2 v(out_p) v(out_n)
.endc"
```

> 💡 La simulazione copre 160 ns per catturere almeno due cicli completi e garantire che il `meas` trovi sia il fronte di discesa del clock (t ≈ 75 ns, dopo la prima valutazione) che la successiva risalita di out_p durante la seconda precarica.

> ⚠️ Le condizioni VDD e T vanno impostate manualmente per ciascun corner: VDD si cambia nel valore di default del `.param` nel blocco, T si imposta aggiungendo `set temp = 125` (o −40) **dopo** il `save all` e **prima** del `tran`.

**Tabella dei risultati da completare:**

| Corner | VDD | T | t_decision (ns) | < 10 ns? | t_precharge (ns) | < 25 ns? |
|--------|-----|---|----------------|----------|-----------------|----------|
| `tt` | 1.80 V | 27 °C | | | | |
| `ss` | 1.62 V | 125 °C | | | | |
| `fs` | 1.62 V | 125 °C | | | | |
| `ff` | 1.98 V | −40 °C | | | | |

Il limite di 25 ns su t_precharge è derivato dalla specifica: la precarica deve completarsi entro la metà del periodo di clock (T_clk/2 = 25 ns) per garantire che le uscite siano a VDD prima della fase di valutazione successiva.

> ⚠️ Al termine delle simulazioni PVT, riporta il blocco del corner a `tt` prima di procedere con la Parte 6.

---

## Parte 6 — Simulazione Monte Carlo (`tb_mc.sch`)

### Mismatch e offset: dalla teoria alla simulazione

Anche con un ingresso perfettamente bilanciato (V_in,diff = 0), il comparatore reale farà sempre una scelta, determinata dalle variazioni statistiche dei parametri individuali di ciascun transistor. Questa è la manifestazione dell'**offset random**.

Nel Lab 2 abbiamo stimato il contributo principale tramite la legge di Pelgrom, applicata alla coppia differenziale MN1/MN2:

$$\sigma_{offset} = \sqrt{2} \cdot \frac{A_{VT}}{\sqrt{W \cdot L}} = \sqrt{2} \cdot \frac{3.5\ \text{mV}{\cdot}\text{µm}}{\sqrt{4\ \text{µm} \times 0.25\ \text{µm}}} \approx 4.95\ \text{mV}$$

La simulazione Monte Carlo sostituisce questo calcolo analitico con una misura diretta. SKY130A fornisce corner di modello dedicati che abilitano le variazioni statistiche di mismatch. I corner disponibili per l'analisi Monte Carlo sono:

| Corner | Descrizione | mc_mm_switch | mc_pr_switch |
|--------|-------------|-------------|-------------|
| `tt_mm` | Corner tipico + mismatch locale | 1 | 0 |
| `ss_mm` | Corner lento + mismatch locale | 1 | 0 |
| `ff_mm` | Corner veloce + mismatch locale | 1 | 0 |
| `sf_mm` | Slow NMOS/Fast PMOS + mismatch | 1 | 0 |
| `fs_mm` | Fast NMOS/Slow PMOS + mismatch | 1 | 0 |

In questi corner `mc_mm_switch=1` abilita il **mismatch locale**: ogni transistor riceve variazioni statistiche **indipendenti** di soglia e mobilità. `mc_pr_switch=0` disabilita invece le variazioni di processo globale (run-to-run), che non generano offset ma spostano tutti i transistor insieme — di solito modellate separatamente con i corner PVT già visti nella Parte 5.

> ⚠️ Non esiste un corner combinato processo+mismatch. Chi volesse valutare l'offset nel worst case deve eseguire run separati con `ss_mm` (processo lento + mismatch) e `ff_mm` (processo veloce + mismatch).

Ogni volta che la netlist viene ricaricata con `reset`, i generatori statistici interni ai modelli estraggono nuovi valori casuali per ogni transistor — un nuovo campione statistico. Eseguire `reset` + `tran` in un loop di 100 iterazioni equivale a simulare 100 chip diversi dello stesso progetto.

### 6.1 Setup del testbench Monte Carlo

Crea `tb_mc.sch`. Struttura identica a `tb_tran.sch`, con le seguenti differenze:

**Ingressi per la misura diretta dell'offset:**
- `VVIN_N`: `value = 0.9` — tensione di riferimento fissa a V_CM
- `VVIN_P`: `value = "PULSE(0.860 0.940 0 5u 1 1)"` — rampa lenta da 0.860V a 0.940V in 5µs (±40 mV rispetto a V_CM)

**Corner con mismatch — `corner.sym`:** al posto del blocco `TT_MODELS`, inserisci il componente `corner.sym` dalla libreria `sky130_fd_pr`. Selezionalo e imposta l'attributo `corner=tt_mm`. Questo componente genera automaticamente la riga `.lib` corretta con `mc_mm_switch=1` e `mc_pr_switch=0` già inclusi — non servono parametri aggiuntivi nel blocco di simulazione.

> ⚠️ Non aggiungere `.param mc_mm_switch=1` separatamente — il corner `tt_mm` lo include già. Aggiungere il `.param` dopo il `.lib` sarebbe ridondante; peggio, farlo **prima** del `.lib` risulterebbe in un reset a zero da parte del `.lib` stesso.

### 6.2 Principio di misura: ramp method

Invece di stimare σ indirettamente dall'error rate, misuriamo l'offset **direttamente** per ogni run.

**Idea chiave:** Vin+ rampa lentamente da 0.860V a 0.940V mentre il clock gira a 20 MHz (100 cicli × 50ns = 5µs). La rampa copre ±40 mV rispetto a V_CM per catturare l'intera distribuzione degli offset con l'architettura a 11 transistor (σ atteso ≈ 5 mV → ±40 mV copre ±8σ). Per ogni campione Monte Carlo (cioè ogni chip con un diverso pattern di mismatch), esiste un preciso istante in cui la comparazione si inverte — da "Vin+ perde" a "Vin+ vince". Quell'istante si individua rilevando la **prima caduta di `out_p` sotto VDD/2 = 0.9V**: in quel momento il valore di Vin+ corrisponde esattamente all'offset di quel campione.

```
Prima della soglia:   out_p = 1.8V (Vin+ perde → out_p rimane HIGH)
Dopo la soglia:       out_p = 0V   (Vin+ vince → out_p va LOW)
                      ↑
              cross_time: FALL=1 di out_p a 0.9V
              offset = v(vin_p, cross_time) − 0.9V
```

Rispetto all'approccio con binary error counting (vedi appendice A), questo metodo:
- Produce la **distribuzione completa** degli offset (non solo un singolo numero aggregato)
- Permette di calcolare media, sigma e plottare l'istogramma direttamente
- È lo stesso approccio usato nel corso Analog ASIC di IHP (Prof. Pretl)

### 6.3 Simulazione Monte Carlo — misura diretta dell'offset

```
value=".options savecurrents

.control
  let mc_runs = 100
  let mc_run = 1
  let results = unitvec(mc_runs)

  dowhile mc_run <= mc_runs
    reset
    tran 100p 5.5u

    * Primo FALL di out_p a VDD/2: il comparatore inverte la decisione
    meas tran cross_time WHEN v(out_p) = 0.9 FALL=1

    * L'offset e' la differenza d'ingresso in quell'istante
    meas tran vin_at_cross FIND v(vin_p) AT=cross_time
    let offset_run = vin_at_cross - 0.9
    set offset_save = $&offset_run
    set run_save = $&mc_run

    echo Run $&mc_run: offset = $&offset_run V

    op
    let offset_run = $offset_save
    let mc_run = $run_save
    let results[mc_run - 1] = offset_run
    remzerovec
    write tb_mc.raw
    set appendwrite
    let mc_run = mc_run + 1
  end

  * Calcolo statistico finale
  let mean_off = mean(results)
  let var_off = mean(results * results) - mean_off * mean_off
  let sigma_off = sqrt(var_off * mc_runs / (mc_runs - 1))

  echo ======================================
  echo Monte Carlo completato ($&mc_runs run)
  echo Media offset:  $&mean_off V
  echo Sigma offset:  $&sigma_off V
  echo Pelgrom atteso: ~4.95e-3 V
  echo ======================================

  print results > tb_mc.txt

  * Simulazione transitoria finale: mostra la rampa di Vin+ e come il
  * comparatore inverte la decisione al raggiungimento della soglia di offset
  unset appendwrite
  tran 100p 5.5u
  write tb_mc_tran.raw
.endc"
```

> 💡 `write tb_mc.raw offset_run` appare **prima** di `set appendwrite` all'interno del loop: alla prima iterazione il file viene creato o sovrascritto; dalla seconda iterazione `set appendwrite` è già attivo e ogni `write` accoda. Questo è lo stesso pattern usato in `montecarlo_mismatch_sim` di SKY130A ed è più robusto di `shell rm -f` perché non dipende da comandi di shell esterni.

> 💡 `print results > tb_mc.txt` salva il vettore completo degli offset come file di testo — utile per elaborazioni successive con Python o altri tool di post-processing dei dati.

> ⚠️ **Tempo di calcolo:** 100 run × 5.5µs con step 100ps = circa 10–15 minuti. Non interrompere la simulazione.

### 6.3.1 Visualizzazione con il launcher

Aggiungi due componenti **launcher** sul canvas di `tb_mc.sch`: `Ins` → `devices/launcher.sym`.

**Launcher 1 — forme d'onda dell'ultimo run:**
```
descr="Load last transient"
tclcommand="xschem raw_read $netlist_dir/tb_mc_tran.raw tran"
```
Carica `tb_mc_tran.raw` — si vede la rampa di Vin+, il clock e il momento in cui `out_p` scende indicando il superamento della soglia di offset.

**Launcher 2 — istogramma degli offset:**
```
descr="Load MC statistics"
tclcommand="
xschem raw_read $netlist_dir/tb_mc.raw op

proc mean_off {} {
  set sum 0
  set points [xschem raw points]
  foreach v [xschem raw values offset_run -1] {
    set sum [expr {$sum + $v}]
  }
  return [expr {$sum / $points}]
}

proc variance_off {mean} {
  set sum 0
  set points [xschem raw points]
  foreach v [xschem raw values offset_run -1] {
    set sum [expr {$sum + pow($v - $mean, 2)}]
  }
  return [expr {$sum / $points}]
}

proc get_histo {var mean min max step} {
  xschem raw switch 0
  proc xround {a size} { return [expr {round($a/$size) * $size}] }
  catch {unset freq}
  foreach v [xschem raw values $var -1] {
    set v [xround [expr {$v - $mean}] $step]
    if {![info exists freq($v)]} { set freq($v) 1 } else { incr freq($v) }
  }
  xschem raw new distrib distrib $var $min $max $step
  xschem raw add freq
  set j 0
  for {set i $min} {$i <= $max} {set i [expr {$i + $step}]} {
    set ii [xround $i $step]
    set v 0
    if {[info exists freq($ii)]} { set v $freq($ii) }
    xschem raw set freq $j $v
    incr j
  }
}

set mean [mean_off]
set variance [variance_off $mean]
set sigma [expr {sqrt($variance)}]
set samples [xschem raw points]

# Istogramma: ±40mV in step da 2mV (copre ±8sigma con sigma~5mV)
get_histo offset_run 0 -40e-3 40e-3 2e-3
set categories [xschem raw points]
puts "========================================"
puts "MC results: N=$samples runs"
puts "Mean offset: [format %.3f [expr {$mean*1000}]] mV"
puts "Sigma offset: [format %.3f [expr {$sigma*1000}]] mV"
puts "Pelgrom atteso: ~4.95 mV"
puts "========================================"
xschem reset_caches
xschem redraw
"
```

**Come visualizzare l'istogramma:** dopo aver fatto Ctrl+click sul launcher, apri un grafico (`Waves → Add waveform graph`), fai doppio click sul grafico → nelle properties imposta:
- **Raw file:** `distrib`
- **Sim type:** `distrib`

Compariranno le variabili `offset_run` (asse X) e `freq` (asse Y). Plotta `freq` — deve avere forma gaussiana centrata intorno a zero con σ ≈ 5 mV.

> 💡 Per annotare i risultati sul canvas in modo che si aggiornino automaticamente ad ogni esecuzione del launcher, usa **Tools → Insert text**, inserisci il testo seguente e nelle proprietà del blocco imposta **floater=yes** (senza questa proprietà xschem mostra la stringa letterale invece di valutarla). Opzionalmente imposta **layer=4** per colorare il testo in verde:
> ```
> tcleval(MC tt_mm
> N = $samples runs
> mean  = [format %.2f [expr {$mean*1000}]] mV
> sigma = [format %.2f [expr {$sigma*1000}]] mV
> Pelgrom: ~4.95 mV)
> ```
> `tcleval()` valuta l'espressione TCL al momento del ridisegno — le variabili `$samples`, `$mean` e `$sigma` vengono espanse con i valori calcolati dal launcher.



### 6.4 Confronto con la legge di Pelgrom

Completa la tabella con i risultati della simulazione:

| Parametro | Valore |
|-----------|--------|
| N run totali | 100 |
| Media offset misurata | ? mV |
| σ_offset misurata | ? mV |
| σ_offset da Pelgrom (solo MN1/MN2): $\sqrt{2} \cdot 3.5 / \sqrt{4 \times 0.25}$ | ≈ 4.95 mV |
| Scostamento simulazione / Pelgrom | ? % |

> 💡 Con l'architettura a 11 transistor, la **media** dell'offset dovrebbe essere prossima a zero — il bias sistematico negativo dell'architettura a 7 transistor è eliminato grazie al percorso attivo di MP5/MP6 verso VDD.

> 💡 **Il σ misurato sarà probabilmente maggiore di 4.95 mV — è atteso e fisicamente corretto.** La previsione di Pelgrom nel Lab 2 è una stima del solo contributo di MN1/MN2, ma tutti i transistor del comparatore contribuiscono all'offset in misura proporzionale al rapporto tra la propria $g_m$ e la $g_m$ della coppia differenziale. La formula completa è una somma in quadratura:

$$\sigma^2_{offset,tot} = \sigma^2_{MN1/MN2} + \left(\frac{g_{m,MN3}}{g_{m,pair}}\right)^2 \!\sigma^2_{\Delta V_{th},MN3/MN4} + \left(\frac{g_{m,MP5}}{g_{m,pair}}\right)^2 \!\sigma^2_{\Delta V_{th},MP5/MP6} + \ldots$$

> I transistor del latch (MN3/MN4 con $W \cdot L = 0.15\ \mu\text{m}^2$ e MP5/MP6 con $W \cdot L = 0.45\ \mu\text{m}^2$) hanno aree molto più piccole della coppia differenziale ($W \cdot L = 1\ \mu\text{m}^2$) → mismatch individuale molto più alto → contribuiscono significativamente al σ totale nonostante il fattore di attenuazione $g_{m,latch}/g_{m,pair}$. Il valore stimato includendo tutti i contributi principali è intorno a 7–10 mV, che è il range atteso dalla simulazione Monte Carlo. La previsione di Pelgrom da sola (4.95 mV) è quindi un **limite inferiore**, non una stima completa.

> 💡 Con 100 run, l'incertezza statistica su σ è di circa ±10% (errore standard della stima). Per una stima più precisa servirebbero ~1000 run, accettabile in produzione ma eccessivo per un lab — 100 run sono sufficienti per verificare l'ordine di grandezza.

### 6.5 Mismatch su corner di processo diversi

Per valutare come il mismatch si combina con il corner di processo, esegui run separati sostituendo `corner=tt_mm` con `corner=ss_mm` o `corner=ff_mm` nell'attributo del componente `corner.sym`.

Con `ss_mm`: i transistor sono più lenti **e** soggetti a mismatch — è il caso worst case per un comparatore in produzione. Ci si aspetta un σ_offset leggermente più alto rispetto a `tt_mm` perché la corrente di coda ridotta abbassa gm_pair, riducendo la capacità del comparatore di superare piccoli offset.

Questo dimostra che l'offset random (mismatch) e l'offset sistematico legato al corner (processo) sono fenomeni indipendenti: il primo dipende da variazioni device-to-device nello stesso chip, il secondo da variazioni wafer-to-wafer che spostano tutti i transistor nella stessa direzione.

---

## Domande di riflessione

1. Dallo sweep di temperatura: calcola il coefficiente di variazione $\Delta t_{decision} / \Delta T$ tra $-40\ °C$ e $+125\ °C$. È compatibile con la dipendenza della mobilità degli NMOS dalla temperatura ($\mu_n \propto T^{-1.5}$, con $T$ in Kelvin)?

2. La simulazione nominale (corner TT, $V_{DD}$ = 1.8 V, $V_{diff}$ = 10 mV) dà $t_{decision} \ll 1\ \text{ns}$, molto inferiore alla specifica di 10 ns e anche alla stima analitica del Lab 2 di ~5 ns. Non c'è una contraddizione — la differenza è nell'ingresso usato. Il calcolo del Lab 2 era per $V_{diff}$ = 1 mV (worst case 1 LSB), mentre il testbench usa 10 mV. Usa la formula $\Delta V_0 = g_{m,pair} \cdot V_{diff} / (2 C_L) \cdot t_{int}$ per calcolare $\Delta V_0$ con $V_{diff}$ = 10 mV e $t_{int}$ = 5 ns. Poi calcola $t_{decision} = t_{int} + \tau_{regen} \cdot \ln(V_{DD}/2\ /\ \Delta V_0)$ con $\tau_{regen}$ = 28.6 ps e verifica che il risultato sia coerente con la simulazione. Infine ripeti il calcolo per $V_{diff}$ = 1 mV e confronta con la specifica.

3. Dal confronto tra corner `tt` e `ss`: di quanto si allunga $\tau_{regen} = C_L / (g_{m,MN3} + g_{m,MP5})$? Al corner `ss` la soglia degli NMOS aumenta di circa 50 mV e quella dei PMOS di circa 50 mV — entrambi i contributi al latch CMOS si riducono. Stima la riduzione di $g_{m,inv} = g_{m,MN3} + g_{m,MP5}$ e confronta con il valore misurato.

4. Dalla Monte Carlo: il $\sigma_{offset}$ misurato è sensibilmente più alto della stima di Pelgrom (4.95 mV) perché i transistor del latch (MN3/MN4 e MP5/MP6), avendo aree molto piccole, contribuiscono al budget di offset. Identifica quale transistor contribuisce di più e perché. Se volessi ridurre $\sigma_{offset}$ a ~5 mV agendo sul dimensionamento del latch, quale modifica faresti su MN3/MN4? Qual è il costo in velocità di rigenerazione ($\tau_{regen}$) e in area?

5. Il confronto tra `tt_mm` e `ss_mm` mostra che $\sigma_{offset}$ cambia poco passando da un corner all'altro. Perché? In quale condizione il corner di processo potrebbe invece avere un impatto significativo sull'offset di un comparatore?

---

## Riepilogo

| Concetto | Cosa hai imparato |
|----------|-------------------|
| Cross-coupling con etichette | `lab_wire` per NMOS e PMOS latch — attenzione: la cross-coupling PMOS ha gate e drain nella direzione opposta rispetto alla NMOS |
| `TT_MODELS` nel testbench | Va aggiunto solo al livello più alto della gerarchia, non nello schematico del circuito |
| Verifica `.op` prima del transitorio | Si aggiunge un `isource` ideale da 100 µA in parallelo a MNT dentro `strongarm.sch` e si imposta CLK = 0 (tutti i PMOS accesi); discrepanze del 5–15% su $g_m$ e $I_D$ sono fisiologiche; MP1–MP4 operano fuori dal punto di lavoro in questa condizione; rimuovere `isource` prima del transitorio |
| `set temp` + `reset` | Sweep di temperatura in loop `foreach` — stessa logica di `alterparam` + `reset` |
| `alterparam` + `reset` | Sweep parametrico di VDD — stesso pattern usato nel Lab 2 per lo sweep di L |
| Corner di processo | La stringa nel `.lib` non è parametrizzabile: cambio manuale tra un run e l'altro |
| `set appendwrite` + `write` | Accumula N run nello stesso `.raw` per visualizzazione sovrapposta delle forme d'onda |
| `corner.sym` con `tt_mm` | Abilita il mismatch Monte Carlo in SKY130A — `mc_mm_switch=1` già incluso nel corner |
| `reset` in loop `dowhile` | Genera campioni statistici indipendenti a ogni iterazione Monte Carlo |
| Ramp method | Misura diretta dell'offset: Vin+ rampa lentamente, si rileva il punto di inversione della decisione |
| Pelgrom vs MC | La simulazione deve dare sigma ≈ sqrt(2) * A_VT / sqrt(WL) ≈ 5 mV |

Nel prossimo modulo (Modulo 2 — SKY130A PDK) esploreremo la struttura del PDK, le celle standard e le librerie di modelli. Il comparatore Strong-ARM tornerà come blocco di riferimento nel Modulo 5 (Mixed-Signal), dove verrà integrato con un SAR controller digitale.

---

## Soluzione

Il file di soluzione completo è disponibile in [`soluzioni/lab03/`](./soluzioni/lab03/).

---

## Appendice A — Metodo alternativo: Binary Error Counting

Il metodo presentato nella Parte 6 (ramp method) misura l'offset direttamente. Un approccio alternativo, concettualmente più semplice ma meno ricco di informazioni, è il **binary error counting**.

**Principio:** con un ingresso differenziale fisso V_diff = 5 mV, si contano i run in cui il comparatore decide erroneamente. Il tasso di errore è legato a σ tramite la funzione di errore complementare.

**Derivazione.** L'offset V_os è una variabile casuale gaussiana N(0, σ²). Un errore si verifica quando V_os > V_diff:

$$P(\text{errore}) = P(V_{os} > V_{diff}) = Q\!\left(\frac{V_{diff}}{\sigma}\right) = \frac{1}{2}\,\text{erfc}\!\left(\frac{V_{diff}}{\sigma\sqrt{2}}\right)$$

Invertendo, si ricava σ dall'error rate misurato. Con V_diff = 5 mV:

| Error rate misurato | σ_offset stimato |
|--------------------|-----------------|
| ~ 0.50 | σ >> 10 mV → errore di setup |
| ~ 0.31 | σ ≈ 10 mV |
| ~ 0.21 | σ ≈  6 mV |
| ~ 0.16 | σ ≈  5 mV (atteso da Pelgrom) |
| ~ 0.10 | σ ≈  4 mV |

**Riferimenti:**
- B. Razavi, *Design of Analog CMOS Integrated Circuits*, 2a ed., McGraw-Hill, 2017
- Wikipedia, *Q-function*: [en.wikipedia.org/wiki/Q-function](https://en.wikipedia.org/wiki/Q-function)
- GaussianWaves, *Q function and Error functions: demystified*: [gaussianwaves.com](https://www.gaussianwaves.com/2012/07/q-function-and-error-functions/)

**Limiti rispetto al ramp method:** fornisce solo σ aggregato (non la distribuzione), richiede la scelta a priori di V_diff appropriato, e con 100 run ha un'incertezza statistica di ±10% su σ. Il ramp method è preferibile quando si vuole verificare la gaussianità della distribuzione o confrontare con Pelgrom in modo diretto.

---

## Appendice B — Introduzione a CACE per la caratterizzazione automatica

### Cos'è CACE

**CACE** (Circuit Automatic Characterization Engine) è uno strumento open-source sviluppato originariamente per la piattaforma Efabless e ora mantenuto dalla **FOSSi Foundation** (repo: [github.com/fossi-foundation/cace](https://github.com/fossi-foundation/cace), documentazione: [cace.readthedocs.io](https://cace.readthedocs.io/en/latest/index.html)).

CACE automatizza il processo che in questo lab hai eseguito manualmente — sweep PVT, corner di processo, Monte Carlo — e produce un **report strutturato** con valori minimi/tipici/massimi, indicatori pass/fail rispetto alle specifiche, tabelle e grafici. È lo stesso tipo di report che un foundry o un cliente si aspetta come documentazione di un blocco analogico.

Il flusso CACE è complementare a xschem/ngspice, non lo sostituisce:

```
xschem (schematico + testbench template)
    ↓
CACE (legge il YAML, genera le netlist, lancia ngspice, raccoglie risultati)
    ↓
Report HTML / Markdown con tabelle pass/fail
```

### CACE nel container IIC-OSIC-TOOLS

CACE è incluso nel container IIC-OSIC-TOOLS a partire dalla versione 2024.x. Verifica la disponibilità con:

```bash
cace --version
cace --help
```

> ⚠️ La versione mantenuta da FOSSi Foundation (v2.8.x) ha breaking changes rispetto alla versione legacy Efabless: il campo `electrical_parameters` è stato unificato in `parameters`; l'interfaccia grafica `cace-gui` (Tkinter) è stata sostituita da `cace-web`; ngspice viene sempre lanciato in batch mode. Verifica la versione installata nel container prima di usare esempi da risorse datate.

### Struttura del progetto per CACE

La struttura di cartelle consigliata per un progetto CACE (basata sul progetto di riferimento OTA-5T di Leo Moser, [github.com/mole99/sky130\_leo\_ip\_\_ota5t](https://github.com/mole99/sky130_leo_ip__ota5t)):

```
lab03/
├── xschem/
│   └── strongarm.sch          ← schematico del circuito (invariato)
├── cace/
│   ├── strongarm_comparator.yaml   ← file di specifica CACE
│   └── templates/
│       └── tb_cace_tran.sch   ← testbench template con placeholder CACE{...}
└── run/                       ← creata automaticamente da CACE (output)
    └── TIMESTAMP/
        ├── results/
        └── report/
```

### Il testbench template

I testbench per CACE non sono normali schematici xschem — contengono **placeholder** nella forma `CACE{nome_condizione}` che CACE sostituisce automaticamente prima di lanciare ngspice. Questo permette di definire una volta sola la struttura della simulazione e farla girare su tutte le combinazioni di corner/temperatura/VDD.

Esempio di blocco di simulazione in `tb_cace_tran.sch` (campo `value` del `code_shown`):

```spice
.lib /foss/pdks/sky130A/libs.tech/ngspice/sky130.lib.spice CACE{corner}
.param vdd_val = CACE{vdd}

.options savecurrents

VVDD vdd gnd dc {vdd_val}
VCLK clk gnd PULSE(0 {vdd_val} 25n 100p 100p 25n 50n)
VVIN_P vin_p gnd dc CACE{vin_p}
VVIN_N vin_n gnd dc CACE{vin_n}
CL_P out_p gnd 20f
CL_N out_n gnd 20f

.temp CACE{temperature}

.control
  save all
  tran 10p 110n

  meas tran t_clk_rise  WHEN v(clk)={vdd_val/2}   RISE=2
  meas tran t_out_fall  WHEN v(out_p)={vdd_val/2} FALL=2
  let t_decision = (t_out_fall - t_clk_rise) * 1e9
  print t_decision > $raw_file
.endc
```

> 💡 La variabile `$raw_file` è fornita da CACE e punta al file di output della simulazione corrente. La sintassi `CACE{nome}` viene sostituita da CACE con il valore della condizione corrispondente prima di passare la netlist a ngspice.

### Il file YAML di specifica

Il file YAML è il cuore di CACE: definisce le specifiche del circuito, le condizioni di simulazione e come estrarre i risultati. Esempio per il comparatore Strong-ARM:

```yaml
# cace/strongarm_comparator.yaml
name: strongarm_comparator
description: Comparatore Strong-ARM Latch a 11 transistor — SKY130A
PDK: sky130A
cace_format: 9.0

paths:
  root: ..
  schematic: xschem
  netlist: netlist
  documentation: docs

default_conditions:
  vdd:
    description: Tensione di alimentazione
    display: VDD
    unit: V
    typical: 1.8
  temperature:
    description: Temperatura ambiente
    display: T
    unit: "°C"
    typical: 27
  corner:
    description: Corner di processo
    display: Corner
    typical: tt
  vin_p:
    description: Ingresso positivo (V_CM + V_diff/2)
    display: VIN+
    unit: V
    typical: 0.905
  vin_n:
    description: Ingresso negativo (V_CM - V_diff/2)
    display: VIN-
    unit: V
    typical: 0.895

parameters:

  t_decision:
    description: Tempo di decisione
    display: t_decision
    unit: ns
    spec:
      maximum:
        value: 10
        fail: any
    simulate:
      tool: ngspice
      template: tb_cace_tran.sch
      format: ascii
      measure:
        - {result: t_decision, name: t_decision}
    conditions:
      corner:
        enumerate: [tt, ss, ff, fs, sf]
      vdd:
        minimum: 1.62
        typical: 1.80
        maximum: 1.98
      temperature:
        minimum: -40
        typical: 27
        maximum: 125

  t_precharge:
    description: Tempo di precarica
    display: t_precharge
    unit: ns
    spec:
      maximum:
        value: 25
        fail: any
    simulate:
      tool: ngspice
      template: tb_cace_tran.sch
      format: ascii
      measure:
        - {result: t_precharge, name: t_precharge}
    conditions:
      corner:
        enumerate: [tt, fs]
      vdd:
        minimum: 1.62
        typical: 1.80
      temperature:
        minimum: -40
        typical: 27
        maximum: 125
```

### Lanciare CACE

Dalla cartella radice del progetto:

```bash
cd /foss/designs/modulo1/lab03
cace cace/strongarm_comparator.yaml
```

CACE genera le netlist per ogni combinazione di condizioni, lancia ngspice in batch mode, raccoglie i risultati e produce un report sotto `run/TIMESTAMP/`. Per visualizzare il report nella interfaccia web:

```bash
cace-web cace/strongarm_comparator.yaml
```

Questo apre un browser con il report interattivo, che include tabelle pass/fail, grafici dei parametri misurati per corner e temperatura, e un sommario generale.

### Esempio di output CACE (tabella t_decision)

```
Parameter: t_decision [ns]      Spec: max = 10 ns

Corner  VDD    T      Value    Pass?
------  -----  -----  -------  ------
tt      1.80V  27°C   5.07 ns  PASS ✓
ss      1.62V  125°C  7.83 ns  PASS ✓
ss      1.62V  -40°C  3.21 ns  PASS ✓
ff      1.98V  -40°C  2.15 ns  PASS ✓
fs      1.80V  27°C   5.44 ns  PASS ✓

Summary: 5/5 PASS
```

### Riferimenti

- Documentazione CACE: [cace.readthedocs.io](https://cace.readthedocs.io/en/latest/index.html)
- Repository FOSSi Foundation: [github.com/fossi-foundation/cace](https://github.com/fossi-foundation/cace)
- Progetto di riferimento OTA-5T (Leo Moser): [github.com/mole99/sky130\_leo\_ip\_\_ota5t](https://github.com/mole99/sky130_leo_ip__ota5t)
- Talk Latch-Up 2024 (Tim Edwards): [archive.org/details/latch\_2024-CACE\_Study](https://archive.org/details/latch_2024-CACE_Study_Open_source_analog_and_mixedsignal_design_flow)
