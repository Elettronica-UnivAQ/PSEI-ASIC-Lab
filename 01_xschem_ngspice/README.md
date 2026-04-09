# Modulo 1 — Schematic Capture e Simulazione con xschem e ngspice

## Obiettivi

Al termine di questo modulo lo studente sarà in grado di:

- Navigare l'interfaccia di xschem e creare uno schematico da zero
- Istanziare dispositivi dal PDK SKY130A (MOSFET, resistori, sorgenti)
- Configurare ed eseguire simulazioni DC, AC e transitorie con ngspice
- Caratterizzare un MOSFET SKY130A e applicare il metodo gm/Id per il dimensionamento
- Progettare e verificare un comparatore Strong-ARM Latch con simulazioni DC, transitorie, PVT e Monte Carlo
- Eseguire simulazioni di corner e Monte Carlo per valutare la robustezza del progetto

---

## Prerequisiti

- Ambiente Docker IIC-OSIC-TOOLS configurato e funzionante → [Modulo 0](../00_setup/)
- Conoscenza di base dei MOSFET (regioni di funzionamento, modello di piccolo segnale, gm, rds)
- Familiarità con l'analisi di circuiti analogici (polarizzazione, guadagno, risposta in frequenza)

---

## Struttura del modulo

| Lab | Argomento | Tempo stimato |
|-----|-----------|---------------|
| [Lab 1](./lab01_intro_xschem_ngspice.md) | Primi passi con xschem e ngspice — inverter CMOS | 1.5h |
| [Lab 2](./lab02_gmid_caratterizzazione.md) | Caratterizzazione MOSFET SKY130A e metodo gm/Id — dimensionamento Strong-ARM | 2h |
| [Lab 3](./lab03_strongarm_latch.md) | Design e simulazione del comparatore Strong-ARM Latch | 1.5h |

---

## Come lavorare

Ogni lab è strutturato in tre parti:

1. **Obiettivo e schema del circuito** — cosa si costruisce e perché
2. **Procedura guidata** — passi dettagliati in xschem e ngspice
3. **Analisi dei risultati** — domande per verificare la comprensione

I file di soluzione sono nella cartella [`soluzioni/`](./soluzioni/) — prova a completare ogni lab prima di consultarli.

---

## Avviare l'ambiente

Prima di iniziare, assicurati che il container sia in esecuzione e il PDK sia configurato:

```bash
# Verifica che le variabili siano attive
echo $PDK          # atteso: sky130A
echo $PDK_ROOT     # atteso: /foss/pdks

# Crea la cartella di lavoro per questo modulo
mkdir -p /foss/designs/modulo1
cd /foss/designs/modulo1
```

---

## Riferimenti utili

- [xschem documentation](https://xschem.sourceforge.io/stefan/xschem_man/xschem_man.html)
- [ngspice manual](https://ngspice.sourceforge.io/docs/ngspice-manual.pdf)
- [SKY130A PDK — device models](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/foundry-provided.html)
- Appendice: [xschem cheatsheet](../assets/cheatsheets/xschem_cheatsheet.md) *(disponibile a breve)*
- Appendice: [ngspice cheatsheet](../assets/cheatsheets/ngspice_cheatsheet.md) *(disponibile a breve)*
