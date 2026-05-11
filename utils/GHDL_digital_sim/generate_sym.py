#!/usr/bin/env python3
"""
generate_sym.py — Generatore di simboli xschem per co-simulazione d_cosim
==========================================================================

Genera un file .sym per xschem a partire da un file Verilog behavioral,
seguendo il pattern del corso IHP Analog Academy adattato a SKY130A:

  - Porte bus compatte: dac_p[7..0] come pin singolo
  - Riga .model d_cosim inclusa nel format= del simbolo → nessun attributo
    device_model da aggiungere manualmente nell'istanza
  - Template con name=adut / model=dut come default pronti all'uso

Uso:
    python3 generate_sym.py <verilog_file> <symbol_file>

Esempio:
    python3 generate_sym.py xschem/simulations/sar_controller_behav.v \\
                            xschem/sar_controller.sym
"""

import re
import sys
import os


# =============================================================================
# Parsing Verilog
# =============================================================================

def parse_verilog(verilog_file):
    """
    Estrae nome modulo, ingressi e uscite da un file Verilog behavioral.

    I segnali bus (es. [7:0]) vengono espansi in pin singoli: pippo[7:0]
    diventa pippo7, pippo6, ..., pippo0 (MSB-first). Questa scelta semplifica
    il routing in xschem rispetto ai bus aggregati con bus_tap.
    """
    with open(verilog_file, "r") as f:
        code = f.read()

    module_match = re.search(r"module\s+(\w+)\s*[\(;]", code)
    if not module_match:
        raise ValueError(f"Nessun modulo trovato in {verilog_file}")
    module_name = module_match.group(1)

    code_no_comments = re.sub(r"//.*", "", code)

    # Le porte vanno estratte in DUE passaggi:
    # 1. Estraiamo la PORT LIST dall'header "module name(p1, p2, ...);"
    #    perché questa stabilisce l'ORDINE delle porte (come visto da d_cosim).
    # 2. Cerchiamo le dichiarazioni input/output [N:0] per ognuna di queste
    #    porte per ricavarne direzione e larghezza del bus.
    # NOTA: Yosys mantiene l'ordine VHDL nella port list, ma le dichiarazioni
    # input/output che seguono spesso sono in ordine alfabetico. Il d_cosim
    # di ngspice usa l'ordine della port list, non quello delle dichiarazioni.

    # Step 1: estrai la port list ordinata
    portlist_match = re.search(
        rf"\bmodule\s+{re.escape(module_name)}\s*\(([^)]*)\)",
        code_no_comments, re.DOTALL
    )
    if not portlist_match:
        raise ValueError(f"Port list non trovata per modulo {module_name}")
    portlist_raw = portlist_match.group(1)
    port_order = [p.strip() for p in portlist_raw.split(",") if p.strip()]

    # Step 2: limita il body al modulo (per evitare di prendere dichiarazioni
    # interne di function come porte), poi cerca direzione e larghezza per
    # ognuna delle porte trovate nella port list
    module_start = portlist_match.end()
    body_start = re.search(
        r"\b(always|function|assign|initial|generate)\b",
        code_no_comments[module_start:]
    )
    if body_start:
        header = code_no_comments[module_start:module_start + body_start.start()]
    else:
        header = code_no_comments[module_start:]

    port_decl_pattern = re.compile(
        r"\b(input|output)\b"
        r"(?:\s+(?:wire|reg))?"
        r"(?:\s*(\[\s*\d+\s*:\s*\d+\s*\]))?"
        r"\s+(\w+)\s*;"
    )

    # Costruisci dizionario nome → (direzione, range)
    port_info = {}
    for m in port_decl_pattern.finditer(header):
        direction = m.group(1)
        bus_range = m.group(2)
        name      = m.group(3)
        port_info[name] = (direction, bus_range)

    inputs = []
    outputs = []

    # Itera sulla port list nell'ordine corretto
    for port_name in port_order:
        if port_name not in port_info:
            print(f"AVVISO: porta '{port_name}' nella port list ma senza dichiarazione input/output")
            continue
        direction, bus_range = port_info[port_name]
        # Espandi i bus in pin singoli: pippo[7:0] → pippo7, pippo6, ..., pippo0
        # In ordine MSB-first per coerenza con la dichiarazione VHDL std_logic_vector(N downto 0).
        name = port_name
        if bus_range:
            nums = re.findall(r"\d+", bus_range)
            msb, lsb = int(nums[0]), int(nums[1])
            if msb >= lsb:
                port_labels = [f"{name}{i}" for i in range(msb, lsb - 1, -1)]
            else:
                port_labels = [f"{name}{i}" for i in range(msb, lsb + 1)]
        else:
            port_labels = [name]

        target = inputs if direction == "input" else outputs
        for port_label in port_labels:
            if port_label not in target:
                target.append(port_label)

    if not inputs and not outputs:
        raise ValueError(
            f"Nessuna porta input/output trovata in {verilog_file}.\n"
            "Assicurati che il file sia Verilog behavioral."
        )

    return module_name, inputs, outputs


