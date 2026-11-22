library ieee;
use ieee.std_logic_1164.all;

entity last_value_write_tb is
end entity;

architecture testbench of last_value_write_tb is
    component last_value_write
        port (
            clk    : in  std_logic;
            d      : in  std_logic;
            q      : out std_logic;
            q_prev : out std_logic
        );
    end component;

    signal clk    : std_logic;
    signal d      : std_logic;
    signal q      : std_logic;
    signal q_prev : std_logic;
begin
    dut : last_value_write port map (clk, d, q, q_prev);

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
        wait for 12 ns;
        d <= '1';
        wait for 20 ns;
        d <= '0';
        wait for 20 ns;
        d <= '1';
        wait for 200 ns;
    end process;
end;
