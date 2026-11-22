library ieee;
use ieee.std_logic_1164.all;

entity case_slice_selector_tb is
end entity;

architecture testbench of case_slice_selector_tb is
    component case_slice_selector
        port (
            clk     : in  std_logic;
            word    : in  std_logic_vector(23 downto 0);
            out_reg : out std_logic_vector(7 downto 0)
        );
    end component;

    signal clk     : std_logic := '0';
    signal word    : std_logic_vector(23 downto 0) := (others => '0');
    signal out_reg : std_logic_vector(7 downto 0);
begin
    dut : case_slice_selector port map (clk, word, out_reg);

    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        word <= "000010110000000000000000"; wait for 20 ns;
        word <= "000001110000000000000000"; wait for 20 ns;
        word <= "000011000000000000000000"; wait for 20 ns;
        word <= "000011110000000000000000"; wait for 200 ns;
    end process;
end;