# =============================================================================
# Header xschem obbligatorio
# =============================================================================

XSCHEM_HEADER = """\
v {xschem version=3.4.5 file_version=1.2
*
* This file is part of XSCHEM,
* a schematic capture and Spice/Vhdl/Verilog netlisting tool for circuit
* simulation.
* Copyright (C) 1998-2023 Stefan Frederik Schippers
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
}"""


# =============================================================================
# Generazione simbolo xschem
# =============================================================================

def generate_xschem_symbol(verilog_file, output_sym):
    """
    Genera il file .sym per xschem.

    FIX 1 — Testo pin:
      flip=0 → testo si estende a DESTRA dell'ancora (x, y)
      flip=1 → testo specchiato, si estende a SINISTRA
      Ingressi (x negativa): flip=0 → testo va verso destra = dentro il box
      Uscite   (x positiva): flip=1 → testo specchiato va a sinistra = dentro il box

    FIX 2 — Attributo model:
      Il format= include la riga .model d_cosim su una seconda riga.
      @model viene sostituito con il valore dell'attributo 'model' dell'istanza.
      Il template propone model=dut come default.
      Nessun attributo device_model da aggiungere manualmente.
    """
    module_name, inputs, outputs = parse_verilog(verilog_file)

    so_name = os.path.basename(verilog_file).replace(".v", ".so")

    # Riferimenti di porta per format= (doppia @@ → valore del net)
    def port_ref(p):
        return f"@@{p}"

    fmt_inputs  = " ".join(port_ref(p) for p in inputs)
    fmt_outputs = " ".join(port_ref(p) for p in outputs)

    # ------------------------------------------------------------------
    # Blocco K — il format= è su DUE RIGHE:
    #   riga 1: istanza  → Aname [ in... ] [ out... ] model_name
    #   riga 2: .model   → .model model_name d_cosim simulation=./xxx.so
    # @model viene sostituito con il valore dell'attributo 'model'
    # dell'istanza (default: 'dut'). Se l'utente cambia 'model', entrambe
    # le righe si aggiornano in modo consistente.
    # ------------------------------------------------------------------
    k_block_lines = [
        "K {type=primitive",
        "verilog_ignore=true",
        "vhdl_ignore=true",
        f'format="@name [ {fmt_inputs} ] [ {fmt_outputs} ] @model',
        f'.model @model d_cosim simulation=./{so_name}"',
        'template="name=adut',
        'model=dut"',
        "}",
    ]
    k_block = "\n".join(k_block_lines)

    # ------------------------------------------------------------------
    # Geometria
    # ------------------------------------------------------------------
    PIN_PITCH  = 20
    BOX_W      = 120
    PIN_LEN    = 20
    PIN_SZ     = 2.5
    TEXT_INSET = 12   # distanza del testo dalla parete interna del box

    n_in  = len(inputs)
    n_out = len(outputs)
    n_max = max(n_in, n_out, 1)

    box_h    = (n_max - 1) * PIN_PITCH + 2 * PIN_PITCH
    box_half = box_h // 2

    def pin_y(idx, n_pins):
        total_span = (n_pins - 1) * PIN_PITCH
        return -total_span // 2 + idx * PIN_PITCH

    # ------------------------------------------------------------------
    # Costruzione righe .sym
    # ------------------------------------------------------------------
    lines = [XSCHEM_HEADER, "G {}", k_block, "V {}", "S {}", "E {}"]

    # Linee L di collegamento pin
    for i in range(n_in):
        y = pin_y(i, n_in)
        lines.append(f"L 4 {-(BOX_W + PIN_LEN)} {y} {-BOX_W} {y} {{}}")
    for i in range(n_out):
        y = pin_y(i, n_out)
        lines.append(f"L 4 {BOX_W} {y} {BOX_W + PIN_LEN} {y} {{}}")

    # Box
    lines.append(f"L 4 {-BOX_W} {-box_half} {-BOX_W} {box_half} {{}}")
    lines.append(f"L 4  {BOX_W} {-box_half}  {BOX_W} {box_half} {{}}")
    lines.append(f"L 4 {-BOX_W} {-box_half}  {BOX_W} {-box_half} {{}}")
    lines.append(f"L 4 {-BOX_W}  {box_half}  {BOX_W}  {box_half} {{}}")

    # Quadratini pin B 5
    for i, pname in enumerate(inputs):
        y = pin_y(i, n_in)
        x = -(BOX_W + PIN_LEN)
        lines.append(
            f"B 5 {x-PIN_SZ} {y-PIN_SZ} {x+PIN_SZ} {y+PIN_SZ} "
            f"{{name={pname} dir=in verilog_type=wire propag=0}}"
        )
    for i, pname in enumerate(outputs):
        y = pin_y(i, n_out)
        x = BOX_W + PIN_LEN
        lines.append(
            f"B 5 {x-PIN_SZ} {y-PIN_SZ} {x+PIN_SZ} {y+PIN_SZ} "
            f"{{name={pname} dir=out verilog_type=wire propag=1}}"
        )

    # Etichette testo
    # Nome modulo centrato nel box
    lines.append(f'T {{{module_name}}} 0 0 0 0 0.3 0.3 {{hcenter=true vcenter=true}}')
    # Intestazione
    lines.append(f'T {{@name}}  {-BOX_W} {-box_half - 18} 0 0 0.2 0.2 {{}}')
    lines.append(f'T {{d_cosim}} {-BOX_W} {-box_half - 6}  0 0 0.15 0.15 {{layer=4}}')

    # Etichette pin — DENTRO il box
    # flip=0: testo va a DESTRA dell'ancora → per ingressi (x negativa) va verso l'interno
    # flip=1: testo specchiato va a SINISTRA → per uscite (x positiva) va verso l'interno
    for i, pname in enumerate(inputs):
        y = pin_y(i, n_in)
        x = -(BOX_W - TEXT_INSET)
        lines.append(f'T {{{pname}}} {x} {y - 4} 0 0 0.15 0.15 {{}}')

    for i, pname in enumerate(outputs):
        y = pin_y(i, n_out)
        x = BOX_W - TEXT_INSET
        lines.append(f'T {{{pname}}} {x} {y - 4} 0 1 0.15 0.15 {{}}')

    # Scrittura file
    with open(output_sym, "w") as f:
        f.write("\n".join(lines) + "\n")

    print(f"Modulo     : {module_name}")
    print(f"Ingressi   : {inputs}")
    print(f"Uscite     : {outputs}")
    print(f"Simbolo    → {output_sym}")
    print()
    print("Proprietà dell'istanza in xschem (già pronte nel template):")
    print(f"  name  = adut")
    print(f"  model = dut")
    print()
    print("Netlist generato automaticamente da xschem:")
    print(f"  adut [ {' '.join(inputs)} ] [ {' '.join(outputs)} ] dut")
    print(f"  .model dut d_cosim simulation=./{so_name}")


# =============================================================================
# Entry point
# =============================================================================

def main():
    if len(sys.argv) != 3:
        print()
        print("Uso:     python3 generate_sym.py <verilog_file> <symbol_file>")
        print("Esempio: python3 generate_sym.py xschem/simulations/sar_controller_behav.v \\")
        print("                                 xschem/sar_controller.sym")
        print()
        sys.exit(1)

    verilog_file = sys.argv[1]
    sym_file     = sys.argv[2]

    if not os.path.isfile(verilog_file):
        print(f"ERRORE: file non trovato: {verilog_file}")
        sys.exit(1)

    try:
        generate_xschem_symbol(verilog_file, sym_file)
    except Exception as e:
        print(f"ERRORE: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
