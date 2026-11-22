library ieee;
use ieee.std_logic_1164.all;

entity fn_for_loop_count_ones_tb is
end entity;

architecture testbench of fn_for_loop_count_ones_tb is
    component fn_for_loop_count_ones
        port (
            a : in  std_logic_vector(3 downto 0);
            b : in  std_logic_vector(3 downto 0);
            y : out std_logic_vector(3 downto 0)
        );
    end component;

    signal a : std_logic_vector(3 downto 0);
    signal b : std_logic_vector(3 downto 0);
    signal y : std_logic_vector(3 downto 0);
begin
    dut : fn_for_loop_count_ones port map (a, b, y);

    process
    begin
        a <= "0000"; b <= "0000";
        wait for 10 ns;
        a <= "1010"; b <= "0011";
        wait for 10 ns;
        a <= "1111"; b <= "0110";
        wait for 400 ns;
    end process;
end;
