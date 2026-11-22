library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Nat2Aik is
    port (
        n_i : in  std_logic_vector(3 downto 0);
        a_o : out std_logic_vector(3 downto 0)
    );
end Nat2Aik;

architecture rtl of Nat2Aik is
    signal plus6 : unsigned(3 downto 0);
    signal six   : unsigned(3 downto 0);
begin
    six <= "0110";
    plus6 <= unsigned(n_i) + six;

    process(n_i, plus6)
    begin
        if unsigned(n_i) < 5 then
            a_o <= n_i;
        else
            a_o <= std_logic_vector(plus6);
        end if;
    end process;
end rtl;
