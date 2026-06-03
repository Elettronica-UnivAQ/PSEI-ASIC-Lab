library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- =============================================================================
-- counter4 — Contatore binario a 4 bit
-- =============================================================================
-- Progetto di test per la pipeline di co-simulazione mixed-signal:
--   VHDL → Yosys+GHDL → Verilog behavioral → Verilator .so → d_cosim xschem
--
-- Le uscite sono segnali individuali (non un bus) per semplicità di debug
-- nella prima fase: questo evita ambiguità sull'espansione dei bus nel
-- netlist d_cosim. Una volta verificata la pipeline, si usa il SAR
-- controller con porte bus vere.
--
-- Comportamento atteso (clock 10 MHz, reset per 200 ns):
--   - q0 alterna ogni ciclo   → periodo 200 ns (5 MHz)
--   - q1 alterna ogni 2 cicli → periodo 400 ns (2.5 MHz)
--   - q2 alterna ogni 4 cicli → periodo 800 ns (1.25 MHz)
--   - q3 alterna ogni 8 cicli → periodo 1600 ns (625 kHz)
--   - ciclo completo 0→15→0 in 1600 ns
-- =============================================================================

entity counter4 is
    port (
        clk   : in  std_logic;   -- clock (fronte di salita attivo)
        rst_n : in  std_logic;   -- reset asincrono attivo basso
        q3    : out std_logic;   -- bit 3 (MSB)
        q2    : out std_logic;   -- bit 2
        q1    : out std_logic;   -- bit 1
        q0    : out std_logic    -- bit 0 (LSB)
    );
end entity counter4;

architecture rtl of counter4 is

    -- Registro interno: ASIC-style, nessuna inizializzazione esplicita.
    -- Lo stato iniziale è imposto esclusivamente da rst_n.
    signal count_r : unsigned(3 downto 0);

begin

    -- Assegnazione uscite individuali dal registro interno
    q3 <= count_r(3);
    q2 <= count_r(2);
    q1 <= count_r(1);
    q0 <= count_r(0);

    -- Processo sequenziale con reset asincrono (stile ASIC SKY130A)
    process(clk, rst_n)
    begin
        if rst_n = '0' then
            count_r <= (others => '0');
        elsif rising_edge(clk) then
            count_r <= count_r + 1;
        end if;
    end process;

end architecture rtl;
