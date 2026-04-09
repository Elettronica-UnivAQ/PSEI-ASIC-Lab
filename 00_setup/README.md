# Modulo 0 — Setup dell'ambiente di lavoro

## Obiettivo

In questo modulo configureremo l'ambiente completo di progettazione ASIC che utilizzeremo per tutto il corso. Alla fine avrai sul tuo computer un sistema funzionante con oltre 40 tool open-source di EDA (Electronic Design Automation), completamente isolato dal resto del sistema operativo e riproducibile su qualsiasi macchina.

---

## Perché Docker?

L'ambiente di lavoro è distribuito come **container Docker** tramite il progetto open-source [IIC-OSIC-TOOLS](https://github.com/iic-jku/IIC-OSIC-TOOLS), sviluppato dall'istituto [Johannes Kepler University (JKU)](https://www.jku.at/en/institute-for-integrated-circuits-and-quantum-computing/).

Questo approccio permette a tutti gli studenti di lavorare con **esattamente la stessa versione di ogni tool**, indipendentemente dal sistema operativo host. Nessuna dipendenza da installare manualmente, nessun conflitto di librerie.

```
Il tuo laptop (Windows / macOS / Linux)
    └── Docker Engine
            └── Container IIC-OSIC-TOOLS v2025.07
                    ├── xschem          ← editor schematici
                    ├── ngspice         ← simulatore SPICE 
                    ├── ghdl            ← simulatore VHDL 
                    ├── gtkwave         ← visualizzatore forme d'onda digitali
                    ├── Magic VLSI      ← editor di layout
                    ├── Netgen          ← LVS 
                    ├── LibreLane       ← flusso RTL→GDS con supporto VHDL
                    ├── KLayout         ← visualizzatore GDS
                    └── PDK SKY130A     ← già incluso nel container
```

---

## Scegli il tuo sistema operativo

| Sistema operativo | Guida |
|---|---|
| 🪟 Windows 10 / 11 | [windows.md](./windows.md) |
| 🍎 macOS (Intel o Apple Silicon) | [macos.md](./macos.md) |
| 🐧 Linux (Ubuntu / Fedora) | [linux.md](./linux.md) |

> ⚠️ **Requisiti minimi consigliati:** 8 GB RAM (16 GB consigliati), 30 GB di spazio libero su disco, processore a 64 bit.

---

## Cosa installeremo

1. **Docker Desktop** — gestore di container
2. **IIC-OSIC-TOOLS** — il container con tutti i tool EDA
3. **LibreLane Summary** — tool per l'analisi dei risultati del flusso digitale
4. **File `.designinit`** — configura automaticamente PDK e percorsi ad ogni avvio del container, incluso il browser dei file di xschem
5. **Visual Studio Code** — editor VHDL con linting e supporto al linguaggio

---

## Verifica finale

Al termine del setup, indipendentemente dal tuo sistema operativo, dovresti essere in grado di:

```bash
# Dentro il container, esegui questi comandi:
echo $IIC_OSIC_TOOLS_VERSION   # deve stampare: 2025.07
echo $PDK                       # deve stampare: sky130A
klayout &                       # deve aprire l'interfaccia grafica di KLayout
xschem &                        # deve aprire xschem
```

Se tutti e quattro i comandi producono l'output atteso, l'ambiente è pronto. Procedi al [Modulo 1](../01_xschem_ngspice/).

---

## Il flusso VHDL nel corso

A partire dal **Modulo 4**, scriveremo design digitali in **VHDL** e li porteremo fino al GDS con LibreLane. Il container include tutto il necessario:

| Tool | Funzione | Dove si usa |
|------|----------|-------------|
| `ghdl` | Compilatore e simulatore VHDL | Terminal del container |
| `gtkwave` | Visualizzatore di forme d'onda | Terminal del container |
| `librelane --flow VHDLClassic` | Sintesi VHDL→GDS (RTL to GDS) | Terminal del container |

Per **scrivere** il codice VHDL useremo invece **Visual Studio Code** sul tuo sistema operativo, con due estensioni che forniscono linting e supporto al linguaggio in tempo reale. Poiché la cartella `~/asic/` sul tuo computer è la stessa cartella che il container vede come `/foss/designs/`, i file scritti in VS Code sono immediatamente disponibili nel container senza alcuna copia o sincronizzazione manuale.

---

## Problemi comuni

| Problema | Soluzione |
|----------|-----------|
| Il container si avvia ma non vedi la GUI | Vedi la sezione "Troubleshooting grafico" nella guida del tuo OS |
| `docker: command not found` | Docker Desktop non è installato correttamente — reinstalla |
| Spazio su disco insufficiente | Il container pesa ~15 GB — libera spazio o usa un disco esterno |
| RAM insufficiente | Chiudi altre applicazioni; con meno di 8 GB alcuni tool potrebbero essere lenti |
| VS Code non riconosce i file `.vhd` | Verifica che l'estensione VHDL LS sia installata e abilitata |
