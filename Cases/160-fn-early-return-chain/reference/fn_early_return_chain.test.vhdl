library ieee;
use ieee.std_logic_1164.all;

entity fn_early_return_chain_tb is
end entity;

architecture testbench of fn_early_return_chain_tb is
    component fn_early_return_chain
        port (
            r0 : in  std_logic;
            r1 : in  std_logic;
            r2 : in  std_logic;
            y  : out std_logic_vector(1 downto 0)
        );
    end component;

    signal r0 : std_logic;
    signal r1 : std_logic;
    signal r2 : std_logic;
    signal y  : std_logic_vector(1 downto 0);
begin
    dut : fn_early_return_chain port map (r0, r1, r2, y);

    process
    begin
        r0 <= '0'; r1 <= '0'; r2 <= '0';
        wait for 10 ns;
        r2 <= '1';
        wait for 10 ns;
        r1 <= '1';
        wait for 10 ns;
        r0 <= '1';
        wait for 10 ns;
        r0 <= '0'; r1 <= '0'; r2 <= '0';
        wait for 400 ns;
    end process;
end;
