library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity semaforo_tb is
end entity semaforo_tb;

architecture sim of semaforo_tb is

    constant CLK_PERIOD : time := 10 ns;

    signal clk    : std_logic := '0';
    signal rst_n  : std_logic := '0';
    signal rosso  : std_logic;
    signal verde  : std_logic;
    signal giallo : std_logic;

begin

    DUT: entity work.semaforo
        port map (
            clk    => clk,
            rst_n  => rst_n,
            rosso  => rosso,
            verde  => verde,
            giallo => giallo
        );

    clk <= not clk after CLK_PERIOD / 2;

    stimoli: process
    begin
        rst_n <= '0';
        wait for CLK_PERIOD * 3;
        rst_n <= '1';
        wait for CLK_PERIOD * 10;
        report "Simulazione completata." severity NOTE;
        wait;
    end process;

end architecture sim;
