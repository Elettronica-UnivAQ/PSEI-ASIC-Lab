# Lab 02-B — `project.v`, test cocotb e verifica locale

## Obiettivo

Completare `src/project.v` istanziando il gate-level generato da LibreLane, configurare il test cocotb per le GitHub Actions, eseguire il test localmente con icarus, e committare i file pronti per la submission.

---

## Prerequisiti di questo lab

- Lab01-B completato: `src/tt_um_psei_NOME.v` (gate-level) presente e committato
- Il Makefile e `test.py` del template TinyTapeout sono presenti in `test/`

---

## Parte 1 — Completare `src/project.v`

### 1.1 Struttura del file

Il file `src/project.v` è il **top module del tile TinyTapeout**. Il template lo fornisce già con la dichiarazione del modulo e tutte le porte — non modificare la firma del modulo. Il tuo compito è aggiungere l'istanza del gate-level e la mappatura dei pin.

Il modulo TinyTapeout ha sempre questa interfaccia fissa (dal template):

```verilog
module tt_um_psei_NOME (
    input  wire [7:0] ui_in,    // 8 ingressi digitali
    output wire [7:0] uo_out,   // 8 uscite digitali
    input  wire [7:0] uio_in,   // 8 pin bidirezionali — lato ingresso
    output wire [7:0] uio_out,  // 8 pin bidirezionali — lato uscita
    output wire [7:0] uio_oe,   // direzione pin bidirezionali (1=output)
    input  wire       ena,      // abilitazione (ignorabile per la maggior parte)
    input  wire       clk,      // clock principale
    input  wire       rst_n     // reset attivo basso
);
```

### 1.2 Istanza del gate-level — analogia con la `port map` VHDL

L'istanza Verilog usa la sintassi con port mapping nominale: `.nome_porta_modulo(segnale_locale)`. È la diretta corrispondenza della `port map` VHDL.

```vhdl
-- In VHDL (Modulo 4):
u_ctrl : entity work.sar_controller
    port map (
        clk       => clk,
        rst_n     => rst_n,
        dout      => dout_int
    );
```

```verilog
// In Verilog (project.v):
sar_controller u_ctrl (
    .clk       (clk),
    .rst_n     (rst_n),
    .dout      (dout_int)
);
```

### 1.3 Esempio completo per il SAR controller

Questo esempio mostra come istanziare il SAR controller del Modulo 4. Adattalo al tuo design sostituendo i nomi delle porte.

```verilog
module tt_um_psei_NOME (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       ena,
    input  wire       clk,
    input  wire       rst_n
);

    // --- Segnali interni ---
    wire       out_comp_p;
    wire [7:0] dout;
    wire       eoc;
    wire       phi_sample;
    wire       phi_sample_n;
    wire       clk_comp;
    wire [7:0] dac_p;
    wire [7:0] dac_n;

    // --- Istanza gate-level ---
    // Il nome del modulo deve corrispondere esattamente a DESIGN_NAME in config.json
    tt_um_psei_NOME_ctrl u_ctrl (
        .clk          (clk),
        .rst_n        (rst_n),
        .out_comp_p   (out_comp_p),
        .out_comp_n   (~out_comp_p),
        .phi_sample   (phi_sample),
        .phi_sample_n (phi_sample_n),
        .clk_comp     (clk_comp),
        .dac_p        (dac_p),
        .dac_n        (dac_n),
        .dout         (dout),
        .eoc          (eoc)
    );

    // --- Mappatura pin TinyTapeout ---
    // Ingressi: comparatore stub da pin digitale esterno
    assign out_comp_p = ui_in[0];

    // Uscite digitali
    assign uo_out  = dout;
    assign uio_out = {eoc, phi_sample, clk_comp, 5'b0};
    assign uio_oe  = 8'hFF;    // tutti output

endmodule
```

> ⚠️ Le porte non connesse vanno incluse nella lista con porta vuota `.porta()` — non possono essere omesse dall'istanza.

> ⚠️ Le uscite digitali non usate devono essere collegate a `0`, non lasciate floating. Un output floating causa un errore di simulazione nel test cocotb (`is_resolvable` restituisce false) e potrebbe causare un DRC nelle Actions.

> 💡 Il `DESIGN_NAME` nel `config.json` di LibreLane è il nome del modulo **top** del gate-level, non quello del wrapper TT. Se hai impostato `DESIGN_NAME = "sar_controller"` nel Modulo 4, il modulo nel gate-level si chiama `sar_controller`, non `tt_um_psei_NOME`. Verifica con:
> ```bash
> grep "^module" src/tt_um_psei_NOME.v | head -1
> ```

---

## Parte 2 — `test/test.py`

Il template TinyTapeout include già un `test/test.py`. Sostituiscilo con questo smoke test, adattando solo i nomi dei pin al tuo design (le righe indicate):

