# Setup su Windows

> Guida testata su **Windows 10 (22H2)** e **Windows 11**. Tempo stimato: 30–45 minuti.

---

## Panoramica dei passaggi

```
1. Abilitare WSL2  →  2. Installare Docker Desktop  →  3. Scaricare IIC-OSIC-TOOLS
→  4. Configurare le variabili d'ambiente  →  5. Avviare il container
→  6. Clonare LibreLane Summary  →  7. Configurazione del PDK  →  8. Test finale
```

---

## Passo 1 — WSL2 (Windows Subsystem for Linux)

Docker su Windows si appoggia a **WSL2** per eseguire container Linux in modo efficiente. Prima di installare Docker, verifica se WSL è già presente aprendo un terminale (`cmd` o PowerShell) ed eseguendo:

```cmd
wsl --status
```

**Se WSL non è installato**, esegui questi due comandi in sequenza:

```cmd
wsl --install
wsl --update
```

Al termine, **riavvia il computer** prima di procedere.

> 💡 `wsl --install` installa automaticamente Ubuntu come distribuzione predefinita. Non è necessario usarla direttamente — serve solo come backend per Docker.

---

## Passo 2 — Docker Desktop

Scarica e installa Docker Desktop seguendo le istruzioni ufficiali di IIC-OSIC-TOOLS:

👉 https://github.com/iic-jku/IIC-OSIC-TOOLS?tab=readme-ov-file#4-quick-launch-for-designers

Durante l'installazione, assicurati che l'opzione **"Use WSL 2 instead of Hyper-V"** sia selezionata (di solito lo è per default su Windows 10/11).

**Riavvia nuovamente il computer** al termine dell'installazione.

Dopo il riavvio, avvia Docker Desktop dal menu Start. Al primo avvio ti verrà chiesto di creare un account Docker Hub — puoi registrarti gratuitamente oppure accedere con il tuo account Google o GitHub.

> ⚠️ Docker Desktop deve essere **in esecuzione** (icona visibile nella barra delle applicazioni) ogni volta che vuoi usare il container. Se l'icona non è presente, avvia Docker Desktop dal menu Start.

---

## Passo 3 — Scaricare IIC-OSIC-TOOLS

Scarica il file archivio della versione **2025.07** da questo link:

👉 https://github.com/iic-jku/IIC-OSIC-TOOLS/archive/refs/tags/2025.07.zip

Decomprimi il file in una posizione comoda, ad esempio `C:\Users\<tuonome>\iic-osic-tools`.

> 🔒 **Perché una versione specifica?** Fissare la versione garantisce che tutti gli studenti del corso abbiano esattamente gli stessi tool e le stesse librerie. Non usare `latest` — potrebbe introdurre incompatibilità con gli esercizi del corso.

---

## Passo 4 — Configurare le variabili d'ambiente

Il container ha bisogno di due informazioni prima di partire:

| Variabile | Significato |
|-----------|-------------|
| `DESIGNS` | Cartella sul tuo PC dove salverai tutti i tuoi progetti |
| `DOCKER_TAG` | Versione del container da usare (deve essere `2025.07`) |

### 4a — Creare la cartella dei progetti

Crea una cartella dedicata ai tuoi design ASIC. Esempio:

```
C:\Users\<tuonome>\asic
```

Puoi farlo da Esplora File o da terminale:

```cmd
mkdir C:\Users\%USERNAME%\asic
```

### 4b — Impostare le variabili in modo permanente

