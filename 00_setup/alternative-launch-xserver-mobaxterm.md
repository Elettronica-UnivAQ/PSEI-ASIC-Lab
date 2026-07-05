# Modalità di avvio alternativa — X-server nativo via MobaXterm (`x_server`)

> Questa è una modalità di avvio **alternativa** a quella standard (WSLg) descritta in
> [windows.md](./windows.md). Usala se hai problemi grafici con la modalità standard — in
> particolare **lag dei menu/finestre** con GPU **AMD**. Vedi la tabella comparativa in
> [windows.md → "Modalità di avvio alternative"](./windows.md#modalità-di-avvio-alternative-in-caso-di-problemi-grafici)
> per capire quando conviene questa modalità rispetto alla [modalità VNC](./alternative-launch-vnc.md).

Questa modalità reindirizza le finestre X del container a un **X-server nativo su Windows**.
**MobaXterm** ha l'X-server integrato (alternative: **VcXsrv**, gratuito; **GWSL**, ~5€ sullo Store
o gratis da GitHub). Il compositing avviene **lato Windows** → **il lag dei menu di WSLg sparisce**
e la nitidezza è nativa. È l'ambiente migliore per xschem + KLayout di tutti i giorni.

> Perché funziona: bypassando WSLg, la composizione delle finestre la fa l'X-server usando la GPU
> del desktop Windows (iGPU AMD **inclusa**, lì disponibile). Si ricrea la fluidità che si ha su
> macchine con iGPU Intel esposta a WSL.

---

## 1 — Configurazione dell'X-server MobaXterm

MobaXterm → *Settings → Configuration → X11*:

- **X11 remote access: `full`** ← **critico**. Il container è su rete Docker separata; con
  `on-demand` l'X-server rifiuta la connessione. (Equivale a "disable access control" di VcXsrv.)
- **X11 server display mode: `Multiwindow`** (finestre native integrate nel desktop Windows).
- **OpenGL acceleration: `Software`** (stabile; `Hardware`/WGL è instabile con alcune app — solo
  come test, vedi punto 5).
- **DPI:** `stretched` o `native` a seconda del compromesso nitidezza/dimensioni (vedi punto 4).

Assicurati che l'**icona X** in alto a destra sia **attiva** (server avviato). Al primo avvio,
**autorizza MobaXterm nel Windows Firewall** (reti private **e** pubbliche), altrimenti il
container non lo raggiunge.

## 2 — Trovare l'IP dell'host visto dal container

Il container Docker Desktop raggiunge Windows via `host.docker.internal`. Da un terminale del
container:

```bash
getent hosts host.docker.internal
# tipicamente: 192.168.65.254  host.docker.internal
```

## 3 — Avvio del container puntando all'X-server

