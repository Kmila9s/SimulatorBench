library ieee;
use ieee.std_logic_1164.all;

entity multi_caller_top_tb is
end entity;

architecture testbench of multi_caller_top_tb is
    signal a1   : std_logic_vector(7 downto 0) := "00000101"; -- 5
    signal a2   : std_logic_vector(7 downto 0) := "00001010"; -- 10
    signal kin1 : std_logic_vector(3 downto 0) := "0011";     -- 3
    signal kin2 : std_logic_vector(3 downto 0) := "0111";     -- 7
    signal o1   : std_logic_vector(7 downto 0);
    signal o2   : std_logic_vector(7 downto 0);
begin
    dut : entity work.multi_caller_top(rtl) port map (
        a1 => a1, a2 => a2,
        kin1 => kin1, kin2 => kin2,
        o1 => o1, o2 => o2
    );

    process
    begin
        wait for 80 ns;
    end process;
end;