Apri **PowerShell come Amministratore** (tasto destro sull'icona PowerShell → "Esegui come amministratore") ed esegui:

```powershell
setx DOCKER_TAG "2025.07" /M
setx DESIGNS "C:\Users\<tuonome>\asic" /M
```

Sostituisci `<tuonome>` con il tuo nome utente Windows effettivo.

Il flag `/M` rende le variabili **persistenti a livello di sistema**, quindi sopravvivono ai riavvii. Senza questo passaggio, dovresti reimpostare le variabili ogni volta che apri un nuovo terminale.

> ✅ Dopo aver eseguito questi comandi, **chiudi e riapri il terminale** affinché le variabili siano attive.

---

## Passo 5 — Avviare il container

1. Assicurati che **Docker Desktop sia in esecuzione**
2. Apri un terminale (`cmd` o PowerShell) nella cartella dove hai decompresso IIC-OSIC-TOOLS
3. Esegui:

```cmd
.\start_x.bat
```

La **prima volta** il comando scaricherà l'immagine Docker dal registro remoto (~15 GB). Ci vorranno alcuni minuti a seconda della tua connessione. Le volte successive il container si avvierà in pochi secondi.

Al termine vedrai aprirsi un browser con l'interfaccia grafica del container.

---

## Passo 6 — Clonare LibreLane Summary

LibreLane Summary è uno script che fornisce un riepilogo leggibile dei risultati prodotti dal flusso OpenLane. Lo useremo nei moduli avanzati del corso.

Dal terminale dentro il container, portati nella cartella dei design ed esegui il clone:

```bash
cd /foss/designs
git clone https://github.com/mattvenn/librelane_summary
```

Troverai la cartella `librelane_summary/` direttamente nella tua directory `asic\` su Windows — è persistente e non andrà persa al riavvio del container.

---

## Passo 7 — Configurazione del PDK

Dobbiamo creare il file `.designinit` che il container legge automaticamente ad ogni avvio per impostare tutte le variabili d'ambiente del PDK.

**Dove va creato:** nella cartella `/foss/designs/` dentro il container, che corrisponde alla tua cartella `asic\` su Windows. Essendo una cartella montata (non interna al container), il file **sopravvive ai riavvii e alle ricreazioni del container**.

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

In alternativa, puoi creare il file `.designinit` direttamente da Windows con un editor di testo (Notepad, VS Code) nella cartella `asic\`, incollandoci il contenuto sopra. Il risultato è identico.

> 💡 `.designinit` è l'equivalente di un `.bashrc` specifico per il PDK: le variabili qui definite saranno disponibili automaticamente in ogni sessione del container, senza doverle riesportare ogni volta.

> ⚠️ **Nota sul PATH:** la riga `PATH=$PATH:/foss/designs/librelane_summary` aggiunge lo script di LibreLane Summary al path di sistema — per questo era necessario clonare il repository nel passo precedente prima di creare questo file.

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

## Gestione del container

### Chiudere il container
Il container si ferma automaticamente quando chiudi la finestra del terminale principale. Puoi anche fermarlo dalla GUI di Docker Desktop usando il pulsante ■ (Stop).

### Riavviare il container
Assicurati che Docker Desktop sia in esecuzione, poi:

```cmd
.\start_x.bat
```

Se il container è già stato avviato in precedenza ma è fermo, puoi riavviarlo più rapidamente con:

```cmd
docker start iic-osic-tools_xserver
```

Oppure usa il pulsante ▶ (Play) nella GUI di Docker Desktop.

---

## Troubleshooting

### La GUI non si apre / schermo nero
Il container usa un server X per la grafica. Se la GUI non appare:
- Controlla che nessun firewall blocchi le connessioni locali sulla porta 6080
- Prova ad aprire manualmente `http://localhost` nel browser

### Errore "WSL 2 installation is incomplete"
Riesegui `wsl --update` in un terminale con privilegi di amministratore e riavvia.

### Errore "port is already allocated"
Un altro servizio sta usando la stessa porta. Riavvia Docker Desktop, oppure ferma tutti i container attivi con:
```cmd
docker stop $(docker ps -q)
```

### Le variabili d'ambiente non sono riconosciute
Dopo `setx`, devi aprire un **nuovo** terminale. Le variabili non vengono aggiornate nelle finestre già aperte.

---

## Prossimo passo

Una volta completato il setup, passa al [Modulo 1 — Schematic & Simulazione con xschem/ngspice](../01_xschem_ngspice/).
