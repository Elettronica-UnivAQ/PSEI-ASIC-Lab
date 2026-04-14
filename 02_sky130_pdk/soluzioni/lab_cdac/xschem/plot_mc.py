import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import norm

# Leggi il file TXT prodotto da ngspice
data = np.loadtxt("simulation/vout_mc.txt", skiprows=1, usecols=1)
data_mV = data * 1000  # converti in mV

mean_mV = data_mV.mean()
sigma_mV = data_mV.std()
lsb_mV  = 1.8 / 256 * 1000  # mV per LSB (singolo ramo)

print(f"N       = {len(data_mV)} run")
print(f"Media   = {mean_mV:.4f} mV")
print(f"Sigma   = {sigma_mV:.4f} mV")
print(f"3sigma  = {3*sigma_mV:.4f} mV")
print(f"3sigma  = {3*sigma_mV/lsb_mV:.4f} LSB")

fig, ax = plt.subplots(figsize=(8, 4))

# Istogramma con valori assoluti in mV sull'asse X
n, bins, _ = ax.hist(data_mV, bins=30, edgecolor="black", color="steelblue",
                     alpha=0.7, label="Simulazione MC")

# Gaussiana sovrapposta (scalata alla stessa area dell'istogramma)
x = np.linspace(data_mV.min(), data_mV.max(), 300)
bin_width = bins[1] - bins[0]
gauss = norm.pdf(x, mean_mV, sigma_mV) * len(data_mV) * bin_width
ax.plot(x, gauss, "r-", linewidth=2, label=f"Gaussiana fitted\n$\mu$={mean_mV:.3f} mV\n$\sigma$={sigma_mV:.3f} mV")

ax.set_xlabel("VOUT [mV]")
ax.set_ylabel("Conteggio")
ax.set_title(f"MC CDAC — codice 10000000 (D=128) — 3$\sigma$ = {3*sigma_mV/lsb_mV:.3f} LSB")
ax.legend()
fig.tight_layout()
fig.savefig("simulation/vout_mc_hist.png", dpi=150)
plt.show()