#!/usr/bin/env python3
"""
summaryVHDL.py — Variante di summary.py per il flow LibreLane VHDLClassic

Differenze rispetto all'originale di Matt Venn (github.com/mattvenn/librelane_summary):
  - Supporta run con --run-tag personalizzato (cartella run = cartella tag, senza timestamp)
  - Path corretti per VHDLClassic: yosys-vhdlsynthesis invece di yosys-synthesis
  - Opzione --metrics per estrarre le metriche chiave da metrics.csv in formato leggibile
  - Opzione --compare per confrontare due run fianco a fianco

Installazione: copia questo file nella cartella librelane_summary clonata da
    https://github.com/mattvenn/librelane_summary
e aggiungila al PATH (vedi README.md della repo).

Uso base:
    cd /foss/designs/modulo4/lab02
    summaryVHDL.py --summary
    summaryVHDL.py --metrics
    summaryVHDL.py --timing
    summaryVHDL.py --runs runs/util_30 --metrics
    summaryVHDL.py --compare runs/util_30 runs/util_55

Corso PSEI — Università degli Studi dell'Aquila
"""

import argparse
import json
import os
import glob
import csv
import sys
import re
import datetime
from shutil import which

# ---------------------------------------------------------------------------
# Metriche chiave estratte da metrics.csv per --metrics
# ---------------------------------------------------------------------------
METRICS_OF_INTEREST = [
    # Area
    ("design__die__bbox",                               "Die (µm)"),
    ("design__die__area",                               "Area die (µm²)"),
    ("design__core__area",                              "Area core (µm²)"),
    ("design__instance__count",                         "N. istanze (con filler)"),
    ("design__instance__utilization",                   "Utilizzo effettivo"),
    # Timing — setup corner nominale
    ("timing__setup__ws__corner:nom_tt_025C_1v80",      "Setup WS nom_tt (ns)"),
    ("timing__setup__tns__corner:nom_tt_025C_1v80",     "Setup TNS nom_tt (ns)"),
    # Timing — setup corner peggiore
    ("timing__setup__ws__corner:nom_ss_100C_1v60",      "Setup WS ss_100C (ns)"),
    # Timing — hold corner nominale
    ("timing__hold__ws__corner:nom_tt_025C_1v80",       "Hold WS nom_tt (ns)"),
    ("timing__hold__tns__corner:nom_tt_025C_1v80",      "Hold TNS nom_tt (ns)"),
    # Violazioni
    ("design__max_slew_violation__count",               "Slew violations"),
    ("design__max_cap_violation__count",                "Cap violations"),
    ("route__drc_errors",                               "DRC errors"),
    ("design__lvs_error__count",                        "LVS errors"),
    ("route__antenna_violation__count",                 "Antenna violations"),
    # Power (corner nominale)
    ("power__internal__total",                          "Power internal (W)"),
    ("power__switching__total",                         "Power switching (W)"),
    ("power__leakage__total",                           "Power leakage (W)"),
    ("power__total",                                    "Power totale (W)"),
]

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

def is_tool(name):
    return which(name) is not None


def check_path(pattern):
    paths = glob.glob(pattern)
    if len(paths) == 0:
        print(f"WARN: nessun file trovato per: {pattern}")
        return None
    if len(paths) > 1:
        print(f"WARN: pattern ambiguo, uso il primo: {paths[0]}")
    return paths[0]


def is_run_dir(path):
    """Restituisce True se path è direttamente una cartella di run
    (contiene final/metrics.csv), False se è una cartella che contiene run."""
    return os.path.exists(os.path.join(path, "final", "metrics.csv"))


def find_run_path(runs_arg):
    """Individua la cartella del run da usare.

    Casi gestiti:
    1. runs_arg punta direttamente a una cartella di run (tagged run)
    2. runs_arg punta a una cartella che contiene run con timestamp
    3. Nessun argomento: cerca 'runs/' nella CWD
    """
    # Caso 1: path esplicito che è già un run (tagged)
    if runs_arg and is_run_dir(runs_arg):
        print(f"using tagged run: {runs_arg}")
        return runs_arg

    # Caso 2 e 3: runs_dir contiene sottorun
    if runs_arg and os.path.isdir(runs_arg):
        runs_dir = runs_arg
    elif os.path.exists("runs"):
        runs_dir = "runs"
    else:
        sys.exit("Impossibile trovare la cartella runs. Usa --runs o spostati nella cartella del progetto.")

    candidates = [d for d in glob.glob(os.path.join(runs_dir, "*"))
                  if os.path.isdir(d) and is_run_dir(d)]

    if not candidates:
        sys.exit(f"Nessun run completato trovato in {runs_dir}")

    # Usa il più recente per data di modifica
    run_path = max(candidates, key=os.path.getmtime)
    print(f"using latest run: {run_path}")
    return run_path


def load_metrics(run_path):
    """Carica metrics.csv e restituisce un dizionario {metrica: valore}."""
    metrics_file = os.path.join(run_path, "final", "metrics.csv")
    if not os.path.exists(metrics_file):
        sys.exit(f"metrics.csv non trovato in {run_path}/final/")
    data = {}
    with open(metrics_file) as f:
        for row in csv.reader(f):
            if len(row) == 2:
                data[row[0].strip()] = row[1].strip()
    return data


def fmt_value(key, val):
    """Formatta il valore in modo leggibile."""
    try:
        f = float(val)
        # Power: converti in µW
        if "power" in key and "violation" not in key:
            return f"{f * 1e6:.3f} µW"
        # Utilizzo: percentuale
        if "utilization" in key:
            return f"{f * 100:.1f}%"
        # Valori interi
        if f == int(f):
            return str(int(f))
        # Valori float generici (ns, µm²)
        return f"{f:.4f}"
    except (ValueError, TypeError):
        return val


