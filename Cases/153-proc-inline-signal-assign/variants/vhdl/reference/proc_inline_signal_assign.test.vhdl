library ieee;
use ieee.std_logic_1164.all;

entity proc_inline_signal_assign_tb is
end entity;

architecture testbench of proc_inline_signal_assign_tb is
    component proc_inline_signal_assign
        port (
            clk : in  std_logic;
            d   : in  std_logic;
            q   : out std_logic
        );
    end component;

    signal clk : std_logic;
    signal d   : std_logic;
    signal q   : std_logic;
begin
    dut : proc_inline_signal_assign port map (clk, d, q);

    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        d <= '0';
        wait for 15 ns;
        d <= '1';
        wait for 30 ns;
        d <= '0';
        wait for 20 ns;
        d <= '1';
        wait for 400 ns;
    end process;
end;
