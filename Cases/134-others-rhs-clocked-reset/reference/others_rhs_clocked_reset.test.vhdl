library ieee;
use ieee.std_logic_1164.all;

entity others_rhs_clocked_reset_tb is
end entity;

architecture testbench of others_rhs_clocked_reset_tb is
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal d   : std_logic_vector(7 downto 0) := "11110000";
    signal q   : std_logic_vector(7 downto 0);
begin
    dut : entity work.others_rhs_clocked_reset(rtl) port map (
        clk => clk,
        rst => rst,
        d   => d,
        q   => q
    );

    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        rst <= '1';
        wait for 30 ns;
        rst <= '0';
        wait for 200 ns;
    end process;
end;
