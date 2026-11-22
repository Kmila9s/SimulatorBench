library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- 4-bit signed comparator. Independent implementation: case-split on the
-- MSB (sign) and use unsigned comparison for same-sign pairs (which gives
-- the correct signed direction inside each quadrant of two's complement).
entity CompEntN is
    port (
        a_i   : in  std_logic_vector(3 downto 0);
        b_i   : in  std_logic_vector(3 downto 0);
        may_o : out std_logic;
        men_o : out std_logic;
        igu_o : out std_logic
    );
end CompEntN;

architecture rtl of CompEntN is
begin
    process(a_i, b_i)
    begin
        may_o <= '0';
        men_o <= '0';
        igu_o <= '0';

        if a_i = b_i then
            igu_o <= '1';
        elsif a_i(3) = '0' and b_i(3) = '1' then
            -- a non-negative, b negative
            may_o <= '1';
        elsif a_i(3) = '1' and b_i(3) = '0' then
            -- a negative, b non-negative
            men_o <= '1';
        else
            -- Same sign: unsigned compare matches signed direction
            if a_i > b_i then
                may_o <= '1';
            else
                men_o <= '1';
            end if;
        end if;
    end process;
end rtl;