Da **PowerShell** (l'X-server di MobaXterm sta sul display `:0`):

```powershell
cd "C:\percorso\IIC-OSIC-TOOLS-2026.06"
$env:CONTAINER_NAME = "iic-osic-tools_moba"
$env:DOCKER_TAG     = "2026.06"
$env:DESIGNS        = "C:\percorso\ai_tuoi_designs"
$env:DISP           = "192.168.65.254:0.0"   # IP host + display :0 di MobaXterm
.\start_x.bat
```

**Concetto chiave:** `start_x.bat` passa il valore al container con `-e DISPLAY=%DISP%`. Impostando
`DISP` all'IP+display dell'X-server nativo invece che al socket WSLg, si cambia **solo l'indirizzo
di consegna delle finestre**, da WSLg a MobaXterm. Nessuna modifica allo script, tutto reversibile,
e coesiste con le altre modalità (basta un `CONTAINER_NAME` diverso).

**Test del canale** (dal terminale del container appena lanciato):
```bash
xclock    # deve aprire un orologio come finestra nativa su Windows
```
Se dà `cannot open display` o resta appeso → firewall o `remote access` ancora su `on-demand`.

## 4 — Cursore e HiDPI con X-server nativo (xschem vs KLayout)

Su 4K, i toolkit reagiscono all'HiDPI in modo **opposto**, quindi si tarano **per-app**:

- **xschem** usa **Tk**, che **non** si auto-scala: prende la risoluzione dell'X-server. In
  `stretched` risulta leggibile.
- **KLayout** usa **Qt**, che rileva la densità e renderizza "nativo": nitidissimo ma **minuscolo**,
  ignorando lo stretch.

Il cursore, senza tema, diventa quello **core dell'X-server** (grande e nero) dove l'app non ne
impone uno. Soluzione: impostare `XCURSOR_*` **per-applicazione** con valori diversi (un valore
globale non può accontentare Tk e Qt insieme).

**Wrapper per-app** (valori indicativi da ritarare sulla propria macchina):

```bash
mkdir -p ~/bin

# xschem (Tk): cursore più grande. 40 = buon compromesso (48 taglia l'icona)
cat > ~/bin/xschem << 'EOF'
#!/bin/bash
REAL=$(PATH=$(echo "$PATH" | tr ':' '\n' | grep -v "$HOME/bin" | paste -sd:) command -v xschem)
XCURSOR_THEME=Adwaita XCURSOR_SIZE=40 exec "$REAL" "$@"
EOF

# KLayout (Qt): cursore piccolo. 12 = giusto su 4K
cat > ~/bin/klayout << 'EOF'
#!/bin/bash
REAL=$(PATH=$(echo "$PATH" | tr ':' '\n' | grep -v "$HOME/bin" | paste -sd:) command -v klayout)
XCURSOR_THEME=Adwaita XCURSOR_SIZE=12 exec "$REAL" "$@"
EOF

chmod +x ~/bin/xschem ~/bin/klayout
export PATH="$HOME/bin:$PATH"
```

> **Perché i wrapper "auto-risolventi":** in IIC-OSIC-TOOLS i binari non sono in `/usr/bin`
> (es. `xschem` → `/foss/tools/bin/xschem`, `klayout` → `/foss/tools/klayout/klayout`). Lo script
> ricalcola il PATH escludendo `~/bin` e usa `command -v` per trovare il binario reale → immune ai
> percorsi. Verifica con `which xschem` → deve puntare a `~/bin/xschem`.

Note:
- Se KLayout resta enorme, **non** usare `QT_SCALE_FACTOR` alto: basta `XCURSOR_SIZE=12`.
- La freccia dei **menu** di xschem resta piccola (cursore di default X): fastidio estetico minore,
  accettabile.

## 5 — OpenGL "Hardware" in MobaXterm — cautela

*OpenGL acceleration → Hardware* usa l'OpenGL di Windows (WGL). È **nota per essere instabile** con
app complesse (artefatti, finestre nere, crash). Provala solo come test; se xschem/KLayout
peggiorano, torna a **Software**. **Non** risolve `magic -d XR` (vedi troubleshooting sotto).

## 6 — Limiti noti di MobaXterm

- **X-server software**: niente GPU reale come in WSLg.
- **`magic -d XR` fallisce** con `BadAlloc / X_CreatePixmap` (vedi troubleshooting sotto).
- **Decorazioni finestra** del window manager di MobaXterm, diverse dalle native Windows (estetico).

---

## Troubleshooting comune: `magic -d XR` crasha con `BadAlloc`

> Vale sia per questa modalità (MobaXterm) sia per la [modalità VNC](./alternative-launch-vnc.md).

**Sintomo.** All'avvio di magic con rendering XRender:
```
magic -d XR
X Error of failed request:  BadAlloc (insufficient resources for operation)
  Major opcode of failed request:  53 (X_CreatePixmap)
```

**Causa.** Il backend `-d XR` (Cairo/XRender) chiede al server X l'allocazione di **pixmap grandi**.
Gli X-server "leggeri" — **MobaXterm (software)** e **Xvnc (VNC)** — non hanno risorse pixmap
adeguate → `BadAlloc`. Non è un problema dell'app né della macchina: lo stesso errore compare su
**entrambi** quegli X-server. L'OpenGL Hardware di MobaXterm **non** aiuta (il collo è
l'allocazione di pixmap X, non l'OpenGL).

**Soluzione (rapida).** Avvia magic **senza** `-d XR`:
```bash
magic          # backend predefinito, parte ovunque
# oppure:
magic -d X11   # backend X11 classico, leggero
```
La differenza visiva rispetto a `-d XR` è trascurabile per il lavoro normale; non perdi
funzionalità di magic, solo un backend di disegno più "levigato".

**Se ti serve `-d XR` (o `-d OGL`).** Usali dalla modalità **WSLg standard** ([windows.md](./windows.md)),
dove l'X-server ha risorse pixmap vere e la GPU accelerata: lì `magic -d XR` (e spesso `-d OGL`)
**parte**. In sintesi: MobaXterm/VNC per il lavoro quotidiano con `magic` liscio; WSLg quando serve
il rendering XR/OGL.

---

## Prossimo passo

Vedi anche la sezione ["Configurazione avanzata"](./windows.md#configurazione-avanzata-far-convivere-più-modalità)
in windows.md per un `.designinit` condiviso fra tutte le modalità e dei launcher `.bat` dedicati.
