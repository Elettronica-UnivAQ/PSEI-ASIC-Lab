library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- =============================================================================
-- Semaforo -- FSM Moore a 3 stati (senza contatore)
-- =============================================================================
-- Ogni stato dura esattamente 1 ciclo di clock.
-- Design intenzionalmente semplice per mostrare make rtl / make fsm.
-- Nota ASIC: nessuna inizializzazione sui segnali.
-- =============================================================================

entity semaforo is
    port (
        clk    : in  std_logic;
        rst_n  : in  std_logic;
        rosso  : out std_logic;
        verde  : out std_logic;
        giallo : out std_logic
    );
end entity semaforo;

architecture rtl of semaforo is

    type state_t is (ST_ROSSO, ST_VERDE, ST_GIALLO);
    signal state : state_t;

begin

    process(clk, rst_n)
    begin
        if rst_n = '0' then
            state <= ST_ROSSO;
        elsif rising_edge(clk) then
            case state is
                when ST_ROSSO  => state <= ST_VERDE;
                when ST_VERDE  => state <= ST_GIALLO;
                when ST_GIALLO => state <= ST_ROSSO;
                when others    => state <= ST_ROSSO;
            end case;
        end if;
    end process;

    rosso  <= '1' when state = ST_ROSSO  else '0';
    verde  <= '1' when state = ST_VERDE  else '0';
    giallo <= '1' when state = ST_GIALLO else '0';

end architecture rtl;
