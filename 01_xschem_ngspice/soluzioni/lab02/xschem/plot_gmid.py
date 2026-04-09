"""
plot_gmid.py — Visualizzazione curve gm/Id per NMOS/PMOS SKY130A
Uso:
    python3 plot_gmid.py          # NMOS (default)
    python3 plot_gmid.py pmos     # PMOS
    python3 plot_gmid.py all      # NMOS + PMOS in griglia 2 righe

Pulsanti:
  [Vista 1] : gm/Id, gds/Id, fT  vs  Id/W   (caratterizzazione, 1x3)
  [Vista 2] : fT, gm/gds, Id/W, Vdsat  vs  gm/Id  (trade-off, 2x2)
  [Zone]    : separatori WI/MI/SI (solo Vista 1)
  [fT logY] : scala log asse Y su fT (solo Vista 1)
  Click sx  : cursore verticale
  Click dx  : rimuovi cursore
"""

import sys
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
from matplotlib.widgets import Button
import os

# ── Configurazione ─────────────────────────────────────────────────────────
mode     = sys.argv[1].lower() if len(sys.argv) > 1 else "nmos"
L_VALUES = [0.15, 0.18, 0.25, 0.5, 1.0]
SIM_DIR  = "simulation"
IDW_MIN  = 1e-4
L_REF    = 0.25

# ── Lettura file ───────────────────────────────────────────────────────────
def load_device(device):
    data_out = {}
    for L in L_VALUES:
        L_nm  = int(round(L * 1000))
        fname = os.path.join(SIM_DIR, f"{device}_gmid_l{L_nm}nm.txt")
        if not os.path.exists(fname):
            print(f"File non trovato: {fname}")
            continue
        d        = np.loadtxt(fname)
        IdW      = np.abs(d[:, 1])
        gmid     = np.abs(d[:, 3])
        gds_norm = np.abs(d[:, 5])
        fT_GHz   = np.abs(d[:, 7])
        # Vdsat in colonna 9 se presente (wrdata scrive coppie VGS,valore)
        Vdsat     = np.abs(d[:, 9]) if d.shape[1] > 9 else np.zeros_like(IdW)
        gm_gds   = np.where(gds_norm > 1e-6, gmid / gds_norm, np.nan)
        mask     = IdW > IDW_MIN
        data_out[L] = {
            "IdW":      IdW[mask],
            "gmid":     gmid[mask],
            "gds_norm": gds_norm[mask],
            "fT_GHz":   fT_GHz[mask],
            "gm_gds":   gm_gds[mask],
            "Vdsat":     Vdsat[mask],
        }
    return data_out

devices      = ["nmos", "pmos"] if mode == "all" else [mode]
all_datasets = {dev: load_device(dev) for dev in devices}
for dev, data in all_datasets.items():
    if not data:
        print(f"Nessun dato per {dev.upper()}."); exit(1)

# ── Zone di inversione ─────────────────────────────────────────────────────
def compute_zones(datasets):
    for dev, data in datasets.items():
        if L_REF in data:
            g = data[L_REF]["gmid"]
            x = data[L_REF]["IdW"]
            gmax = np.max(g)
            def fi(thr):
                idx = np.where(g < thr)[0]
                return x[idx[0]] if len(idx) > 0 else None
            wi, mi = fi(0.9*gmax), fi(0.3*gmax)
            print(f"Zone [{dev.upper()}] gm/Id_max={gmax:.1f} | WI/MI={wi:.3f} | MI/SI={mi:.3f} µA/µm")
            return wi, mi
    return 0.1, 10.0

ZONE_WI, ZONE_MI = compute_zones(all_datasets)
colors = plt.cm.viridis(np.linspace(0.1, 0.9, len(L_VALUES)))

