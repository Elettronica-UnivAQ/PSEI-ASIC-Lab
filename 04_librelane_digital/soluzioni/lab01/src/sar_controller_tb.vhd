library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- =============================================================================
-- Testbench per sar_controller -- procedura monotonica -- verifica funzionale
-- =============================================================================
-- Il testbench simula un ingresso differenziale analogico tramite un modello
-- comportamentale del comparatore che usa lo stato corrente del CDAC.
--
-- Modello comparatore:
--   out_comp_p='1' se V_diff_eff > 0, dove:
--   V_diff_eff = (2*vin_code - 255) - (to_integer(dac_p) - to_integer(dac_n))
--
--   Inizialmente dac_p=dac_n=255 → V_diff_eff = 2*vin_code - 255.
--   Per vin_code > 127: V_diff_eff > 0 (VOUTP > VOUTN) → out_comp_p='1'.
--   Per vin_code < 128: V_diff_eff < 0 (VOUTP < VOUTN) → out_comp_p='0'.
--   Ad ogni decisione di bit il differenziale converge verso zero.
--
-- Codici di test e risultati attesi:
--   vin_code =   0 → dout = 0x00   (minimo)
--   vin_code =   1 → dout = 0x01   (quasi minimo)
--   vin_code =  64 → dout = 0x40
--   vin_code = 127 → dout = 0x7F   (sotto metascala)
--   vin_code = 128 → dout = 0x80   (sopra metascala)
--   vin_code = 192 → dout = 0xC0
--   vin_code = 200 → dout = 0xC8
--   vin_code = 255 → dout = 0xFF   (massimo)
-- =============================================================================
entity sar_controller_tb is
end entity sar_controller_tb;

architecture sim of sar_controller_tb is

    constant T_CLK : time := 50 ns;   -- 20 MHz

    -- Codici di test: coprono i casi limite e valori tipici
    type input_array_t is array (natural range <>) of integer;
    constant VIN_CODES : input_array_t := (0, 1, 64, 127, 128, 192, 200, 255);

    signal clk          : std_logic := '0';
    signal rst_n        : std_logic := '0';
    signal comp_out_p   : std_logic := '0';
    signal comp_out_n   : std_logic := '1';

    signal phi_sample   : std_logic;
    signal phi_sample_n : std_logic;
    signal clk_comp     : std_logic;
    signal dac_p        : std_logic_vector(7 downto 0);
    signal dac_n        : std_logic_vector(7 downto 0);
    signal dout         : std_logic_vector(7 downto 0);
    signal eoc          : std_logic;

    -- Codice target corrente per il modello di comparatore
    signal vin_code     : integer := 0;

begin

    dut: entity work.sar_controller
        port map (
            clk          => clk,
            rst_n        => rst_n,
            out_comp_p   => comp_out_p,
            out_comp_n   => comp_out_n,
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
        wait for 3 * T_CLK;
        rst_n <= '1';
        wait;
    end process rst_gen;

    -- =========================================================================
    -- Modello comportamentale del comparatore -- procedura monotonica
    -- =========================================================================
    -- Il processo e' combinatorio: si aggiorna ogni volta che dac_p, dac_n
    -- o vin_code cambiano. Il ritardo di 1 ns modella la latenza di
    -- rigenerazione del comparatore Strong-ARM (trascurabile rispetto a
    -- T_CLK = 50 ns).
    --
    -- Guardia metavalue: prima del reset dac_p e dac_n sono 'U'. Il
    -- controllo sulle prime cifre evita warning da to_integer su valori
    -- indefiniti.
    -- =========================================================================
    comp_model: process(dac_p, dac_n, vin_code)
        variable dp, dn : integer;
    begin
        if (dac_p(0) = '0' or dac_p(0) = '1') and
           (dac_n(0) = '0' or dac_n(0) = '1') then
            dp := to_integer(unsigned(dac_p));
            dn := to_integer(unsigned(dac_n));
            -- out_comp_p = '1' se VOUTP > VOUTN, cioe' V_diff_eff > 0
            if (2*vin_code - 255) > (dp - dn) then
                comp_out_p <= '1' after 1 ns;
                comp_out_n <= '0' after 1 ns;
            else
                comp_out_p <= '0' after 1 ns;
                comp_out_n <= '1' after 1 ns;
            end if;
        end if;
    end process comp_model;

    -- =========================================================================
    -- Sequenza di stimoli e verifica
    -- =========================================================================
    stimoli: process
        variable n_pass, n_fail : integer := 0;
    begin
        -- Attende il rilascio del reset
        wait until rst_n = '1';
        wait for T_CLK;

        -- Ciclo su tutti i codici di test
        for k in VIN_CODES'range loop
            -- Imposta il codice target per il modello di comparatore
            vin_code <= VIN_CODES(k);

            -- Attende la fine della conversione (EOC)
            wait until rising_edge(eoc);
            -- Mezzo ciclo per lasciare stabilizzare dout
            wait for T_CLK / 2;

            -- Verifica: dout deve essere uguale al codice atteso
            if to_integer(unsigned(dout)) = VIN_CODES(k) then
                report "PASS: vin=" & integer'image(VIN_CODES(k)) &
                       " -> dout=0x" & integer'image(to_integer(unsigned(dout)))
                severity note;
                n_pass := n_pass + 1;
            else
                report "FAIL: vin=" & integer'image(VIN_CODES(k)) &
                       " -> dout=0x" & integer'image(to_integer(unsigned(dout))) &
                       " (atteso 0x" & integer'image(VIN_CODES(k)) & ")"
                severity error;
                n_fail := n_fail + 1;
            end if;

            -- Attende un ciclo prima della prossima conversione
            wait for T_CLK;
        end loop;

        -- Riepilogo finale
        report "Simulazione completata: " &
               integer'image(n_pass) & " PASS, " &
               integer'image(n_fail) & " FAIL"
        severity note;

        wait for T_CLK * 2;
        std.env.finish;
    end process stimoli;

end architecture sim;