# ---------------------------------------------------------------------------
# Report functions
# ---------------------------------------------------------------------------

def print_metrics(run_path):
    """Stampa le metriche chiave in formato leggibile."""
    data = load_metrics(run_path)
    print(f"\n{'Metrica':<45} {'Valore':>20}")
    print("─" * 67)
    for key, label in METRICS_OF_INTEREST:
        val = data.get(key, "—")
        if val != "—":
            val = fmt_value(key, val)
        print(f"  {label:<43} {val:>20}")
    print()


def print_summary(run_path):
    """Stampa solo errori e violazioni (equivalente a summary.py --summary)."""
    data = load_metrics(run_path)
    print(f"\n{'Metrica':<70} {'Valore':>10}")
    print("─" * 82)
    for key, val in data.items():
        if "violation" in key or "error" in key:
            print(f"  {key:<68} {val:>10}")
    print()


def print_timing(run_path):
    """Stampa il report di timing post-PNR (cerca summary.rpt)."""
    pattern = os.path.join(run_path, "*-openroad-stapostpnr", "summary.rpt")
    path = check_path(pattern)
    if path:
        with open(path) as f:
            print(f.read())
    else:
        print("Report di timing non trovato. Il run è completo?")


def print_yosys_report(run_path):
    """Stampa le statistiche di sintesi (VHDLClassic: yosys-vhdlsynthesis)."""
    # Prova prima VHDLClassic, poi Classic come fallback
    pattern_vhdl = os.path.join(run_path, "*-yosys-vhdlsynthesis", "reports", "stat.rpt")
    pattern_classic = os.path.join(run_path, "*-yosys-synthesis", "reports", "stat.json")

    path = check_path(pattern_vhdl)
    if path:
        with open(path) as f:
            print(f.read())
        return

    path = check_path(pattern_classic)
    if path:
        with open(path) as f:
            data = json.load(f)
            import pprint
            pprint.pprint(data.get("design", data), compact=True)
        return

    print("Report Yosys non trovato.")


def compare_runs(run_a, run_b):
    """Confronta le metriche chiave di due run fianco a fianco."""
    if not is_run_dir(run_a):
        sys.exit(f"'{run_a}' non è una cartella di run valida (manca final/metrics.csv)")
    if not is_run_dir(run_b):
        sys.exit(f"'{run_b}' non è una cartella di run valida (manca final/metrics.csv)")

    data_a = load_metrics(run_a)
    data_b = load_metrics(run_b)

    name_a = os.path.basename(run_a.rstrip("/"))
    name_b = os.path.basename(run_b.rstrip("/"))

    print(f"\n{'Metrica':<45} {name_a:>18} {name_b:>18}")
    print("─" * 83)
    for key, label in METRICS_OF_INTEREST:
        val_a = fmt_value(key, data_a.get(key, "—")) if key in data_a else "—"
        val_b = fmt_value(key, data_b.get(key, "—")) if key in data_b else "—"
        print(f"  {label:<43} {val_a:>18} {val_b:>18}")
    print()


def open_gds(run_path):
    """Apre il GDS finale in KLayout."""
    klayout_gds = os.path.join(os.path.dirname(sys.argv[0]), "klayout_gds.xml")
    pattern = os.path.join(run_path, "final", "gds", "*.gds")
    path = check_path(pattern)
    if path:
        os.system(f"klayout -l {klayout_gds} {path}")


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(
        description="summaryVHDL.py — summary per LibreLane VHDLClassic (PSEI UniAQ)",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Esempi:
  summaryVHDL.py --summary                        # errori e violazioni ultimo run
  summaryVHDL.py --metrics                         # metriche chiave ultimo run
  summaryVHDL.py --timing                          # timing post-PNR ultimo run
  summaryVHDL.py --yosys-report                    # statistiche sintesi
  summaryVHDL.py --runs runs/util_30 --metrics     # metriche di un run con tag
  summaryVHDL.py --compare runs/util_30 runs/util_55   # confronto due run
  summaryVHDL.py --gds                             # apre GDS in KLayout
""")

    parser.add_argument("--runs",    help="cartella del run (con tag) o cartella che contiene i run")
    parser.add_argument("--compare", help="confronta due run", nargs=2, metavar=("RUN_A", "RUN_B"))

    parser.add_argument("--summary",      help="mostra errori e violazioni",           action="store_true")
    parser.add_argument("--metrics",      help="mostra metriche chiave (area, timing, power)", action="store_true")
    parser.add_argument("--full-summary", help="mostra tutto il metrics.csv",          action="store_true")
    parser.add_argument("--timing",       help="timing summary post-PNR",              action="store_true")
    parser.add_argument("--yosys-report", help="statistiche sintesi Yosys (VHDLClassic-aware)", action="store_true")
    parser.add_argument("--gds",          help="apre il GDS finale in KLayout",        action="store_true")

    args = parser.parse_args()

    if not any(vars(args).values()):
        parser.print_help()
        sys.exit(0)

    # --compare non ha bisogno di run_path
    if args.compare:
        compare_runs(args.compare[0], args.compare[1])
        return

    run_path = find_run_path(args.runs)

    if args.summary:
        print_summary(run_path)

    if args.metrics:
        print_metrics(run_path)

    if args.full_summary:
        data = load_metrics(run_path)
        print(f"\n{'Metrica':<70} {'Valore':>20}")
        print("─" * 92)
        for k, v in data.items():
            print(f"  {k:<68} {v:>20}")
        print()

    if args.timing:
        print_timing(run_path)

    if args.yosys_report:
        print_yosys_report(run_path)

    if args.gds:
        open_gds(run_path)


if __name__ == "__main__":
    main()
