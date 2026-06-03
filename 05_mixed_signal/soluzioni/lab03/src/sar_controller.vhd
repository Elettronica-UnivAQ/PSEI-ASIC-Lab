library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- =============================================================================
-- SAR ADC Controller — Procedura di switching monotonica
-- =============================================================================
--
-- Architettura: FSM Moore a 11 stati, 10 cicli di clock per conversione.
-- Filo conduttore PSEI — Università degli Studi dell'Aquila.
--
-- Procedura di switching monotonica (Liu et al., JSSC 2010):
--   Campionamento sulla top plate del CDAC con bottom plate inizializzate a
--   Vref. La prima comparazione è gratuita (nessuna commutazione). Ad ogni
--   bit, solo UN condensatore di UN solo ramo viene abbassato da Vref a GND:
--     VOUTP > VOUTN (out_comp_p='0'): bit=1, abbassa ramo positivo
--     VOUTP < VOUTN (out_comp_p='1'): bit=0, abbassa ramo negativo
--   Le bottom plate commutano monotonicamente da Vref verso GND, mai viceversa.
--   Questo è compatibile con il campionamento sulla top plate: le bottom plate
--   restano a Vref durante il campionamento e non perturbano la top plate.
--
-- Polarità del comparatore Strong-ARM (11T SKY130A):
--   out_comp_p='1' quando vin_p > vin_n (VOUTP > VOUTN)
--   out_comp_p='0' quando vin_p < vin_n (VOUTP < VOUTN)
--   Convenzione a logica positiva: il lato vincente va alto.
--   Verificato empiricamente: ctrl=1.8V nei T-gate abbassa le bottom plate
--   (logica ctrl=HIGH→GND). Quindi dac_p(k)=out_comp_p='1' quando
--   VOUTP>VOUTN → ctrl=HIGH → GND → abbassa ramo positivo.
--   dout(k) = out_comp_p (logica diretta, senza inversione).
--
-- Pipeline:
--   ST_CONV7: prima comparazione gratuita (phi_sample='0', nessuna commutazione)
--   ST_CONV6: decide bit 7 (legge out_comp_p da ST_CONV7), commuta dac_p(7)/dac_n(7)
--   ...
--   ST_OUTPUT: decide bit 0, commuta dac_p(0)/dac_n(0), asserisce eoc
--
-- clk_comp:
--   Clock gated per il comparatore: NOT(clk) AND NOT(phi_sample_r).
--   1° semiperiodo (clk=1): clk_comp=0 → precarica, il CDAC assesta.
--   2° semiperiodo (clk=0): clk_comp=1 → il comparatore valuta il CDAC assestato.
--   Al fronte di salita di clk il controller legge out_comp_p prima che la
--   precarica analogica (qualche ns) lo riporti a 1.
--
-- Interfaccia:
--   clk          : clock SAR, ~20 MHz, periodo 50 ns
--   rst_n        : reset asincrono attivo basso
--   out_comp_p   : uscita positiva comparatore ('0'=VOUTP>VOUTN, '1'=VOUTP<VOUTN)
--   out_comp_n   : uscita negativa comparatore (per completezza interfaccia)
--   phi_sample   : '1' = campionamento, '0' = conversione
--   phi_sample_n : complemento di phi_sample
--   clk_comp     : clock gated per il comparatore
--   dac_p        : bottom plate CDAC ramo Vinp ('1'=Vref, '0'=GND)
--   dac_n        : bottom plate CDAC ramo Vinn ('1'=Vref, '0'=GND)
--   dout         : risultato conversione 8 bit (valido quando eoc='1')
--   eoc          : end-of-conversion, impulso di 1 ciclo di clock
-- =============================================================================

entity sar_controller is
    port (
        clk          : in  std_logic;
        rst_n        : in  std_logic;
        out_comp_p   : in  std_logic;
        out_comp_n   : in  std_logic;
        phi_sample   : out std_logic;
        phi_sample_n : out std_logic;
        clk_comp     : out std_logic;
        dac_p        : out std_logic_vector(7 downto 0);
        dac_n        : out std_logic_vector(7 downto 0);
        dout         : out std_logic_vector(7 downto 0);
        eoc          : out std_logic
    );
end entity sar_controller;

architecture rtl of sar_controller is

    type state_t is (
        ST_RESET,
        ST_SAMPLE,
        ST_CONV7, ST_CONV6, ST_CONV5, ST_CONV4,
        ST_CONV3, ST_CONV2, ST_CONV1, ST_CONV0,
        ST_OUTPUT
    );
    signal state : state_t;

    signal phi_sample_r : std_logic;
    signal dac_p_r      : std_logic_vector(7 downto 0);
    signal dac_n_r      : std_logic_vector(7 downto 0);
    signal dout_r       : std_logic_vector(7 downto 0);

