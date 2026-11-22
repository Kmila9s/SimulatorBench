library ieee;
use ieee.std_logic_1164.all;

entity unsigned_slice_assign_tb is
end entity;

architecture testbench of unsigned_slice_assign_tb is
    component unsigned_slice_assign
        port (
            clk  : in  std_logic;
            word : in  std_logic_vector(23 downto 0);
            go   : in  std_logic;
            data : out std_logic_vector(7 downto 0)
        );
    end component;

    signal clk  : std_logic := '0';
    signal word : std_logic_vector(23 downto 0) := "000000000000000000000011";
    signal go   : std_logic := '0';
    signal data : std_logic_vector(7 downto 0);
begin
    dut : unsigned_slice_assign port map (clk, word, go, data);

    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        go <= '0';
        wait for 15 ns;
        go <= '1';
        wait for 500 ns;
    end process;
end;
