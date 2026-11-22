library ieee;
use ieee.std_logic_1164.all;

entity multi_hop_pure_tb is
end entity;

architecture testbench of multi_hop_pure_tb is
    component multi_hop_pure
        port (
            clk   : in  std_logic;
            n_rst : in  std_logic;
            y     : out std_logic_vector(7 downto 0)
        );
    end component;

    signal clk   : std_logic := '0';
    signal n_rst : std_logic := '0';
    signal y     : std_logic_vector(7 downto 0);
begin
    dut : multi_hop_pure port map (clk, n_rst, y);

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
        wait for 12 ns;
        n_rst <= '1';
        wait for 500 ns;
    end process;
end;
