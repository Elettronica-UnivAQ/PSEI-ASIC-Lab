# Modulo 0 — Setup dell'ambiente di lavoro

## Obiettivo

In questo modulo configureremo l'ambiente completo di progettazione ASIC che utilizzeremo per tutto il corso. Alla fine avrai sul tuo computer un sistema funzionante con oltre 40 tool professionali di EDA (Electronic Design Automation), completamente isolato dal resto del sistema operativo e riproducibile su qualsiasi macchina.

---

## Perché Docker?

L'ambiente di lavoro è distribuito come **container Docker** tramite il progetto open-source [IIC-OSIC-TOOLS](https://github.com/iic-jku/IIC-OSIC-TOOLS), sviluppato dal Department for Integrated Circuits (ICD), Johannes Kepler University (JKU).

Questo approccio risolve il problema storico del "funziona solo sulla mia macchina": tutti gli studenti lavorano con **esattamente la stessa versione di ogni tool**, indipendentemente dal sistema operativo host. Nessuna dipendenza da installare manualmente, nessun conflitto di librerie.

```
Il tuo laptop (Windows / macOS / Linux)
    └── Docker Engine
            └── Container IIC-OSIC-TOOLS v2025.07
                    ├── xschem
                    ├── ngspice
                    ├── Magic VLSI
                    ├── Netgen
                    ├── OpenLane
                    ├── KLayout
                    └── PDK SKY130A  ← già incluso nel container
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

1. **Docker Desktop** — il motore dove gira il container IIC-OSIC-TOOLS
2. **IIC-OSIC-TOOLS** — il container con tutti i tool EDA
3. **Configurazione PDK** — variabili d'ambiente per puntare al SkyWater SKY130A

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

## Problemi comuni

| Problema | Soluzione |
|----------|-----------|
| Il container si avvia ma non vedi la GUI | Vedi la sezione "Troubleshooting grafico" nella guida del tuo OS |
| `docker: command not found` | Docker Desktop non è installato correttamente — reinstalla |
| Spazio su disco insufficiente | Il container pesa ~15 GB — libera spazio o usa un disco esterno |
| RAM insufficiente | Chiudi altre applicazioni; con meno di 8 GB alcuni tool potrebbero essere lenti |
