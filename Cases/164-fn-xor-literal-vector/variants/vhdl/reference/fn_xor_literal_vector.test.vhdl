library ieee;
use ieee.std_logic_1164.all;

entity fn_xor_literal_vector_tb is
end entity;

architecture testbench of fn_xor_literal_vector_tb is
    component fn_xor_literal_vector
        port (
            a : in  std_logic_vector(3 downto 0);
            y : out std_logic_vector(3 downto 0)
        );
    end component;

    signal a : std_logic_vector(3 downto 0);
    signal y : std_logic_vector(3 downto 0);
begin
    dut : fn_xor_literal_vector port map (a, y);

    process
    begin
        a <= "0000";
        wait for 10 ns;
        a <= "1010";
        wait for 10 ns;
        a <= "1111";
        wait for 400 ns;
    end process;
end;
