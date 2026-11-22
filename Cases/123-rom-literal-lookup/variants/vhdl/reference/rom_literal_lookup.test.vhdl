library ieee;
use ieee.std_logic_1164.all;

entity rom_literal_lookup_tb is
end entity;

architecture testbench of rom_literal_lookup_tb is
    component rom_literal_lookup
        port (
            clk : in  std_logic;
            q   : out std_logic_vector(7 downto 0)
        );
    end component;

    signal clk : std_logic := '0';
    signal q   : std_logic_vector(7 downto 0);
begin
    dut : rom_literal_lookup port map (clk, q);

    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;
end;
