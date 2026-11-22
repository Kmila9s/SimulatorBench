library ieee;
use ieee.std_logic_1164.all;

entity rom_array_lookup_tb is
end entity;

architecture testbench of rom_array_lookup_tb is
    component rom_array_lookup
        port (
            clk  : in  std_logic;
            addr : in  std_logic_vector(2 downto 0);
            data : out std_logic_vector(7 downto 0)
        );
    end component;

    signal clk  : std_logic := '0';
    signal addr : std_logic_vector(2 downto 0) := "000";
    signal data : std_logic_vector(7 downto 0);
begin
    dut : rom_array_lookup port map (clk, addr, data);

    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        addr <= "000";
        wait for 20 ns;
        addr <= "011";
        wait for 20 ns;
        addr <= "111";
        wait for 20 ns;
        addr <= "100";
        wait for 200 ns;
    end process;
end;
