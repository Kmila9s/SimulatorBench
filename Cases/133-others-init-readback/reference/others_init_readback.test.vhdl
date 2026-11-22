library ieee;
use ieee.std_logic_1164.all;

entity others_init_readback_tb is
end entity;

architecture testbench of others_init_readback_tb is
    signal clk    : std_logic := '0';
    signal enable : std_logic := '0';
    signal q      : std_logic_vector(7 downto 0);
begin
    dut : entity work.others_init_readback(rtl) port map (
        clk    => clk,
        enable => enable,
        q      => q
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
        enable <= '0';
        wait for 100 ns;
    end process;
end;
