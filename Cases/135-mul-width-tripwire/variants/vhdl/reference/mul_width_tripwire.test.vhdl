library ieee;
use ieee.std_logic_1164.all;

entity mul_width_tripwire_tb is
end entity;

architecture testbench of mul_width_tripwire_tb is
    signal a    : std_logic_vector(4 downto 0) := "01100";  -- 12
    signal b    : std_logic_vector(4 downto 0) := "01011";  -- 11
    signal out9 : std_logic_vector(8 downto 0);
begin
    dut : entity work.mul_width_tripwire(rtl) port map (
        a    => a,
        b    => b,
        out9 => out9
    );

    process
    begin
        wait for 100 ns;
    end process;
end;
