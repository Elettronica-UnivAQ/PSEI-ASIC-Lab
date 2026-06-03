#!/usr/bin/env python3
"""
analyze_sine.py -- Analisi della risposta sinusoidale del SAR ADC
Legge l'output di wrdata da ngspice, estrae i codici dout a ogni EOC,
ricostruisce la sinusoide, calcola FFT e metriche di qualita' (SNDR, ENOB).

Note sul metodo:
  - wrdata di ngspice ripete il vettore tempo per ogni segnale: con 9 segnali
    (eoc + dout7..dout0) si ottengono 18 colonne. I valori utili sono nelle
    colonne dispari: col1=eoc, col3=dout7, col5=dout6, ..., col17=dout0.
  - Campionamento COERENTE (fin = 3/64 * fs): NON si usa la finestra di Hanning.
    La finestra disperderebbe la potenza del segnale su piu' bin, abbassando
    artificialmente lo SNDR. Con campionamento coerente tutta la potenza del
    segnale cade in un singolo bin FFT e la finestra non serve.
  - Rilevamento EOC per GRUPPI di punti alti: piu' robusto con il passo adattivo
    di ngspice che puo' non avere punti esattamente sul fronte di salita.
  - SNDR calcolato sommando la potenza sui 3 bin centrali del main lobe.

Uso:
    cd /foss/designs/modulo5/lab03
    python3 analyze_sine.py xschem/simulation/sar_sine.txt
"""

import sys
import numpy as np
import matplotlib.pyplot as plt

# =============================================================================
# 1. Lettura del file wrdata
# =============================================================================
fname = sys.argv[1] if len(sys.argv) > 1 else "xschem/simulation/sar_sine.txt"

rows = []
with open(fname, 'r') as f:
    for line in f:
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        try:
            vals = [float(x) for x in line.split()]
            if len(vals) == 18:   # wrdata: t,eoc, t,d7, t,d6, ..., t,d0
                rows.append(vals)
        except ValueError:
            continue

data = np.array(rows)
print(f"Righe lette dal file: {len(data)}")

# Formato wrdata: il tempo viene RIPETUTO per ogni segnale (18 colonne):
#   col 0: time   col 1: eoc
#   col 2: time   col 3: dout7
#   col 4: time   col 5: dout6
#   ...
#   col 16: time  col 17: dout0
# I segnali utili sono nelle colonne DISPARI.
time = data[:, 0]
eoc  = data[:, 1]
dout = data[:, [3, 5, 7, 9, 11, 13, 15, 17]]   # dout7..dout0

# =============================================================================
# 2. Estrazione dei codici tramite RAGGRUPPAMENTO dei punti con EOC alto
#
#    Il passo adattivo di ngspice puo' non avere punti esattamente sul fronte
#    di salita di EOC. Invece di cercare fronti, raggruppiamo i punti
#    consecutivi con eoc > soglia e campioniamo dout al centro di ogni gruppo.
# =============================================================================
THRESHOLD = 0.9
weights   = np.array([128, 64, 32, 16, 8, 4, 2, 1])

eoc_high    = (eoc > THRESHOLD).astype(int)
transitions = np.diff(np.concatenate([[0], eoc_high, [0]]))
starts      = np.where(transitions ==  1)[0]
ends        = np.where(transitions == -1)[0]
print(f"Periodi EOC alto rilevati: {len(starts)}")

codes = []
for s, e in zip(starts, ends):
    mid  = (s + e) // 2
    bits = (dout[mid] > THRESHOLD).astype(int)
    D    = int(np.dot(bits, weights))
    codes.append(D)

codes = np.array(codes, dtype=float)
N = len(codes)
print(f"Campioni estratti: {N}")
print(f"Codici hex: {[hex(int(c)) for c in codes[:8]]} ...")
print(f"Min={int(codes.min())}  Max={int(codes.max())}  Media={codes.mean():.1f}  (atteso ~127.5)")

# =============================================================================
# 3. Ricostruzione nel dominio del tempo
# =============================================================================
fs  = 2e6      # frequenza di campionamento [Hz]
fin = 93750    # frequenza ingresso sinusoidale [Hz]
A   = 120.0    # ampiezza sinusoide [mV]

t_samples = np.arange(N) / fs * 1e6   # microsecondi

