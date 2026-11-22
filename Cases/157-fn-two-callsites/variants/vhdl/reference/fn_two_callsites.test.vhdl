library ieee;
use ieee.std_logic_1164.all;

entity fn_two_callsites_tb is
end entity;

architecture testbench of fn_two_callsites_tb is
    component fn_two_callsites
        port (
            a  : in  std_logic;
            b  : in  std_logic;
            y1 : out std_logic;
            y2 : out std_logic
        );
    end component;

    signal a  : std_logic;
    signal b  : std_logic;
    signal y1 : std_logic;
    signal y2 : std_logic;
begin
    dut : fn_two_callsites port map (a, b, y1, y2);

    process
    begin
        a <= '0'; b <= '0';
        wait for 20 ns;
        a <= '1'; b <= '0';
        wait for 20 ns;
        a <= '0'; b <= '1';
        wait for 20 ns;
        a <= '1'; b <= '1';
        wait for 400 ns;
    end process;
end;
