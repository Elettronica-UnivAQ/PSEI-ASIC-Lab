# Modalità di avvio alternativa — VNC (`vnc_server`)

> Questa è una modalità di avvio **alternativa** a quella standard (WSLg) descritta in
> [windows.md](./windows.md). Usala se hai problemi grafici con la modalità standard — tipicamente
> **cursore enorme su schermi 4K/HiDPI** o **lag dell'interfaccia su CPU/GPU AMD**. Vedi la tabella
> comparativa in [windows.md → "Modalità di avvio alternative"](./windows.md#modalità-di-avvio-alternative-in-caso-di-problemi-grafici)
> per capire quando conviene questa modalità rispetto a [X-server via MobaXterm](./alternative-launch-xserver-mobaxterm.md).

Questa modalità fa girare tutto **dentro** il container (server Xvnc software) e lo mostra nel
browser via noVNC: bypassa completamente WSLg → **niente lag di compositing, niente cursore
gigante, niente dipendenza dallo scaling di Windows**. Nitidezza inferiore (immagine compressa), ma
è il miglior compromesso "a prova di grane" su 4K/AMD.

---

## 1 — Avvio

Da **PowerShell**, nella cartella del repo IIC-OSIC-TOOLS (adatta i percorsi):

```powershell
cd "C:\percorso\IIC-OSIC-TOOLS-2026.06"
$env:CONTAINER_NAME = "iic-osic-tools_vnc"
$env:DOCKER_TAG     = "2026.06"
$env:DESIGNS        = "C:\percorso\ai_tuoi_designs"
# Opzionale: risoluzione del desktop virtuale (vedi punto 3)
$env:VNC_RESOLUTION = "2560x1440"
.\start_vnc.bat
```

Lo script stampa, **a ogni avvio**, l'URL completo con la password già inclusa
(tipo `http://localhost:80/vnc.html?password=...`). La **password è rigenerata a ogni avvio**: se
la perdi, rilancia `start_vnc.bat` e riappare nell'output. Non serve memorizzarla.

## 2 — Usare noVNC "completo", non "lite"

Il link può aprire la versione **lite** (`vnc_lite.html`): barra in alto con "Connected to…" ma
**nessun pannello laterale**. Per avere le impostazioni (resizing, qualità, clipboard, fullscreen),
usa la versione **completa** cambiando il finale dell'URL in `vnc.html`:

```
http://localhost/vnc.html?password=LA_TUA_PASSWORD
```

Nella versione completa appare una **linguetta a sinistra** (piccola freccia sul bordo): aprila.

## 3 — Eliminare le scrollbar / finestra tagliata

Il desktop virtuale ha risoluzione fissa più piccola dello schermo → noVNC aggiunge scrollbar.

- **Remote Resizing (consigliato):** pannello noVNC (linguetta a sinistra) → *Settings* → attiva
  **Remote Resizing** e imposta *Scaling Mode* su **None**. Il desktop si adatta alla finestra,
  scrollbar via.
- **Risoluzione fissa all'avvio:** `$env:VNC_RESOLUTION = "2560x1440"` (comodo) o `"3840x2400"`
  (nitido ma pesante) prima di `start_vnc.bat`. In alternativa a caldo: desktop XFCE →
  *Settings → Display*.

## 4 — Limiti noti

- **Nitidezza inferiore**: noVNC comprime l'immagine → testo e linee sottili degli schematici meno
  nitidi rispetto a un X-server nativo.
- **Nessuna GPU**: rendering software (`llvmpipe`). Ok per xschem/KLayout viewer; `magic -d XR`
  **non parte** — vedi il [troubleshooting comune](./alternative-launch-xserver-mobaxterm.md#troubleshooting-comune-magic--d-xr-crasha-con-badalloc)
  (lo stesso errore si presenta anche in modalità MobaXterm, per lo stesso motivo).

---

## Prossimo passo

Vedi anche la sezione ["Configurazione avanzata"](./windows.md#configurazione-avanzata-far-convivere-più-modalità)
in windows.md per un `.designinit` condiviso fra tutte le modalità e dei launcher `.bat` dedicati.
