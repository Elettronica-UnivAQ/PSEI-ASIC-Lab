library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- =============================================================================
-- Testbench per sar_controller — procedura monotonica — verifica nativa GHDL
-- =============================================================================
-- Scenario:
--   - clock 20 MHz (periodo 50 ns)
--   - reset attivo basso, rilasciato a t=100ns
--   - comparatore stub: out_comp_p='1' (VOUTP < VOUTN sempre)
--
-- Con out_comp_p='1' e procedura monotonica:
--   ogni comparazione: VOUTP<VOUTN -> bit=0, abbassa ramo negativo
--   dout = 00000000, tutti i dac_n abbassati uno per uno
--
-- Verifiche:
--   - dout = 0 a EOC (con stub out_comp_p='1')
--   - dac_p rimane 11111111 per tutto (ramo positivo mai abbassato)
--   - dac_n si abbassa bit per bit: 11111110, 11111100, ..., 00000000
--   - phi_sample_n = NOT phi_sample
--   - clk_comp = NOT(clk) AND NOT(phi_sample)
-- =============================================================================
entity sar_controller_tb is
end entity sar_controller_tb;

architecture sim of sar_controller_tb is

    signal clk          : std_logic := '0';
    signal rst_n        : std_logic := '0';
    signal out_comp_p   : std_logic := '1';   -- stub: VOUTP < VOUTN sempre
    signal out_comp_n   : std_logic := '0';

    signal phi_sample   : std_logic;
    signal phi_sample_n : std_logic;
    signal clk_comp     : std_logic;
    signal dac_p        : std_logic_vector(7 downto 0);
    signal dac_n        : std_logic_vector(7 downto 0);
    signal dout         : std_logic_vector(7 downto 0);
    signal eoc          : std_logic;

    constant T_CLK : time := 50 ns;

begin

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

    clk_gen: process
    begin
        clk <= '0'; wait for T_CLK / 2;
        clk <= '1'; wait for T_CLK / 2;
    end process clk_gen;

    rst_gen: process
    begin
        rst_n <= '0';
        wait for 100 ns;
        rst_n <= '1';
        wait;
    end process rst_gen;

    monitor: process
    begin
        wait until rst_n = '1';

        -- Verifica continua su 16 fronti di clock
        for i in 0 to 15 loop
            wait until rising_edge(clk);

            assert phi_sample_n = not phi_sample
                report "ERRORE: phi_sample_n non e' il complemento di phi_sample a t=" &
                       time'image(now)
                severity error;

            -- Sul fronte di salita clk=1 -> NOT(clk)=0 -> clk_comp=0
            assert clk_comp = '0'
                report "ERRORE: clk_comp deve essere '0' sul fronte di salita di clk a t=" &
                       time'image(now)
                severity error;

            -- Con stub=1: dac_p(k) cresce progressivamente (un bit per ciclo)
            -- dac_n rimane 00000000 per tutta la conversione
            if phi_sample = '0' then
                assert dac_n = "00000000"
                    report "ERRORE: dac_n deve essere 00000000 con stub out_comp_p='1' a t=" &
                           time'image(now)
                    severity error;
            end if;
        end loop;

        wait until eoc = '1';
        report "EOC asserito a t = " & time'image(now) &
               " - dout = " & integer'image(to_integer(unsigned(dout)));
        report "dac_p = " & to_string(dac_p) &
               "  dac_n = " & to_string(dac_n);

        -- Con stub out_comp_p='1' (VOUTP>VOUTN sempre): tutti i bit=1 -> dout=255
        assert to_integer(unsigned(dout)) = 255
            report "ERRORE: dout atteso 255 (stub out_comp_p='1'), ottenuto " &
                   integer'image(to_integer(unsigned(dout)))
            severity error;

        -- Con stub=1: dac_p=out_comp_p='1' per tutti i bit
        -- ctrl='1'=1.8V→T-gate→GND: tutti i BP del ramo positivo abbassati
        assert dac_p = "11111111"
            report "ERRORE: dac_p deve essere 11111111 con stub out_comp_p='1'"
            severity error;

        -- dac_n = NOT(out_comp_p) = 00000000: ramo negativo mai abbassato
        assert dac_n = "00000000"
            report "ERRORE: dac_n deve essere 00000000 (ramo negativo mai abbassato)"
            severity error;

        assert phi_sample = '0'
            report "ERRORE: phi_sample deve essere '0' a EOC"
            severity error;

        wait for 100 ns;
        std.env.finish;
    end process monitor;

end architecture sim;
