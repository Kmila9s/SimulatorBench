library ieee;
use ieee.std_logic_1164.all;

-- Independent implementation using process+case to map the minterm set
-- {0001, 0011, 1001, 1011} → '1', others → '0'. Same Boolean truth table
-- as the reference, different syntactic form.
entity problem_5_2_1 is
    port (
        abcd : in  std_logic_vector(3 downto 0);
        f    : out std_logic
    );
end problem_5_2_1;

architecture rtl of problem_5_2_1 is
begin
    process(abcd)
    begin
        case abcd is
            when "0001" => f <= '1';
            when "0011" => f <= '1';
            when "1001" => f <= '1';
            when "1011" => f <= '1';
            when others => f <= '0';
        end case;
    end process;
end rtl;
