# Setup su Linux

> Guida testata su **Ubuntu 22.04 LTS** e **Ubuntu 24.04 LTS**. Dovrebbe funzionare anche su Fedora e altre distribuzioni con adattamenti minimi. Tempo stimato: 20–30 minuti.

---

## Panoramica dei passaggi

```
1. Installare git  →  2. Installare Docker  →  3. Clonare IIC-OSIC-TOOLS
→  4. Configurare le variabili d'ambiente  →  5. Avviare il container
→  6. Clonare LibreLane Summary  →  7. Configurazione del PDK  →  8. Test finale
```

---

## Passo 1 — Installare git

Se git non è già presente sul sistema, installalo con:

```bash
sudo apt-get install git
```

Su Fedora:

```bash
sudo dnf install git
```

---

## Passo 2 — Installare Docker

Segui le istruzioni ufficiali di IIC-OSIC-TOOLS per installare Docker Engine:

👉 https://github.com/iic-jku/IIC-OSIC-TOOLS?tab=readme-ov-file#4-quick-launch-for-designers

> ⚠️ **Post-install obbligatorio:** segui le istruzioni post-installazione per aggiungere il tuo utente al gruppo `docker`. Questo evita di dover eseguire i tool come `root`, il che causerebbe problemi di permessi sui file di progetto.
>
> ```bash
> sudo usermod -aG docker $USER
> ```
> Dopo questo comando, **esci dalla sessione e rientra** (oppure riavvia) affinché la modifica sia effettiva.

Verifica che Docker funzioni correttamente eseguendo:

```bash
docker run hello-world
```

Se vedi il messaggio di benvenuto, Docker è installato correttamente.

---

## Passo 3 — Clonare IIC-OSIC-TOOLS

Apri un terminale e clona il repository alla versione **2025.07**:

```bash
git clone https://github.com/iic-jku/IIC-OSIC-TOOLS.git -b 2025.07
```

> 🔒 **Perché una versione specifica?** Fissare la versione garantisce che tutti gli studenti del corso abbiano esattamente gli stessi tool e le stesse librerie. Non usare `latest` o `main` — potrebbero introdurre incompatibilità con gli esercizi del corso.

---

## Passo 4 — Configurare le variabili d'ambiente

Il container ha bisogno di due variabili d'ambiente prima di partire:

| Variabile | Significato |
|-----------|-------------|
| `DESIGNS` | Cartella sul tuo PC dove salverai tutti i tuoi progetti |
| `DOCKER_TAG` | Versione del container da usare (deve essere `2025.07`) |

### 4a — Creare la cartella dei progetti

Crea una cartella dedicata ai tuoi design ASIC:

```bash
mkdir ~/asic
```

### 4b — Rendere le variabili persistenti

Per non doverle reimpostare ad ogni sessione, aggiungile in fondo al file `~/.bashrc`:

```bash
echo 'export DOCKER_TAG=2025.07' >> ~/.bashrc
echo 'export DESIGNS=~/asic' >> ~/.bashrc
source ~/.bashrc
```

> ✅ Il comando `source ~/.bashrc` applica le modifiche nella sessione corrente senza dover aprire un nuovo terminale.

---

## Passo 5 — Avviare il container

Portati nella cartella dove hai clonato IIC-OSIC-TOOLS ed esegui lo script di avvio:

```bash
cd IIC-OSIC-TOOLS
./start_x.sh
```

La **prima volta** il comando scaricherà l'immagine Docker dal registro remoto (~15 GB). Ci vorranno alcuni minuti a seconda della tua connessione. Le volte successive il container si avvierà in pochi secondi.

Al termine si aprirà automaticamente una finestra del browser con l'interfaccia grafica del container.

### Riavvii successivi

La prossima volta che vorrai usare il container, riesegui `./start_x.sh` dalla stessa cartella. Lo script ti proporrà due opzioni se il container esiste già:

- **`s`** — avvia il container esistente
- **`r`** — rimuovi il container e ricrealo da zero

Usa `s` nella maggior parte dei casi. Usa `r` solo se il container è corrotto o vuoi ripartire pulito (non perderai i file in `~/asic` perché sono sul tuo filesystem, non dentro il container).

---

## Passo 6 — Clonare LibreLane Summary

