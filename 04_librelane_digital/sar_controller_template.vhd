library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- =============================================================================
-- SAR ADC Controller — Template per lo studente
-- =============================================================================
-- Completa l'architettura RTL sulla base dello schema a blocchi e del
-- diagramma di timing analizzati nella Parte 1 del lab.
--
-- Suggerimenti:
--   1. Definisci un tipo enumerato per gli stati della FSM (Parte 1.3)
--   2. Dichiara i segnali interni registrati per dac_p, dac_n, dout e
--      phi_sample (vedi TODO 2b per il motivo)
--   3. Scrivi il processo sincrono con reset asincrono attivo basso
--   4. ST_CONV7 e' la comparazione GRATUITA: nessuna commutazione del CDAC
--      (Parte 1.4). La prima commutazione avviene in ST_CONV6.
--   5. dout e' un'uscita REGISTERED: dout <= dout_r (nessuna Mealy).
--      dout_r(k) <= out_comp_p in ogni stato ST_CONVk e ST_OUTPUT.
--
-- Interfaccia (non modificare):
--   clk          : clock SAR, ~20 MHz, periodo 50 ns
--   rst_n        : reset asincrono attivo basso
--   out_comp_p   : uscita positiva comparatore Strong-ARM ('1' = Vinp > Vinn)
--   out_comp_n   : uscita negativa comparatore (per completezza interfaccia)
--   phi_sample   : '1' = campionamento, '0' = conversione
--   phi_sample_n : complemento di phi_sample
--   clk_comp     : clock gated per il comparatore Strong-ARM.
--                  Generato come NOT(clk) AND NOT(phi_sample_r): vale 0
--                  durante ST_SAMPLE e nel 1° semiperiodo di ogni ciclo
--                  SAR, vale 1 nel 2° semiperiodo (il comparatore valuta
--                  il CDAC assestato). Da generare come assegnazione
--                  concorrente (TODO 3), non dentro il processo FSM.
--   dac_p        : bottom plate CDAC ramo Vinp ('1'=abbassa, '0'=Vref)
--   dac_n        : bottom plate CDAC ramo Vinn ('1'=abbassa, '0'=Vref)
--                  Procedura monotonica: durante ST_SAMPLE entrambi =11111111
--                  (tutte a Vref). In ST_CONV7 nessuna commutazione (comp.
--                  gratuita). Da ST_CONV6 in poi: dac_p(k)<=out_comp_p,
--                  dac_n(k)<=NOT(out_comp_p), dout(k)<=out_comp_p.
--   dout         : risultato conversione 8 bit (valido quando eoc='1')
--   eoc          : end-of-conversion, impulso di 1 ciclo di clock
-- =============================================================================

entity sar_controller is
    port (
        clk          : in  std_logic;
        rst_n        : in  std_logic;
        out_comp_p   : in  std_logic;   -- uscita positiva comparatore ('1' = Vinp > Vinn)
        out_comp_n   : in  std_logic;   -- uscita negativa comparatore (per completezza)
        phi_sample   : out std_logic;
        phi_sample_n : out std_logic;   -- complemento di phi_sample: clock del comparatore
        dac_p        : out std_logic_vector(7 downto 0);
        dac_n        : out std_logic_vector(7 downto 0);
        dout         : out std_logic_vector(7 downto 0);
        eoc          : out std_logic;
        clk_comp     : out std_logic    -- clock gated per il comparatore: clk AND NOT phi_sample
    );
end entity sar_controller;

