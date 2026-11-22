library ieee;
use ieee.std_logic_1164.all;

entity fn_case_arm_local_var_tb is
end entity;

architecture testbench of fn_case_arm_local_var_tb is
    component fn_case_arm_local_var
        port (
            sel : in  std_logic_vector(1 downto 0);
            a   : in  std_logic_vector(3 downto 0);
            b   : in  std_logic_vector(3 downto 0);
            y   : out std_logic_vector(3 downto 0)
        );
    end component;

    signal sel : std_logic_vector(1 downto 0);
    signal a   : std_logic_vector(3 downto 0);
    signal b   : std_logic_vector(3 downto 0);
    signal y   : std_logic_vector(3 downto 0);
begin
    dut : fn_case_arm_local_var port map (sel, a, b, y);

    process
    begin
        sel <= "00"; a <= "1010"; b <= "0101";
        wait for 10 ns;
        sel <= "01";
        wait for 10 ns;
        sel <= "10";
        wait for 10 ns;
        sel <= "11";
        wait for 400 ns;
    end process;
end;