LibreLane Summary è uno script che fornisce un riepilogo leggibile dei risultati prodotti dal flusso OpenLane. Lo useremo nei moduli avanzati del corso.

Dal terminale dentro il container, portati nella cartella dei design ed esegui il clone:

```bash
cd /foss/designs
git clone https://github.com/mattvenn/librelane_summary
```

Troverai la cartella `librelane_summary/` direttamente nella tua cartella `~/asic/` — è persistente e non andrà persa al riavvio del container.

---

## Passo 7 — Configurazione del PDK

Dobbiamo creare il file `.designinit` che il container legge automaticamente ad ogni avvio per impostare tutte le variabili d'ambiente del PDK.

**Dove va creato:** nella cartella `/foss/designs/` dentro il container, che corrisponde alla tua cartella `~/asic/` su Linux. Essendo una cartella montata (non interna al container), il file **sopravvive ai riavvii e alle ricreazioni del container**.

Dal terminale dentro il container, esegui:

```bash
cat > /foss/designs/.designinit << 'EOF'
PDK_ROOT=/foss/pdks
PDK=sky130A
PDKPATH=/foss/pdks/sky130A
STD_CELL_LIBRARY=sky130_fd_sc_hd
SPICE_USERINIT_DIR=/foss/pdks/sky130A/libs.tech/ngspice
KLAYOUT_PATH=/headless/.klayout:/foss/pdks/sky130A/libs.tech/klayout:/foss/pdks/sky130A/libs.tech/klayout/tech
PATH=$PATH:/foss/designs/librelane_summary
EOF
```

In alternativa, puoi crearlo direttamente dal terminale Linux (fuori dal container) nella cartella `~/asic/`:

```bash
cat > ~/asic/.designinit << 'EOF'
PDK_ROOT=/foss/pdks
PDK=sky130A
PDKPATH=/foss/pdks/sky130A
STD_CELL_LIBRARY=sky130_fd_sc_hd
SPICE_USERINIT_DIR=/foss/pdks/sky130A/libs.tech/ngspice
KLAYOUT_PATH=/headless/.klayout:/foss/pdks/sky130A/libs.tech/klayout:/foss/pdks/sky130A/libs.tech/klayout/tech
PATH=$PATH:/foss/designs/librelane_summary
EOF
```

Il risultato è identico — il file apparirà come `/foss/designs/.designinit` dentro il container.

> 💡 `.designinit` è l'equivalente di un `.bashrc` specifico per il PDK: le variabili qui definite saranno disponibili automaticamente in ogni sessione del container, senza doverle riesportare ogni volta.

---

## Passo 8 — Test finale

Esegui questi comandi all'interno del container per verificare che tutto funzioni:

```bash
echo $IIC_OSIC_TOOLS_VERSION   # atteso: 2025.07
echo $PDK                       # atteso: sky130A
klayout &                       # deve aprire KLayout 0.30.2
xschem &                        # deve aprire xschem
```

Se tutti i comandi producono l'output atteso, l'ambiente è configurato correttamente. 🎉

---

## Troubleshooting

### Errore "permission denied" eseguendo `./start_x.sh`
Lo script non ha i permessi di esecuzione. Correggilo con:
```bash
chmod +x start_x.sh
```

### Errore "Got permission denied while trying to connect to the Docker daemon"
Il tuo utente non è nel gruppo `docker`. Esegui:
```bash
sudo usermod -aG docker $USER
```
Poi esci dalla sessione e rientra.

### La GUI non si apre nel browser
Il container usa un server X accessibile via browser sulla porta 6080. Se non si apre automaticamente, prova ad aprire manualmente:
```
http://localhost
```
Controlla anche che nessun firewall locale blocchi la porta.

### Le variabili d'ambiente non sono riconosciute dentro il container
Verifica che `DESIGNS` e `DOCKER_TAG` siano impostate correttamente nel terminale da cui hai lanciato `./start_x.sh`:
```bash
echo $DESIGNS
echo $DOCKER_TAG
```
Se sono vuote, ricontrolla il tuo `~/.bashrc` e riesegui `source ~/.bashrc`.

---

## Prossimo passo

Una volta completato il setup, passa al [Modulo 1 — Schematic & Simulazione con xschem/ngspice](../01_xschem_ngspice/).
