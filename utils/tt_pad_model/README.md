# tt_pad_model — Modello SPICE del pad TinyTapeout

Modello del pad di un chip TinyTapeout per simulazioni xschem/ngspice.
Include bond wire del package, capacità di pad e routing, ESD/protezione,
e i passgate del multiplexer TinyTapeout. Permette di simulare il
comportamento di un blocco analogico **come visto al pin esterno del chip**,
non solo come misurato al nodo interno del proprio design.

---

## A cosa serve

Tra il nodo interno del tile e il piedino del package esiste una catena di
elementi parassiti che modificano il comportamento del segnale:

- **Bond wire** del package: ~1 Ω serie + ~1 nH di induttanza
- **Capacità di pad e di routing**: ~5 pF totale verso massa
- **Multiplexer TinyTapeout**: passgate CMOS 5V con ~50 Ω di resistenza di canale
  e non-linearità dipendenti dalla tensione

Per progetti analogici questi parassiti contano sempre, anche quando la
frequenza di taglio del filtro RC equivalente (~640 MHz) sembra distante
dalla banda del segnale: la **resistenza serie altera l'impedenza vista in
uscita** del circuito, e i **passgate del mux introducono distorsione
non-lineare** dipendente dal livello del segnale.

> Per un approfondimento sull'architettura del chip TinyTapeout e sul ruolo
> del multiplexer, vedi [docs/INFO.md del tt-multiplexer](https://github.com/TinyTapeout/tt-multiplexer/blob/main/docs/INFO.md).

---

## File presenti

| File | Descrizione |
|------|-------------|
| `pad_model.sch` | Schematico del modello completo (bond wire + pad cap + ESD + mux passgate) |
| `pad_model.sym` | Simbolo da istanziare nei testbench xschem |
| `vgnd_loc.sym` | Simbolo di alimentazione locale `VGND` usato internamente dal modello |
| `vpwr_loc.sym` | Simbolo di alimentazione locale `VAPWR` (3.3V) usato internamente dal modello |

Il modello è derivato da quello pubblicato da Sylvain Munaut nella documentazione
ufficiale TinyTapeout e usa transistor `nfet_g5v0d10v5`/`pfet_g5v0d10v5` del PDK
SKY130A per modellare i passgate 5V del multiplexer.

---

## Come si usa

### 1. Copia i file nella cartella xschem del tuo progetto

```bash
cp /percorso/a/utils/tt_pad_model/*.sym /percorso/al/tuo/progetto/xschem/
cp /percorso/a/utils/tt_pad_model/*.sch /percorso/al/tuo/progetto/xschem/
```

### 2. Istanzia il simbolo nel testbench

Apri il testbench xschem e inserisci un'istanza di `pad_model` tra ogni
uscita analogica del tuo design e il nodo che rappresenta il pin esterno
del chip.

Il simbolo ha tre pin:

| Pin del simbolo | A cosa connetterlo |
|---|---|
| `pin` | nodo esterno (lato package / bond wire) — questo è il punto in cui sondare il segnale come viene misurato sul piedino del chip |
| `mod` | nodo interno del tile (uscita del tuo blocco) |
| `VGND` | massa locale del modello |

Schema di connessione tipico:

```
[Tuo design]                  [pad_model]                  [Mondo esterno]
  uscita (mod) ────────► pad_model ────────────► uscita_ext (pin)
```

Le sonde di misura nel testbench vanno spostate dal nodo interno (`uscita`)
al nodo esterno (`uscita_ext`) — quello è ciò che si legge sul piedino
del chip una volta fabbricato.

### 3. Aggiungi l'alimentazione VAPWR

Il modello opera a **3.3V** (`VAPWR`) perché i mux TinyTapeout usano transistor
5V del PDK SKY130A. Aggiungi al testbench una sorgente `VAPWR = 3.3V`,
indipendentemente dalla tensione di alimentazione del tuo design (tipicamente
1.8V per circuiti analogici SKY130A standard).

```spice
* Nel testbench:
V_vapwr VAPWR 0 3.3
```

### 4. Esegui la simulazione

Riesegui le simulazioni di sistema (transitoria, AC, FFT, ecc.) con il
pad model inserito e confronta i risultati con quelli senza pad.

**Cosa cercare nel confronto:**

- **Variazione dell'impedenza vista in uscita** — se il blocco è un buffer o
  un driver, la pendenza della risposta a un gradino cambia rispetto alla
  simulazione standalone
- **Distorsione armonica** — se il segnale ha ampiezza confrontabile con
  `VAPWR/2`, l'attenuazione del passgate diventa non-lineare e compaiono
  armoniche di ordine pari (analizza con FFT)
- **Filtro RC nel range di interesse** — per segnali sub-MHz l'effetto è
  trascurabile; per segnali RF (>10 MHz) verifica l'attenuazione e adatta
  il design se serve

---

## Modello semplificato (alternativa per simulazioni veloci)

Se il modello completo è troppo lento per simulazioni Monte Carlo o
long-transient, puoi usare un modello equivalente lineare:

- una resistenza da **50 Ω** in serie tra `mod` e `pin`
- un condensatore da **5 pF** tra `pin` e massa

Cattura l'effetto dominante del filtro RC ma **non** la non-linearità del
passgate. Adatto per una prima verifica veloce; per il signoff finale
prima del tape-out usa sempre il modello completo.

---

## Crediti

Modello adattato dal lavoro di **Sylvain Munaut** (`tnt@246tNt.com`) per
la documentazione ufficiale TinyTapeout. La versione qui presente è stata
adattata per essere autoconsistente e includere i simboli di alimentazione
locale necessari per la simulazione standalone in xschem.