# Vdiff ricostruito: D = Vdiff/(2mV) + 127.5  ->  Vdiff = (D - 127.5) * 2 mV
vdiff     = (codes - 127.5) * 2.0
t_cont    = np.linspace(0, (N - 1) / fs, 2000) * 1e6
vdiff_ref = A * np.sin(2 * np.pi * fin * t_cont / 1e6)

fig, axes = plt.subplots(2, 1, figsize=(12, 9))

ax1 = axes[0]
ax1.plot(t_cont, vdiff_ref, '--', color='gray', linewidth=1,
         label='Ingresso ideale')
ax1.step(t_samples, vdiff, where='post', color='steelblue',
         linewidth=1.5, label='Uscita ADC ricostruita')
ax1.set_xlabel('Tempo (µs)')
ax1.set_ylabel('$V_{diff}$ (mV)')
ax1.set_title(f'SAR ADC 8 bit — risposta sinusoidale '
              f'({fin/1e3:.2f} kHz, ampiezza {A:.0f} mV, {N} campioni)')
ax1.legend()
ax1.grid(alpha=0.4)

# =============================================================================
# 4. FFT e metriche dinamiche — SENZA finestra (campionamento coerente)
#
#    Con campionamento coerente (fin = M/N * fs) tutta la potenza del segnale
#    cade in un singolo bin FFT. La finestra di Hanning NON deve essere usata:
#    disperderebbe la potenza del segnale su piu' bin e renderebbe il calcolo
#    di SNDR errato per difetto.
#    SNDR: potenza segnale (3 bin centrali) / potenza tutto il resto.
# =============================================================================
X    = np.fft.rfft(codes - codes.mean())
freq = np.fft.rfftfreq(N, 1.0 / fs)
Xm   = np.abs(X)
Xdb  = 20 * np.log10(Xm / Xm.max() + 1e-12)

signal_bin = np.argmax(Xm)
print(f"\nPicco FFT: bin {signal_bin} = {freq[signal_bin]/1e3:.2f} kHz "
      f"(atteso bin {round(fin*N/fs)} = {fin/1e3:.2f} kHz)")

b0, b1       = max(0, signal_bin - 1), min(len(Xm), signal_bin + 2)
signal_power = np.sum(Xm[b0:b1] ** 2)
noise_power  = np.sum(Xm ** 2) - signal_power

sndr = 10 * np.log10(signal_power / noise_power) if noise_power > 0 else 99.0
enob = (sndr - 1.76) / 6.02

Xdb_ns = Xdb.copy()
Xdb_ns[max(0, signal_bin - 2):signal_bin + 3] = -120
sfdr = -Xdb_ns.max()

ampl_codes = (codes.max() - codes.min()) / 2
sndr_th    = 6.02 * 8 + 1.76 + 20 * np.log10(ampl_codes / 127.5)

print(f"SNDR : {sndr:.1f} dB  (teorico ADC ideale 8 bit: {sndr_th:.1f} dB)")
print(f"ENOB : {enob:.1f} bit  (teorico: {(sndr_th-1.76)/6.02:.1f} bit)")
print(f"SFDR : {sfdr:.1f} dBFS")
print(f"Degrado rispetto all'ideale: {sndr_th-sndr:.1f} dB")

ax2 = axes[1]
ax2.plot(freq / 1e3, Xdb, color='steelblue', linewidth=1)
ax2.axvline(x=freq[signal_bin] / 1e3, color='red', linestyle='--',
            linewidth=0.8, label=f'fin = {freq[signal_bin]/1e3:.1f} kHz')
ax2.set_xlabel('Frequenza (kHz)')
ax2.set_ylabel('Ampiezza (dBFS)')
ax2.set_ylim(-90, 5)
ax2.set_xlim(0, fs / 2 / 1e3)
ax2.set_title(f'Spettro FFT — SNDR={sndr:.1f} dB, '
              f'ENOB={enob:.1f} bit, SFDR={sfdr:.1f} dBFS')
ax2.legend()
ax2.grid(alpha=0.4)

plt.tight_layout()
out_png = fname.replace('.txt', '_analysis.png')
plt.savefig(out_png, dpi=150)
print(f"\nPlot salvato: {out_png}")
plt.show()
