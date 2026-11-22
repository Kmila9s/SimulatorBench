library ieee;
use ieee.std_logic_1164.all;

entity fn_early_return_simple_tb is
end entity;

architecture testbench of fn_early_return_simple_tb is
    component fn_early_return_simple
        port (
            sel : in  std_logic;
            a   : in  std_logic;
            b   : in  std_logic;
            y   : out std_logic
        );
    end component;

    signal sel : std_logic;
    signal a   : std_logic;
    signal b   : std_logic;
    signal y   : std_logic;
begin
    dut : fn_early_return_simple port map (sel, a, b, y);

    process
    begin
        sel <= '0'; a <= '0'; b <= '1';
        wait for 20 ns;
        sel <= '1';
        wait for 20 ns;
        sel <= '0'; a <= '1'; b <= '0';
        wait for 20 ns;
        sel <= '1';
        wait for 400 ns;
    end process;
end;
