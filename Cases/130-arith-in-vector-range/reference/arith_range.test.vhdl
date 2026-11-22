library ieee;
use ieee.std_logic_1164.all;

entity arith_range_tb is
end entity;

architecture testbench of arith_range_tb is
    component arith_range
        port (
            clk  : in  std_logic;
            data : out std_logic_vector(7 downto 0)
        );
    end component;

    signal clk  : std_logic := '0';
    signal data : std_logic_vector(7 downto 0);
begin
    dut : arith_range port map (clk, data);

    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;
end;