# ── Vista 1: 1x3, asse x = Id/W ────────────────────────────────────────────
V1_SERIES = [
    {"key":"gmid",    "ylabel":"$g_m/I_D$ (V$^{-1}$)",  "title":"Efficienza di transconduttanza"},
    {"key":"gds_norm","ylabel":"$g_{ds}/I_D$ (V$^{-1}$)","title":"Conduttanza di uscita norm."},
    {"key":"fT_GHz",  "ylabel":"$f_T$ (GHz)",            "title":"Frequenza di transizione"},
]
V1_XLABEL = "$I_D/W$ (µA/µm)"

# ── Vista 2: 2x2, asse x = gm/Id ───────────────────────────────────────────
V2_SERIES = [
    {"key":"fT_GHz", "ylabel":"$f_T$ (GHz)",           "title":"Velocità vs efficienza"},
    {"key":"gm_gds", "ylabel":"$g_m/g_{ds}$ (V/V)",    "title":"Guadagno intrinseco"},
    {"key":"IdW",    "ylabel":"$I_D/W$ (µA/µm)",       "title":"Densità di corrente"},
    {"key":"Vdsat",   "ylabel":"$V_{DS,sat}$ (V)",       "title":"Tensione minima saturazione"},
]
V2_XLABEL = "$g_m/I_D$ (V$^{-1}$)"

# ── Stato corrente ─────────────────────────────────────────────────────────
current_view  = [1]   # 1=Vista1, 2=Vista2
zones_visible = [False]
ft_log_on     = [False]
lines_by_ax   = {}
zone_lines    = []
zone_labels   = []

# ── Costruzione figura ─────────────────────────────────────────────────────
n_rows = len(devices)

def make_figure():
    """Crea/ricrea la figura con il layout corretto per la vista corrente."""
    global fig, axes_grid, info_texts, ax_infos, cursors, annots
    global btn_v1, btn_v2, btn_zones, btn_ft

    plt.close("all")
    v = current_view[0]
    n_ax_per_row = 3 if v == 1 else 4

    fig_w = 20 if v == 1 else 22
    fig_h = 5 * n_rows + 1.5

    fig = plt.figure(figsize=(fig_w, fig_h))
    fig.suptitle(
        "Caratterizzazione SKY130A — NMOS e PMOS" if mode == "all"
        else f"Caratterizzazione {'NMOS' if mode=='nmos' else 'PMOS'} SKY130A",
        fontsize=13, y=0.98)

    axes_grid  = []
    info_texts = []
    ax_infos   = []

    if v == 1:
        # 1 riga × 3 grafici + pannello info
        gs = gridspec.GridSpec(n_rows, 4, figure=fig,
                               width_ratios=[4,4,4,2],
                               wspace=0.28, hspace=0.45,
                               top=0.91, bottom=0.18,
                               left=0.06, right=0.98)
        for row, dev in enumerate(devices):
            row_axes = [fig.add_subplot(gs[row, c]) for c in range(3)]
            axes_grid.append(row_axes)
            ax_info = fig.add_subplot(gs[row, 3])
            ax_info.axis("off")
            ax_infos.append(ax_info)
            info_texts.append(ax_info.text(
                0.05, 0.95,
                f"{dev.upper()}\n\n← Clicca su un grafico\n   per leggere i valori\n\nClick dx: rimuovi",
                transform=ax_info.transAxes, va="top", fontsize=8.5, family="monospace",
                bbox=dict(boxstyle="round", fc="lightyellow", ec="gray", alpha=0.9)))
    else:
        # 2 righe × 2 grafici + pannello info (per device)
        gs_outer = gridspec.GridSpec(n_rows, 3, figure=fig,
                                     width_ratios=[8,8,3],
                                     wspace=0.3, hspace=0.45,
                                     top=0.91, bottom=0.18,
                                     left=0.05, right=0.98)
        for row, dev in enumerate(devices):
            gs_inner = gridspec.GridSpecFromSubplotSpec(
                2, 2, subplot_spec=gs_outer[row, 0:2], wspace=0.35, hspace=0.45)
            row_axes = [fig.add_subplot(gs_inner[r, c])
                        for r in range(2) for c in range(2)]
            axes_grid.append(row_axes)
            ax_info = fig.add_subplot(gs_outer[row, 2])
            ax_info.axis("off")
            ax_infos.append(ax_info)
            info_texts.append(ax_info.text(
                0.05, 0.95,
                f"{dev.upper()}\n\n← Clicca su un grafico\n   per leggere i valori\n\nClick dx: rimuovi",
                transform=ax_info.transAxes, va="top", fontsize=8.5, family="monospace",
                bbox=dict(boxstyle="round", fc="lightyellow", ec="gray", alpha=0.9)))

    # cursori e annotazioni
    all_ax = [ax for row in axes_grid for ax in row]
    cursors = {ax: ax.axvline(color="gray", lw=0.8, ls="--", visible=False) for ax in all_ax}
    annots  = {ax: [] for ax in all_ax}
    for ax in all_ax:
        lines_by_ax[ax] = []

    # pulsanti
    ax_bv1    = fig.add_axes([0.13, 0.02, 0.09, 0.045])
    ax_bv2    = fig.add_axes([0.24, 0.02, 0.09, 0.045])
    ax_bzones = fig.add_axes([0.39, 0.02, 0.09, 0.045])
    ax_bft    = fig.add_axes([0.50, 0.02, 0.11, 0.045])
    btn_v1    = Button(ax_bv1,    "Vista 1", color="lightblue" if v==1 else "0.85")
    btn_v2    = Button(ax_bv2,    "Vista 2", color="lightblue" if v==2 else "0.85")
    btn_zones = Button(ax_bzones, "Zone OFF")
    btn_ft    = Button(ax_bft,    "fT log Y: OFF")
    btn_ft.ax.set_visible(v == 1)
    btn_v1.on_clicked(lambda e: switch_view(1))
    btn_v2.on_clicked(lambda e: switch_view(2))
    btn_zones.on_clicked(toggle_zones)
    btn_ft.on_clicked(toggle_ft_logy)

    fig.canvas.mpl_connect("button_press_event", on_click)
    draw_curves()
    plt.show()

