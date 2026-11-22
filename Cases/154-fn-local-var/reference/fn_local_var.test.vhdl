library ieee;
use ieee.std_logic_1164.all;

entity fn_local_var_tb is
end entity;

architecture testbench of fn_local_var_tb is
    component fn_local_var
        port (
            a : in  std_logic;
            b : in  std_logic;
            y : out std_logic
        );
    end component;

    signal a : std_logic;
    signal b : std_logic;
    signal y : std_logic;
begin
    dut : fn_local_var port map (a, b, y);

    process
    begin
        a <= '0'; b <= '0';
        wait for 20 ns;
        a <= '1'; b <= '0';
        wait for 20 ns;
        a <= '0'; b <= '1';
        wait for 20 ns;
        a <= '1'; b <= '1';
        wait for 400 ns;
    end process;
end;