begin

    phi_sample   <= phi_sample_r;
    phi_sample_n <= not phi_sample_r;
    clk_comp     <= (not clk) and (not phi_sample_r);
    dac_p        <= dac_p_r;
    dac_n        <= dac_n_r;
    dout         <= dout_r;

    fsm: process(clk, rst_n)
    begin
        if rst_n = '0' then
            state        <= ST_RESET;
            phi_sample_r <= '0';
            dac_p_r      <= (others => '1');   -- Vref
            dac_n_r      <= (others => '1');   -- Vref
            dout_r       <= (others => '0');
            eoc          <= '0';

        elsif rising_edge(clk) then
            eoc <= '0';

            case state is

                -- -------------------------------------------------------------
                -- ST_RESET: inizializzazione, bottom plate a Vref
                -- -------------------------------------------------------------
                when ST_RESET =>
                    phi_sample_r <= '0';
                    dac_p_r      <= (others => '1');
                    dac_n_r      <= (others => '1');
                    dout_r       <= (others => '0');
                    state        <= ST_SAMPLE;

                -- -------------------------------------------------------------
                -- ST_SAMPLE: campionamento sulla top plate
                --   phi_sample='1' -> passgate chiuso, top plate segue Vin
                --   Bottom plate a Vref su entrambi i rami
                -- -------------------------------------------------------------
                when ST_SAMPLE =>
                    phi_sample_r <= '1';
                    dac_p_r      <= (others => '1');   -- tutte a Vref
                    dac_n_r      <= (others => '1');   -- tutte a Vref
                    state        <= ST_CONV7;

                -- -------------------------------------------------------------
                -- ST_CONV7: prima comparazione gratuita
                --   phi_sample='0' -> passgate aperto, top plate mantiene Vin
                --   Nessuna commutazione: il comparatore valuta direttamente
                --   VOUTP vs VOUTN senza perturbazioni del CDAC.
                -- -------------------------------------------------------------
                when ST_CONV7 =>
                    phi_sample_r <= '0';
                    -- dac_p_r e dac_n_r restano 11111111 da ST_SAMPLE
                    state        <= ST_CONV6;

                -- -------------------------------------------------------------
                -- Da ST_CONV6 a ST_OUTPUT: procedura monotonica
                --   out_comp_p='0' -> VOUTP>VOUTN -> bit=1, abbassa ramo +
                --     dac_p_r(k) <= '0' (Vref->GND sul ramo positivo)
                --     dac_n_r(k) <= '1' (ramo negativo invariato a Vref)
                --   out_comp_p='1' -> VOUTP<VOUTN -> bit=0, abbassa ramo -
                --     dac_p_r(k) <= '1' (ramo positivo invariato a Vref)
                --     dac_n_r(k) <= '0' (Vref->GND sul ramo negativo)
                --   In entrambi i casi: dac_p_r(k)=out_comp_p,
                --                       dac_n_r(k)=NOT out_comp_p,
                --                       dout_r(k) =NOT out_comp_p
                -- -------------------------------------------------------------

                -- ST_CONV6: decide bit 7
                when ST_CONV6 =>
                    dac_p_r(7)   <= out_comp_p;
                    dac_n_r(7)   <= not out_comp_p;
                    dout_r(7)    <= out_comp_p;
                    state        <= ST_CONV5;

                -- ST_CONV5: decide bit 6
                when ST_CONV5 =>
                    dac_p_r(6)   <= out_comp_p;
                    dac_n_r(6)   <= not out_comp_p;
                    dout_r(6)    <= out_comp_p;
                    state        <= ST_CONV4;

                -- ST_CONV4: decide bit 5
                when ST_CONV4 =>
                    dac_p_r(5)   <= out_comp_p;
                    dac_n_r(5)   <= not out_comp_p;
                    dout_r(5)    <= out_comp_p;
                    state        <= ST_CONV3;

                -- ST_CONV3: decide bit 4
                when ST_CONV3 =>
                    dac_p_r(4)   <= out_comp_p;
                    dac_n_r(4)   <= not out_comp_p;
                    dout_r(4)    <= out_comp_p;
                    state        <= ST_CONV2;

                -- ST_CONV2: decide bit 3
                when ST_CONV2 =>
                    dac_p_r(3)   <= out_comp_p;
                    dac_n_r(3)   <= not out_comp_p;
                    dout_r(3)    <= out_comp_p;
                    state        <= ST_CONV1;

                -- ST_CONV1: decide bit 2
                when ST_CONV1 =>
                    dac_p_r(2)   <= out_comp_p;
                    dac_n_r(2)   <= not out_comp_p;
                    dout_r(2)    <= out_comp_p;
                    state        <= ST_CONV0;

                -- ST_CONV0: decide bit 1
                when ST_CONV0 =>
                    dac_p_r(1)   <= out_comp_p;
                    dac_n_r(1)   <= not out_comp_p;
                    dout_r(1)    <= out_comp_p;
                    state        <= ST_OUTPUT;

                -- ST_OUTPUT: decide bit 0, asserisce eoc
                when ST_OUTPUT =>
                    dac_p_r(0)   <= out_comp_p;
                    dac_n_r(0)   <= not out_comp_p;
                    dout_r(0)    <= out_comp_p;
                    eoc          <= '1';
                    state        <= ST_SAMPLE;

                when others =>
                    state <= ST_RESET;

            end case;
        end if;
    end process fsm;

end architecture rtl;