def draw_curves():
    v      = current_view[0]
    series = V1_SERIES if v == 1 else V2_SERIES
    xlabel = V1_XLABEL if v == 1 else V2_XLABEL
    xkey   = "IdW"     if v == 1 else "gmid"
    xlog   = (v == 1)

    for row, dev in enumerate(devices):
        row_axes = axes_grid[row]
        for ax, serie in zip(row_axes, series):
            ax.cla()
            lines_by_ax[ax] = []
            for i, L in enumerate(all_datasets[dev]):
                d    = all_datasets[dev][L]
                L_nm = int(round(L * 1000))
                ln, = ax.plot(d[xkey], d[serie["key"]], color=colors[i],
                              label=f"L={L_nm}nm", linewidth=1.5)
                lines_by_ax[ax].append((ln, L, serie["key"]))
            ax.set_xscale("log" if xlog else "linear")
            ax.set_xlabel(xlabel)
            ax.set_ylabel(serie["ylabel"])
            ax.set_title(f"{dev.upper()} — {serie['title']}", fontsize=9)
            ax.grid(True, which="both", linestyle="--", alpha=0.4)
            ax.legend(fontsize=7)

    if zones_visible[0]:
        _place_zones()
    fig.canvas.draw_idle()

# ── Zone ───────────────────────────────────────────────────────────────────
def _place_zones():
    for l in zone_lines: l.remove()
    for lb in zone_labels: lb.remove()
    zone_lines.clear(); zone_labels.clear()
    if current_view[0] != 1: return
    for row_axes in axes_grid:
        for ax in row_axes:
            zone_lines.append(ax.axvline(ZONE_WI, color="steelblue", lw=1, ls=":", alpha=0.7))
            zone_lines.append(ax.axvline(ZONE_MI, color="darkorange", lw=1, ls=":", alpha=0.7))
        ax0 = row_axes[0]
        for x, lbl, col in [(ZONE_WI*0.15,"WI","steelblue"),
                             (np.sqrt(ZONE_WI*ZONE_MI),"MI","gray"),
                             (ZONE_MI*6,"SI","darkorange")]:
            zone_labels.append(ax0.text(x, 0.97, lbl,
                transform=ax0.get_xaxis_transform(),
                fontsize=7, color=col, ha="center", va="top"))

