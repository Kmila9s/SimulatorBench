library ieee;
use ieee.std_logic_1164.all;

entity case_matching_tb is
end entity;

architecture testbench of case_matching_tb is
    component case_matching
        port (
            clk : in  std_logic;
            op  : in  std_logic_vector(3 downto 0);
            y   : out std_logic_vector(1 downto 0)
        );
    end component;

    signal clk : std_logic := '0';
    signal op  : std_logic_vector(3 downto 0) := "0000";
    signal y   : std_logic_vector(1 downto 0);
begin
    dut : case_matching port map (clk, op, y);

    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        op <= "1010"; wait for 40 ns;   -- matches "10--" → y=01
        op <= "0101"; wait for 40 ns;   -- matches "0-01" → y=10
        op <= "1111"; wait for 40 ns;   -- matches "1111" → y=11
        op <= "0000"; wait for 200 ns;  -- others → y=00
    end process;
end;
