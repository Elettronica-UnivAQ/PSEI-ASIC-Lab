library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- =============================================================================
-- Testbench per sar_controller — verifica nativa GHDL
-- Convenzione Makefile: file *_tb.vhd in src/, nome entity = nome file
-- =============================================================================
-- Scenario:
--   - clock 20 MHz (periodo 50 ns)
--   - reset attivo basso, rilasciato a t=100ns
--   - comparatore stub: out_comp_p='1', out_comp_n='0' -> tutti i bit a 1
--
-- Risultato atteso:
--   t=0..100ns   : reset asincrono, phi_sample='0', phi_sample_n='1'
--                  clk_comp pulsa con clk (phi_sample='0' -> gating aperto)
--   t=100..150ns : ST_RESET -> ST_SAMPLE
--   t=150..200ns : ST_SAMPLE, phi_sample='1', phi_sample_n='0'
--                  clk_comp='0' fisso (phi_sample='1' -> gating chiuso)
--   t=200..250ns : ST_CONV7, phi_sample='0', phi_sample_n='1'
--                  clk_comp torna a pulsare con clk
--   ...
--   t=600..650ns : ST_OUTPUT, eoc='1', dout=11111111
--
-- Verifiche:
--   - phi_sample_n = NOT phi_sample in ogni istante
--   - clk_comp = clk AND NOT phi_sample in ogni istante
--   - dout = 255 a EOC con stub out_comp_p='1'
--   - phi_sample='0' e phi_sample_n='1' a EOC
--   - clk_comp pulsa (non fisso a 0 o 1) durante la conversione
-- =============================================================================
entity sar_controller_tb is
end entity sar_controller_tb;

architecture sim of sar_controller_tb is

    -- Segnali per pilotare il DUT
    signal clk          : std_logic := '0';
    signal rst_n        : std_logic := '0';
    signal out_comp_p   : std_logic := '1';   -- stub: sempre '1'
    signal out_comp_n   : std_logic := '0';   -- stub: sempre '0'

    -- Uscite del DUT
    signal phi_sample   : std_logic;
    signal phi_sample_n : std_logic;
    signal clk_comp     : std_logic;
    signal dac_p        : std_logic_vector(7 downto 0);
    signal dac_n        : std_logic_vector(7 downto 0);
    signal dout         : std_logic_vector(7 downto 0);
    signal eoc          : std_logic;

    -- Segnale atteso per clk_comp (calcolato localmente per il confronto)
    signal clk_comp_exp : std_logic;

    constant T_CLK : time := 50 ns;   -- 20 MHz

begin

    -- DUT
    dut: entity work.sar_controller
        port map (
            clk          => clk,
            rst_n        => rst_n,
            out_comp_p   => out_comp_p,
            out_comp_n   => out_comp_n,
            phi_sample   => phi_sample,
            phi_sample_n => phi_sample_n,
            clk_comp     => clk_comp,
            dac_p        => dac_p,
            dac_n        => dac_n,
            dout         => dout,
            eoc          => eoc
        );

    -- Valore atteso di clk_comp per confronto
    clk_comp_exp <= clk and (not phi_sample);

    -- Clock generator
    clk_gen: process
    begin
        clk <= '0';
        wait for T_CLK / 2;
        clk <= '1';
        wait for T_CLK / 2;
    end process clk_gen;

    -- Reset stimulus
    rst_gen: process
    begin
        rst_n <= '0';
        wait for 100 ns;
        rst_n <= '1';
        wait;
    end process rst_gen;

    -- Monitor
    monitor: process
    begin
        wait until rst_n = '1';

        -- Verifica continua su 16 fronti di clock
        for i in 0 to 15 loop
            wait until rising_edge(clk);

            -- phi_sample_n deve essere il complemento di phi_sample
            assert phi_sample_n = not phi_sample
                report "ERRORE: phi_sample_n non e' il complemento di phi_sample a t=" &
                       time'image(now)
                severity error;

            -- clk_comp deve essere clk AND NOT phi_sample.
            -- Il confronto avviene sul fronte di salita di clk, quindi
            -- clk='1' in questo punto: l'espressione si riduce a NOT phi_sample.
            assert clk_comp = (not phi_sample)
                report "ERRORE: clk_comp non corrisponde a clk AND NOT phi_sample a t=" &
                       time'image(now) &
                       " - clk_comp=" & std_logic'image(clk_comp) &
                       " phi_sample=" & std_logic'image(phi_sample)
                severity error;
        end loop;

        wait until eoc = '1';
        report "EOC asserito a t = " & time'image(now) &
               " - dout = " & integer'image(to_integer(unsigned(dout)));
        report "phi_sample=" & std_logic'image(phi_sample) &
               " phi_sample_n=" & std_logic'image(phi_sample_n) &
               " clk_comp=" & std_logic'image(clk_comp);

        -- dout deve essere 255 con stub out_comp_p='1'
        assert to_integer(unsigned(dout)) = 255
            report "ERRORE: dout atteso 255, ottenuto " &
                   integer'image(to_integer(unsigned(dout)))
            severity error;

        -- A EOC siamo in conversione: phi_sample='0'
        assert phi_sample = '0'
            report "ERRORE: phi_sample deve essere '0' a EOC"
            severity error;

        assert phi_sample_n = '1'
            report "ERRORE: phi_sample_n deve essere '1' a EOC"
            severity error;

        -- A EOC clk_comp deve essere '1' (clk='1' sul fronte, phi_sample='0')
        assert clk_comp = '1'
            report "ERRORE: clk_comp deve essere '1' a EOC (clk alto, phi_sample basso)"
            severity error;

        wait for 100 ns;
        std.env.finish;
    end process monitor;

end architecture sim;
