# PSEI — Progettazione di Sistemi Elettronici Integrati
## Laboratorio Open-Source ASIC Design

**Università degli Studi dell'Aquila** · Corso di Laurea Magistrale in Ingegneria Elettronica  
**A.A. 2025/2026** · 3 CFU (30 ore) · Modulo Laboratoriale

---

> *"The best way to learn chip design is to design a chip."*  
> In questo laboratorio lo facciamo davvero — con strumenti open-source e una tecnologia reale da 130nm.

---

## 🎯 Obiettivi del laboratorio

Al termine delle 30 ore di laboratorio, lo studente sarà in grado di:

- Configurare e utilizzare un ambiente professionale di progettazione ASIC basato su container Docker
- Disegnare e simulare circuiti analogici con **xschem** e **ngspice** usando il PDK **SkyWater SKY130A**
- Realizzare layout di circuiti integrati con **Magic VLSI** e verificarli con DRC e LVS
- Eseguire un flusso di sintesi digitale RTL→GDS completo con **LibreLane**
- Sottomettere un progetto reale alla piattaforma **TinyTapeout** per la produzione su silicio

---

## 🗺️ Struttura del laboratorio

| # | Modulo | Argomenti | Ore |
|---|--------|-----------|-----|
| 0 | [Setup dell'ambiente](./00_setup/) | Docker, IIC-OSIC-TOOLS, PDK SKY130A | 2h |
| 1 | [Schematic & Simulazione](./01_xschem_ngspice/) | xschem, ngspice, DC / AC / Transiente | 5h |
| 2 | [Librerie SKY130A](./02_sky130_pdk/) | Struttura del PDK, celle standard, SPICE models | 3h |
| 3 | [Layout con Magic VLSI](./03_magic_layout/) | DRC interattivo, routing, strati di processo | 5h |
| 4 | [Verifica DRC & LVS](./04_drc_lvs/) | Magic DRC, Netgen LVS, correzione errori | 3h |
| 5 | [Flusso digitale LibreLane](./05_openlane_digital/) | RTL→GDS, vincoli di timing, place & route | 5h |
| 6 | [Mixed-Signal Design](./06_mixed_signal/) | Integrazione blocchi analogici e digitali | 4h |
| 7 | [Progetto TinyTapeout](./07_tinytapeout/) | Specifiche, consegna, criteri di valutazione | 3h |

---

## 🧰 Stack tecnologico

Tutti gli strumenti utilizzati nel corso sono **open-source e gratuiti**:

| Tool | Funzione |
|------|----------|
| [IIC-OSIC-TOOLS](https://github.com/iic-jku/IIC-OSIC-TOOLS) | Container Docker con tutti gli strumenti preinstallati |
| [xschem](https://xschem.sourceforge.io/) | Editor di schematici |
| [ngspice](https://ngspice.sourceforge.io/) | Simulatore SPICE |
| [Magic VLSI](http://opencircuitdesign.com/magic/) | Editor di layout |
| [Netgen](http://opencircuitdesign.com/netgen/) | LVS (Layout vs Schematic) |
| [LibreLane](https://librelane.readthedocs.io/en/stable/) | Flusso RTL→GDS per design digitali |
| [KLayout](https://www.klayout.de/) | Visualizzatore e editor GDS |
| [SkyWater SKY130A PDK](https://github.com/google/skywater-pdk) | Process Design Kit a 130nm |
| [TinyTapeout](https://tinytapeout.com/) | Piattaforma di tapeout condiviso |

---

## 🚀 Come iniziare

1. **Configura l'ambiente** → segui la guida in [`00_setup/`](./00_setup/) per il tuo sistema operativo
2. **Clona questo repository** nella cartella `DESIGNS` che hai creato durante il setup:
   ```bash
   git clone https://github.com/Elettronica-UnivAQ/PSEI-ASIC-Lab.git
   ```
3. **Segui i moduli in ordine** — ogni cartella contiene un `README.md` introduttivo e una serie di lab numerati

---

## 🏭 I chip dei nostri studenti

I progetti realizzati dagli studenti del corso vengono sottomessi su TinyTapeout e sono visibili nell'organizzazione GitHub del laboratorio:

👉 [github.com/Elettronica-UnivAQ](https://github.com/Elettronica-UnivAQ)

---

## 📚 Riferimenti utili

- [SkyWater SKY130 PDK Documentation](https://skywater-pdk.readthedocs.io/)
- [TinyTapeout Documentation](https://tinytapeout.com/docs/)
- [IIC-OSIC-TOOLS Wiki](https://github.com/iic-jku/IIC-OSIC-TOOLS/wiki)
- [Xschem Tutorial](https://xschem.sourceforge.io/stefan/xschem_man/xschem_man.html)
- [Magic VLSI Tutorial](http://opencircuitdesign.com/magic/tutorials/)

---

## 👨‍🏫 Docente

**Prof. Alfiero Leoni** — Ricercatore a Tempo Determinato (RTDb)  
Dipartimento di Ingegneria Industriale e dell'Informazione e di Economia  
Università degli Studi dell'Aquila  
📧 [alfiero.leoni@univaq.it](mailto:alfiero.leoni@univaq.it)  
🐙 [github.com/Elettronica-UnivAQ](https://github.com/Elettronica-UnivAQ)

---

## 📄 Licenza

Il materiale didattico di questo repository è distribuito sotto licenza  
**Creative Commons Attribution 4.0 International (CC BY 4.0)**.  
Puoi usarlo, adattarlo e ridistribuirlo citando la fonte.

[![CC BY 4.0](https://licensebuttons.net/l/by/4.0/88x31.png)](https://creativecommons.org/licenses/by/4.0/)
