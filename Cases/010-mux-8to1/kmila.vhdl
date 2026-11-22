library ieee;
use ieee.std_logic_1164.all;

-- Independent implementation matching the reference's truth table. The
-- reference uses an 8-term SOP form where sel(0) ends up as the MSB of
-- the x-index (bit-reversed from the usual mux convention), so:
--   sel = "000" → x(0)   sel = "100" → x(1)
--   sel = "010" → x(2)   sel = "110" → x(3)
--   sel = "001" → x(4)   sel = "101" → x(5)
--   sel = "011" → x(6)   sel = "111" → x(7)
entity mux8x1_concurrent is
    port (
        sel : in  std_logic_vector(2 downto 0);
        x   : in  std_logic_vector(7 downto 0);
        y   : out std_logic
    );
end mux8x1_concurrent;

architecture rtl of mux8x1_concurrent is
begin
    process(sel, x)
    begin
        case sel is
            when "000" => y <= x(0);
            when "100" => y <= x(1);
            when "010" => y <= x(2);
            when "110" => y <= x(3);
            when "001" => y <= x(4);
            when "101" => y <= x(5);
            when "011" => y <= x(6);
            when "111" => y <= x(7);
            when others => y <= '0';
        end case;
    end process;
end rtl;
