# Risorse di riferimento — PSEI Lab (Modulo 1)

> Raccolta di link utili per gli strumenti, le tecnologie e gli argomenti teorici trattati nei Lab 01–03 del corso PSEI.  
> I link con ⭐ sono quelli ritenuti particolarmente utili come punto di partenza.

---

## 🛠️ Strumenti del flusso di design

### xschem — Editor di schematici

| Risorsa | Descrizione |
|---------|-------------|
| [Manuale ufficiale xschem](https://xschem.sourceforge.io/stefan/xschem_man/xschem_man.html) ⭐ | Riferimento completo: comandi, netlist, simboli, TCL |
| [Codeberg: xschem (repo principale)](https://codeberg.org/stef_xschem/xschem) | Repository sorgente attivo (GitHub è in fase di dismissione) |
| [GitHub: xschem (mirror)](https://github.com/StefanSchippers/xschem) | Mirror transitorio — verrà sostituito da Codeberg |
| [iic-jku/analog-circuit-design](https://iic-jku.github.io/analog-circuit-design/) ⭐ | Corso JKU di Harald Pretl con esempi xschem, testbench e notebook gm/Id |
| [Come usare subcircuits del PDK in xschem](https://xschem.sourceforge.io/stefan/xschem_man/tutorial_use_existing_subckt.html) | Tutorial ufficiale — gestione delle gerarchie |

### ngspice — Simulatore SPICE

| Risorsa | Descrizione |
|---------|-------------|
| [ngspice.sourceforge.io](https://ngspice.sourceforge.io) ⭐ | Sito ufficiale |
| [Manuale ngspice (PDF)](https://ngspice.sourceforge.io/docs/ngspice-manual.pdf) ⭐ | Manuale completo — riferimento per `.control`, `meas`, `foreach`, `alterparam` |
| [Manuale ngspice (HTML navigabile)](https://ngspice.sourceforge.io/docs/ngspice-html-manual/manual.xhtml) | Versione online, con motore di ricerca |
| [Tutorial ngspice per principianti](https://ngspice.sourceforge.io/ngspice-tutorial.html) | Introduzione alla sintassi SPICE e ai comandi base |

### GTKWave — Visualizzatore di waveform

| Risorsa | Descrizione |
|---------|-------------|
| [gtkwave.github.io](https://gtkwave.github.io/gtkwave/) | Sito ufficiale |
| [Repository GitHub](https://github.com/gtkwave/gtkwave) | Sorgente e issue tracker |
| [User's Guide (PDF)](https://gtkwave.sourceforge.net/gtkwave.pdf) | Manuale completo |

### IIC-OSIC-TOOLS — Container Docker

| Risorsa | Descrizione |
|---------|-------------|
| [github.com/iic-jku/IIC-OSIC-TOOLS](https://github.com/iic-jku/IIC-OSIC-TOOLS) ⭐ | Repository principale — istruzioni di installazione e changelog versioni |
| [IIC-OSIC-TOOLS Wiki](https://github.com/iic-jku/IIC-OSIC-TOOLS/wiki) | FAQ, configurazione avanzata, lista dei tool inclusi |

### SKY130A PDK — Process Design Kit

| Risorsa | Descrizione |
|---------|-------------|
| [skywater-pdk.readthedocs.io](https://skywater-pdk.readthedocs.io/en/main/) ⭐ | Documentazione ufficiale SKY130A — celle, dispositivi, regole DRC |
| [github.com/google/skywater-pdk](https://github.com/google/skywater-pdk) | Repository PDK |
| [Librerie sky130_fd_pr (FOSSi)](https://github.com/fossi-foundation/skywater-pdk-libs-sky130_fd_pr) | Modelli SPICE dei dispositivi primitivi SKY130A, mantenuti da FOSSi Foundation |
| [sky130_fd_sc_hd — celle standard](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/sky130_fd_sc_hd/README.html) | Documentazione delle celle standard high-density SKY130A |

### CACE — Circuit Automatic Characterization Engine

| Risorsa | Descrizione |
|---------|-------------|
| [cace.readthedocs.io](https://cace.readthedocs.io/en/latest/index.html) ⭐ | Documentazione ufficiale (FOSSi Foundation, v2.8.x) |
| [github.com/fossi-foundation/cace](https://github.com/fossi-foundation/cace) | Repository sorgente |
| [OTA-5T reference project (Leo Moser)](https://github.com/mole99/sky130_leo_ip__ota5t) ⭐ | Progetto di esempio completo con YAML, template testbench e CI |
| [CACE talk Latch-Up 2024 (Tim Edwards)](https://archive.org/details/latch_2024-CACE_Study_Open_source_analog_and_mixedsignal_design_flow) | Presentazione introduttiva al framework |

### Magic VLSI — Editor di layout

| Risorsa | Descrizione |
|---------|-------------|
| [opencircuitdesign.com/magic](http://opencircuitdesign.com/magic/) | Sito ufficiale |
| [Magic VLSI Tutorial](http://opencircuitdesign.com/magic/tutorials/) | Tutorial ufficiali — DRC, estrazione, layout |

### Netgen — LVS

| Risorsa | Descrizione |
|---------|-------------|
| [opencircuitdesign.com/netgen](http://opencircuitdesign.com/netgen/) | Sito ufficiale |

### KLayout — Visualizzatore e editor GDS

| Risorsa | Descrizione |
|---------|-------------|
| [klayout.de](https://www.klayout.de) | Sito ufficiale |
| [KLayout scripting — Python e Ruby](https://www.klayout.de/doc-qt5/programming/python.html) | Documentazione ufficiale per lo scripting Python (e note di mappatura da Ruby) |
| [KLayout API Reference](https://www.klayout.de/doc-qt5/code/index.html) | Indice completo delle classi API |

### LibreLane — Flusso RTL→GDS

| Risorsa | Descrizione |
|---------|-------------|
| [librelane.readthedocs.io](https://librelane.readthedocs.io/en/latest/) | Documentazione ufficiale |

---

## 📐 Metodologia gm/Id e design analogico

| Risorsa | Descrizione |
|---------|-------------|
| [Harald Pretl — Analog Circuit Design (JKU)](https://iic-jku.github.io/analog-circuit-design/) ⭐ | Corso JKU completo: gm/Id, caratterizzazione SKY130A/IHP, laboratori pratici con xschem |
| [github.com/iic-jku/analog-circuit-design](https://github.com/iic-jku/analog-circuit-design) | Repository sorgente del corso con schematici xschem e notebook Python |
| [Boris Murmann — Stanford (gm/Id)](https://web.stanford.edu/~murmann) | Pagina del prof. Murmann a Stanford — link al gm/Id Starter Kit MATLAB originale |
| [pygmid — Python port del gm/Id Starter Kit](https://github.com/dreoilin/pygmid) ⭐ | Implementazione Python moderna del kit di Murmann, con supporto ngspice |
| [pygmid su PyPI](https://pypi.org/project/pygmid/) | Installazione via `pip install pygmid` |

**Libri di riferimento sulla metodologia gm/Id** (testi a pagamento, citati per completezza):
- W. Sansen, *Analog Design Essentials*, Springer, 2006
- D. Binkley, *Tradeoffs and Optimization in Analog CMOS Design*, Wiley, 2008

---

## ⚡ Comparatori e latch analogici

| Risorsa | Descrizione |
|---------|-------------|
| [B. Razavi, "The StrongARM Latch" (PDF)](https://www.seas.ucla.edu/brweb/papers/Journals/BR_Magzine4.pdf) ⭐ | *IEEE SSC Magazine*, Spring 2015 — articolo introduttivo, accesso libero |
| [B. Razavi, "The Design of a Comparator" (PDF)](https://www.seas.ucla.edu/brweb/papers/Journals/BR_SSCM_4_2020.pdf) | *IEEE SSC Magazine*, Fall 2020 — progetto completo di un comparatore StrongARM, accesso libero |
| [T. Kobayashi et al., VLSI Circuits 1992 (IEEE Xplore)](https://ieeexplore.ieee.org/document/229252/) | Paper originale del latch StrongARM — Symposium on VLSI Circuits 1992 |
| [T. Kobayashi et al., IEEE JSSC 1993 (IEEE Xplore)](https://ieeexplore.ieee.org/document/210039/) | Versione estesa pubblicata su JSSC — DOI: 10.1109/JSSC.1993.210039 |

**Libro di riferimento** (a pagamento):
- B. Razavi, *Design of Analog CMOS Integrated Circuits*, 2a ed., McGraw-Hill, 2017 — Cap. 13 sui comparatori

---

## 📊 Mismatch e legge di Pelgrom

| Risorsa | Descrizione |
|---------|-------------|
| [M. J. M. Pelgrom et al., IEEE JSSC 1989 (DOI)](https://ieeexplore.ieee.org/document/572629/) ⭐ | Articolo originale — DOI: 10.1109/JSSC.1989.572629 |
| [Pelgrom 1989 — PDF (Università di Pisa)](https://docenti.ing.unipi.it/~a008309/mat_stud/PSM/2023/Optional_Material/Articles/Pelgrom_JSSC_1989_Original_paper_on_Matching.pdf) | PDF dell'articolo originale, accesso libero |
| [Pelgrom 1989 — PDF (Denver IEEE section)](https://ewh.ieee.org/r5/denver/sscs/References/1989_10_Pelgrom.pdf) | Copia alternativa accesso libero |
| [P. Kinget, "Device Mismatch and Tradeoffs" (DOI)](https://ieeexplore.ieee.org/abstract/document/1435599/) | *IEEE JSSC*, 2005 — impatto del mismatch su circuiti analogici |
| [Semantic Scholar — Kobayashi 1993](https://www.semanticscholar.org/paper/A-current-controlled-latch-sense-amplifier-and-a-Kobayashi-Nogami/02fe34b4cd051d69be2ba1868dd89b846a01fc40) | Scheda bibliografica con abstract e citazioni incrociate |

**Nota sul coefficiente AVT per SKY130A:** il valore AVT ≈ 3.5 mV·µm è ricavato dalla caratterizzazione sperimentale dei dispositivi SKY130A e contenuto nei parametri statistici del PDK (file `.model.spice` in `libs.tech/ngspice`).

---

## 🎲 Simulazione Monte Carlo e statistica

| Risorsa | Descrizione |
|---------|-------------|
| [Wikipedia: Q-function](https://en.wikipedia.org/wiki/Q-function) | Definizione e proprietà della funzione Q usata nel binary error counting |
| [GaussianWaves: Q function demystified](https://www.gaussianwaves.com/2012/07/q-function-and-error-functions/) | Guida pratica con tabelle numeriche e codice Python |
| [ngspice manual (HTML)](https://ngspice.sourceforge.io/docs/ngspice-html-manual/manual.xhtml) | Cercare "Monte Carlo" — sezione sulle variazioni statistiche dei parametri |

---

## 🧮 Modelli SPICE e fisica dei MOSFET

| Risorsa | Descrizione |
|---------|-------------|
| [BSIM4 Model Documentation (Berkeley)](http://bsim.berkeley.edu/models/bsim4/) | Documentazione del modello BSIM4 usato da SKY130A — parametri, equazioni |
| [SKY130A librerie dispositivi primitivi](https://skywater-pdk.readthedocs.io/en/main/contents/libraries/foundry-provided.html) | Documentazione ufficiale delle librerie sky130_fd_pr nel PDK |
| [MIT OpenCourseWare — Microelectronic Devices and Circuits (6.012)](https://ocw.mit.edu/courses/6-012-microelectronic-devices-and-circuits-fall-2005/) | Corso MIT open access sulla fisica dei MOSFET — velocity saturation, mobilità, effetti di canale corto |

---

## 🎓 Corsi e materiale didattico open-source

| Risorsa | Descrizione |
|---------|-------------|
| [IIC@JKU — Analog Circuit Design](https://iic-jku.github.io/analog-circuit-design/) ⭐ | Corso completo di Harald Pretl: gm/Id, caratterizzazione, layout, tapeout |
| [IHP Open-Source PDK (SG13G2)](https://github.com/IHP-GmbH/IHP-Open-PDK) | PDK open-source IHP 130nm BiCMOS — usato nel corso JKU come alternativa a SKY130A |
| [Matt Venn — Zero to ASIC Course](https://zerotoasiccourse.com/) | Corso digitale completo: RTL → GDS → tapeout con SKY130A |
| [TinyTapeout](https://tinytapeout.com/) ⭐ | Piattaforma per il tapeout a basso costo — usata nel Modulo 6 del corso PSEI |
| [FOSSi Foundation](https://www.fossi-foundation.org/) | Organizzazione che mantiene CACE, PDK open-source e tool dopo la chiusura di Efabless |

---

## 📡 ADC e convertitori dati

Il corso usa il SAR ADC come filo conduttore del Modulo 1. I seguenti testi approfondiscono l'architettura e il design dei convertitori:

| Testo | Note |
|-------|------|
| B. Razavi, *Analysis and Design of Data Converters*, Cambridge University Press, 2025 ⭐ | Il testo più recente di Razavi, pubblicato nel luglio 2025 — copre in dettaglio comparatori (Cap. 5–7), SAR ADC (Cap. 14–16), pipeline ADC e oversampling. Approccio transistor-level con esempi e simulazioni |
| B. Razavi, *Principles of Data Conversion System Design*, IEEE Press, 1995 | Predecessore del libro sopra — più datato ma con ottima trattazione teorica delle architetture ADC/DAC |
| M. Pelgrom, *Analog-to-Digital Conversion*, 3a ed., Springer, 2017 | Trattazione completa con forte attenzione a rumore, mismatch e limitazioni fisiche |
| R. Schreier, G. Temes, *Understanding Delta-Sigma Data Converters*, 2a ed., Wiley-IEEE Press, 2017 | Riferimento per i convertitori oversampling — sigma-delta e noise shaping |

---



Risorse a pagamento, citate per completezza bibliografica:

| Testo | Note |
|-------|------|
| B. Razavi, *Design of Analog CMOS Integrated Circuits*, 2a ed., McGraw-Hill, 2017 | Testo standard — copre amplificatori, op amp, circuiti di feedback e noise; i comparatori non hanno un capitolo dedicato ma vengono trattati in sezioni sparse |
| P. Gray, P. Hurst, S. Lewis, R. Meyer, *Analysis and Design of Analog Integrated Circuits*, 5a ed., Wiley, 2009 | Alternativa classica — più analitica, ottima per feedback e amplificatori |
| T. Carusone, D. Johns, K. Martin, *Analog Integrated Circuit Design*, 2a ed., Wiley, 2011 | Forte su ADC e circuiti a tempo discreto |
| W. Sansen, *Analog Design Essentials*, Springer, 2006 | Orientato alla metodologia gm/Id e al design sistematico |
| D. Binkley, *Tradeoffs and Optimization in Analog CMOS Design*, Wiley, 2008 | Trattazione completa della metodologia gm/Id in tutti i regimi |

---

## 🔗 Community e forum

| Risorsa | Descrizione |
|---------|-------------|
| [FOSSi Foundation — Slack (invite)](https://slack.fossi-foundation.org/) | Workspace Slack della community FOSSi — canali dedicati a xschem, ngspice, PDK |
| [ngspice — SourceForge mailing list](https://sourceforge.net/p/ngspice/mailman/) | Archivio della mailing list ufficiale di ngspice |
| [xschem — Issue tracker (Codeberg)](https://codeberg.org/stef_xschem/xschem/issues) | Bug report e richieste di funzionalità per xschem |
| [xschem — Discussion (GitHub)](https://github.com/StefanSchippers/xschem/discussions) | Forum di discussione su GitHub (ancora attivo nel periodo di transizione) |
| [r/chipdesign (Reddit)](https://www.reddit.com/r/chipdesign/) | Forum generale di chip design |

---

*Documento generato per il corso PSEI — Università degli Studi dell'Aquila, a.a. 2025/2026.*  
*Per segnalare link non funzionanti o suggerire aggiunte: aprire una issue su [github.com/Elettronica-UnivAQ/PSEI-ASIC-Lab](https://github.com/Elettronica-UnivAQ/PSEI-ASIC-Lab).*
