library ieee;
use ieee.std_logic_1164.all;

-- Independent implementation: process+case mapping the minterm set
-- {0100, 0101, 0111, 1100, 1101, 1111} → '1', else '0'.
entity problem_5_2_3 is
    port (
        abcd : in  std_logic_vector(3 downto 0);
        f    : out std_logic
    );
end problem_5_2_3;

architecture rtl of problem_5_2_3 is
begin
    process(abcd)
    begin
        case abcd is
            when "0100" => f <= '1';
            when "0101" => f <= '1';
            when "0111" => f <= '1';
            when "1100" => f <= '1';
            when "1101" => f <= '1';
            when "1111" => f <= '1';
            when others => f <= '0';
        end case;
    end process;
end rtl;
