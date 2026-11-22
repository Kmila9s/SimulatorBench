-- PLACEHOLDER testbench for harness smoke test only.
-- Not from a public source. Do NOT count toward bench accuracy.
library ieee;
use ieee.std_logic_1164.all;

entity and_gate_tb is
end and_gate_tb;

architecture sim of and_gate_tb is
    signal a, b, y : std_logic := '0';
begin
    dut: entity work.and_gate port map (a => a, b => b, y => y);

    stim: process
    begin
        a <= '0'; b <= '0';
        wait for 30 ns;
        a <= '1';
        wait for 30 ns;
        b <= '1';
        wait for 60 ns;
        a <= '0';
        wait for 30 ns;
        b <= '0';
        wait for 50 ns;
        wait;
    end process;
end sim;
