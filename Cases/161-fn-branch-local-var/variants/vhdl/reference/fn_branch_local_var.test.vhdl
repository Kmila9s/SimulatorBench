library ieee;
use ieee.std_logic_1164.all;

entity fn_branch_local_var_tb is
end entity;

architecture testbench of fn_branch_local_var_tb is
    component fn_branch_local_var
        port (
            sel : in  std_logic;
            a   : in  std_logic_vector(3 downto 0);
            b   : in  std_logic_vector(3 downto 0);
            y   : out std_logic_vector(3 downto 0)
        );
    end component;

    signal sel : std_logic;
    signal a   : std_logic_vector(3 downto 0);
    signal b   : std_logic_vector(3 downto 0);
    signal y   : std_logic_vector(3 downto 0);
begin
    dut : fn_branch_local_var port map (sel, a, b, y);

    process
    begin
        sel <= '0'; a <= "0000"; b <= "0000";
        wait for 10 ns;
        a <= "1010"; b <= "0100";
        wait for 10 ns;
        sel <= '1';
        wait for 10 ns;
        a <= "1111"; b <= "1000";
        wait for 10 ns;
        sel <= '0';
        wait for 400 ns;
    end process;
end;
