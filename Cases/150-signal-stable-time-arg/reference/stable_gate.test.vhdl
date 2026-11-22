library ieee;
use ieee.std_logic_1164.all;

entity stable_gate_tb is
end entity;

architecture testbench of stable_gate_tb is
    component stable_gate
        port (
            clk        : in  std_logic;
            data       : in  std_logic;
            stable_out : out std_logic
        );
    end component;

    signal clk        : std_logic;
    signal data       : std_logic;
    signal stable_out : std_logic;
begin
    dut : stable_gate port map (clk, data, stable_out);

    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        data <= '0';
        wait for 40 ns;
        data <= '1';
        wait for 15 ns;
        data <= '0';
        wait for 50 ns;
        data <= '1';
        wait for 200 ns;
    end process;
end;
