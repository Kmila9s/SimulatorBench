library ieee;
use ieee.std_logic_1164.all;

entity two_stage_top_tb is
end entity;

architecture testbench of two_stage_top_tb is
    signal clk   : std_logic := '0';
    signal n_rst : std_logic := '0';
    signal cout  : std_logic_vector(7 downto 0);
begin
    dut : entity work.two_stage_top(rtl) port map (
        clk   => clk,
        n_rst => n_rst,
        cout  => cout
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
        n_rst <= '0';
        wait for 10 ns;
        n_rst <= '1';
        wait for 500 ns;
    end process;
end;