architecture rtl of sar_controller is

    -- -------------------------------------------------------------------------
    -- TODO 1: Definisci il tipo enumerato per gli stati della FSM
    --
    -- Gli stati necessari sono:
    --   ST_RESET  : inizializzazione
    --   ST_SAMPLE : campionamento (phi_sample='1', 1 ciclo)
    --   ST_CONV7 .. ST_CONV0 : conversione bit per bit (8 cicli)
    --   ST_OUTPUT : lettura LSB e asserzione EOC (1 ciclo)
    -- -------------------------------------------------------------------------
    -- type state_t is ( ... );
    -- signal state : state_t;

    -- -------------------------------------------------------------------------
    -- TODO 2: Dichiara i registri interni per le uscite dac_p, dac_n, dout
    --
    -- Le uscite dac_p, dac_n e dout devono essere registered (cambiano
    -- solo sul fronte di salita del clock). Dichiarale come segnali interni
    -- e poi assegnale alle porte di uscita con assegnazioni concorrenti.
    --
    -- ATTENZIONE: dac_n_r va inizializzato a (others => '1') in ST_RESET e
    -- ST_SAMPLE — nell'architettura a 2 vie (VDD/GND), '1' = GND per dac_n.
    -- Durante il campionamento tutte le piastre inferiori devono essere a GND.
    -- -------------------------------------------------------------------------
    -- signal dac_p_r : std_logic_vector(7 downto 0);
    -- signal dac_n_r : std_logic_vector(7 downto 0);
    -- signal dout_r  : std_logic_vector(7 downto 0);

    -- -------------------------------------------------------------------------
    -- TODO 2b: Dichiara un segnale interno phi_sample_r
    --
    -- In VHDL-93 non e' consentito leggere un segnale dichiarato come porta
    -- 'out' all'interno della stessa architettura. Questo significa che non
    -- puoi scrivere:
    --
    --   phi_sample_n <= not phi_sample;  -- ERRORE in VHDL-93: phi_sample e' out
    --
    -- La soluzione standard e' introdurre un segnale interno phi_sample_r che
    -- viene scritto dal processo FSM, e assegnare entrambe le porte di uscita
    -- da esso nelle assegnazioni concorrenti (TODO 3):
    --
    --   phi_sample   <= phi_sample_r;
    --   phi_sample_n <= not phi_sample_r;
    --
    -- Nel processo FSM usa sempre phi_sample_r al posto di phi_sample.
    -- -------------------------------------------------------------------------
    -- signal phi_sample_r : std_logic;

begin

    -- -------------------------------------------------------------------------
    -- TODO 3: Assegnazioni concorrenti (fuori dal process)
    --
    -- Collega i registri interni alle porte di uscita.
    -- Ricorda di assegnare sia phi_sample che phi_sample_n da phi_sample_r
    -- (vedi TODO 2b).
    -- Per dout in ST_OUTPUT puoi usare un'uscita Mealy:
    --   dout <= dout_r(7 downto 1) & out_comp_p when state = ST_OUTPUT
    --           else dout_r;
    -- -------------------------------------------------------------------------


    -- =========================================================================
    -- TODO 4: Processo sincrono — FSM con reset asincrono
    --
    -- Struttura da seguire:
    --
    --   process(clk, rst_n)
    --   begin
    --     if rst_n = '0' then
    --       -- reset asincrono: porta tutti i segnali allo stato iniziale
    --       -- phi_sample_r <= '0';
    --       -- dac_n_r      <= (others => '1');  -- tutte le piastre a GND
    --     elsif rising_edge(clk) then
    --       eoc <= '0';  -- default: eoc deasserted ogni ciclo
    --       case state is
    --         when ST_RESET  => ...
    --         when ST_SAMPLE => ...  -- phi_sample_r <= '1'
    --                                -- dac_p_r <= (others => '0')
    --                                -- dac_n_r <= (others => '1')  <- GND
    --         when ST_CONV7  => ...  -- phi_sample_r <= '0'
    --                                -- attenzione: non leggere out_comp_p qui
    --         when ST_CONV6  => ...  -- leggi out_comp_p per bit 7, trial bit 6
    --         ...
    --         when ST_OUTPUT => ...  -- leggi out_comp_p per bit 0, eoc <= '1'
    --         when others    => state <= ST_RESET;
    --       end case;
    --     end if;
    --   end process;
    -- =========================================================================


end architecture rtl;
