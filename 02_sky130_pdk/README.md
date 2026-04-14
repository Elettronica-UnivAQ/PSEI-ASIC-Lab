# Modulo 2 — Librerie SKY130A e design del CDAC

## Obiettivi

Al termine di questo modulo lo studente sarà in grado di:

- Navigare autonomamente le librerie del PDK SKY130A e identificare componenti, modelli SPICE e simboli xschem
- Comprendere il ruolo dei parametri `nf` (finger) e `mult` (molteplicità) nei transistor e il loro impatto su resistenza di gate, capacità parassita e matching
- Usare le capacità MiM (`sky130_fd_pr__cap_mim_m3_1`) in un progetto xschem
- Dimensionare la capacità unitaria $C_u$ del CDAC in base ai vincoli di rumore $kT/C$ e di matching (legge di Pelgrom per le capacità MiM)
- Disegnare e simulare un CDAC a 8 bit a ridistribuzione di carica, che integra la funzione di campionamento (S&H) e di conversione D/A

---

## Il CDAC nel convertitore SAR

Questo modulo produce il secondo blocco del SAR ADC a 8 bit del corso. Il CDAC (Capacitive Digital-to-Analog Converter) svolge simultaneamente il ruolo di campionatore e di DAC: durante la fase di campionamento i condensatori immagazzinano la tensione di ingresso; durante la conversione le bottom plate vengono commutate dal controller digitale (Modulo 4) per implementare la ricerca per bisezione.

```
VIN ──► [ CDAC 8 bit + S&H ]──► [ Comparatore Strong-ARM ]──► [ Controller SAR ]
              ▲ Modulo 2              ▲ Modulo 1                   ▲ Modulo 4
              └──────────────── B[7:0] (bottom-plate drive) ───────┘
```

**Specifiche di riferimento:** 8 bit · $V_{DD} = 1.8\ \text{V}$ · $V_{FS,diff} = 256\ \text{mV}$ · 1 LSB = 1 mV · $V_{CM} = 0.9\ \text{V}$ · $f_s = 2\ \text{MS/s}$

---

## Prerequisiti

- Ambiente Docker IIC-OSIC-TOOLS configurato e funzionante → [Modulo 0](../00_setup/)
- Modulo 1 completato: familiarità con xschem, ngspice, simulazioni transitorie e metodo $g_m/I_D$
- In particolare: il dimensionamento del comparatore Strong-ARM (Lab02) e la sua simulazione (Lab03) sono richiamati nel `lab_cdac.md` per collegare i due blocchi del SAR

---

## Struttura del modulo

| File | Argomento | Tempo stimato |
|------|-----------|---------------|
| [`pdk_structure.md`](./pdk_structure.md) | Struttura del PDK SKY130A — librerie, naming, MiM, finger e molteplicità | ~25 min |
| [`standard_cells.md`](./standard_cells.md) | Celle standard `sky130_fd_sc_hd` — struttura, naming, esplorazione con KLayout | ~15 min |
| [`lab_cdac.md`](./lab_cdac.md) | Design e simulazione del CDAC a 8 bit con capacità MiM + Monte Carlo | ~105 min |

---

## Come lavorare

Ogni file è strutturato in tre parti:

1. **Teoria e motivazione** — perché questo componente o questa scelta architetturale
2. **Esplorazione/Procedura** — comandi da terminale, passi in xschem e ngspice
3. **Domande di riflessione** — valori da leggere dai grafici o da calcolare (placeholder `?`)

Leggi `pdk_structure.md` e `standard_cells.md` prima di entrare nel lab: le informazioni sui componenti MiM e sulla struttura del PDK sono necessarie per il `lab_cdac.md`.

---

## Avviare l'ambiente

Prima di iniziare, verifica che il container sia in esecuzione e il PDK sia configurato:

```bash
# Verifica che le variabili siano attive
echo $PDK          # atteso: sky130A
echo $PDK_ROOT     # atteso: /foss/pdks

# Crea la cartella di lavoro per questo modulo
mkdir -p /foss/designs/modulo2
cd /foss/designs/modulo2
```

---

## Riferimenti utili

- [SKY130A PDK — device details](https://skywater-pdk.readthedocs.io/en/main/rules/device-details.html)
- [SKY130A PDK — librerie disponibili](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/foundry-provided.html)
- [xschem documentation](https://xschem.sourceforge.io/stefan/xschem_man/xschem_man.html)
- [ngspice manual](https://ngspice.sourceforge.io/docs/ngspice-manual.pdf)
- Appendice: [xschem cheatsheet](../assets/cheatsheets/xschem_cheatsheet.md) *(disponibile a breve)*
- Appendice: [ngspice cheatsheet](../assets/cheatsheets/ngspice_cheatsheet.md) *(disponibile a breve)*
