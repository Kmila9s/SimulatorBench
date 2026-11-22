library ieee;
use ieee.std_logic_1164.all;

entity enum_eq_conditional_tb is
end entity;

architecture testbench of enum_eq_conditional_tb is
    component enum_eq_conditional
        port (
            clk  : in  std_logic;
            go   : in  std_logic;
            flag : out std_logic
        );
    end component;

    signal clk  : std_logic := '0';
    signal go   : std_logic := '0';
    signal flag : std_logic;
begin
    dut : enum_eq_conditional port map (clk, go, flag);

    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        go <= '0';
        wait for 15 ns;
        go <= '1';
        wait for 500 ns;
    end process;
end;