```python
# test/test.py
# Smoke test gate-level per TinyTapeout (cocotb)
#
# Verifica: reset corretto + almeno un fronte di attivita' dopo reset.
# NON duplica il testbench VHDL: la verifica funzionale completa
# avviene con "make sim" in rtl/ (GHDL). Questo test verifica che
# il gate-level generato da LibreLane non sia degenere.

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Timer


@cocotb.test()
async def test_reset(dut):
    """Reset: tutte le uscite devono essere stabili dopo il reset."""
    clock = Clock(dut.clk, 50, units="ns")   # 20 MHz
    cocotb.start_soon(clock.start())

    # Applica reset
    dut.rst_n.value = 0
    dut.ui_in.value = 0
    await Timer(200, units="ns")

    # Verifica che le uscite siano stabili (nessun X o Z)
    assert dut.uo_out.value.is_resolvable, \
        "uo_out contiene valori non risolti (X/Z) durante il reset"
    assert dut.uio_out.value.is_resolvable, \
        "uio_out contiene valori non risolti (X/Z) durante il reset"

    dut.rst_n.value = 1


@cocotb.test()
async def test_basic_operation(dut):
    """Smoke test: il design risponde al clock dopo il reset."""
    clock = Clock(dut.clk, 50, units="ns")
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0
    dut.ui_in.value = 0
    await Timer(200, units="ns")
    dut.rst_n.value = 1

    # Attendi fino a 30 cicli e verifica che almeno un'uscita cambi
    initial_uo  = int(dut.uo_out.value)
    initial_uio = int(dut.uio_out.value)
    changed = False
    for _ in range(30):
        await RisingEdge(dut.clk)
        if (int(dut.uo_out.value)  != initial_uo or
                int(dut.uio_out.value) != initial_uio):
            changed = True
            break

    # Per design con uscite statiche dopo reset (es. combinatori puri),
    # questo assert puo' essere rimosso o adattato.
    assert changed, \
        "Le uscite non cambiano in 30 cicli — verificare il gate-level"
```

> 💡 Questo test è intenzionalmente minimale. La verifica funzionale completa è già stata fatta con il testbench VHDL nel Modulo 4. Qui verifichiamo solo che il gate-level non sia degenere (nessun X/Z in uscita, il design si attiva dopo il reset).

> ⚠️ Se il tuo design ha uscite statiche dopo il reset per definizione (es. un registro che rimane a zero fino a un comando), il secondo `assert` va adattato — altrimenti il test fallirà sempre anche con un design corretto.

---

## Parte 3 — `test/Makefile`

Apri `test/Makefile` e verifica o configura questi parametri:

```makefile
# test/Makefile
SIM           ?= icarus
TOPLEVEL_LANG  = verilog

# Gate-level committato in src/
VERILOG_SOURCES  = $(PWD)/../src/tt_um_psei_NOME.v
VERILOG_SOURCES += $(PWD)/../src/project.v

# Celle standard SKY130A (necessarie per la simulazione gate-level)
VERILOG_SOURCES += $(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v

# Il TOPLEVEL deve corrispondere al nome del modulo in project.v
TOPLEVEL = tt_um_psei_NOME
MODULE   = test

# Forza i valori X a zero (comportamento più prevedibile)
export COCOTB_RESOLVE_X = ZEROS

include $(shell cocotb-config --makefiles)/Makefile.sim
```

> ⚠️ Il valore di `TOPLEVEL` deve corrispondere esattamente al nome del modulo dichiarato in `src/project.v`. Se c'è una discrepanza, icarus compila ma cocotb non trova il modulo e il test fallisce silenziosamente.

> ⚠️ La versione di cocotb usata dalle GitHub Actions è **1.8.1** (da `test/requirements.txt`). La sintassi dei due test sopra è compatibile con questa versione. Se usi feature introdotte in cocotb 2.x, il test passerà localmente ma fallirà nelle Actions.

---

## Parte 4 — Verifica locale con icarus

```bash
cd /foss/designs/modulo6/tt_um_psei_NOME/test
make
```

L'output atteso termina con:

```
PASS  test_reset           ...
PASS  test_basic_operation ...
** 2 tests passed **
```

Se un test fallisce, il messaggio di errore indica quale `assert` non è stato soddisfatto. Errori tipici:

- **"X/Z durante il reset"** — `uio_oe` non è collegato a `8'hFF` in `project.v` e rimane alta impedenza
- **"Le uscite non cambiano"** — la logica del design non si attiva, oppure l'ingresso `ui_in` va configurato prima del reset (adatta il test)
- **"Module not found"** — `TOPLEVEL` nel Makefile non corrisponde al nome del modulo in `project.v`
- **"Undefined reference"** — la `sky130_fd_sc_hd.v` non è nel path; verifica che `$PDK_ROOT` sia settato nel container

**Numero di test passati:** `?` / 2

---

## Parte 5 — Commit finale

```bash
cd /foss/designs/modulo6/tt_um_psei_NOME

git add src/project.v
git add test/test.py
git add test/Makefile

git commit -m "feat: complete project.v mapping, cocotb smoke test PASS locally"
git push
```

Procedi al [Lab03](./lab03_actions_submission.md).