def toggle_zones(event):
    zones_visible[0] = not zones_visible[0]
    if zones_visible[0]: _place_zones()
    else:
        for l in zone_lines: l.remove()
        for lb in zone_labels: lb.remove()
        zone_lines.clear(); zone_labels.clear()
    btn_zones.label.set_text("Zone ON" if zones_visible[0] else "Zone OFF")
    fig.canvas.draw_idle()

def toggle_ft_logy(event):
    if current_view[0] != 1: return
    ft_log_on[0] = not ft_log_on[0]
    scale = "log" if ft_log_on[0] else "linear"
    for row_axes in axes_grid:
        row_axes[2].set_yscale(scale)
        row_axes[2].grid(True, which="both", linestyle="--", alpha=0.4)
    btn_ft.label.set_text("fT log Y: ON" if ft_log_on[0] else "fT log Y: OFF")
    fig.canvas.draw_idle()

def switch_view(v):
    current_view[0] = v
    zones_visible[0] = False
    ft_log_on[0]     = False
    zone_lines.clear(); zone_labels.clear()
    make_figure()

# ── Cursore ────────────────────────────────────────────────────────────────
def get_row(ax):
    for i, row in enumerate(axes_grid):
        if ax in row: return i, row
    return None, None

def clear_cursor():
    for ax in [a for row in axes_grid for a in row]:
        if ax in cursors: cursors[ax].set_visible(False)
        for a in annots.get(ax,[]): a.remove()
        if ax in annots: annots[ax].clear()
    for i, it in enumerate(info_texts):
        it.set_text(f"{devices[i].upper()}\n\n← Clicca su un grafico\n   per leggere i valori\n\nClick dx: rimuovi")
    fig.canvas.draw_idle()

def on_click(event):
    all_ax = [a for row in axes_grid for a in row]
    if event.inaxes not in all_ax: return
    if event.button == 3: clear_cursor(); return
    if event.xdata is None: return
    x = event.xdata
    row_idx, row_axes = get_row(event.inaxes)
    if row_axes is None: return

    series = V1_SERIES if current_view[0]==1 else V2_SERIES
    xlabel = V1_XLABEL if current_view[0]==1 else V2_XLABEL

    for ax in row_axes:
        if ax in cursors:
            cursors[ax].set_xdata([x, x])
            cursors[ax].set_visible(True)
        for a in annots.get(ax,[]): a.remove()
        if ax in annots: annots[ax].clear()

    xlab_clean = xlabel.replace("$","").replace("_D","").replace("{","").replace("}","")
    txt = [f"{devices[row_idx].upper()}  {xlab_clean} = {x:.3f}\n"]
    for ax, serie in zip(row_axes, series):
        txt.append(f"── {serie['title']} ──")
        for ln, L, k in lines_by_ax.get(ax,[]):
            xd, yd = ln.get_xdata(), ln.get_ydata()
            if x < xd[0] or x > xd[-1]: continue
            y    = np.interp(x, xd, yd)
            L_nm = int(round(L * 1000))
            txt.append(f"  {L_nm}nm: {y:.3f}")
            if ax in annots:
                ann = ax.annotate(f"{y:.2f}", xy=(x,y), xytext=(5,3),
                                  textcoords="offset points", fontsize=7,
                                  color=ln.get_color(),
                                  bbox=dict(boxstyle="round,pad=0.2", fc="white",
                                            ec=ln.get_color(), alpha=0.8))
                annots[ax].append(ann)
        txt.append("")
    info_texts[row_idx].set_text("\n".join(txt))
    fig.canvas.draw_idle()

# ── Avvio ──────────────────────────────────────────────────────────────────
make_figure()
