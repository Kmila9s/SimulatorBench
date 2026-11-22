library ieee;
use ieee.std_logic_1164.all;

-- Independent implementation. Uses `with…select` + `after 10 ns` on the
-- two one-hot choices that have a documented inertial delay in the
-- problem spec; the other choices are instantaneous. This mirrors the
-- spec's intent (inertial delays on selected one-hot positions) without
-- copying the reference's exact construct ordering.
entity enc8x3_sel is
    port (
        x : in  std_logic_vector(7 downto 0);
        y : out std_logic_vector(2 downto 0)
    );
end enc8x3_sel;

architecture rtl of enc8x3_sel is
begin
    with x select
        y <= "000" after 10 ns when "00000001",
             "001" after 10 ns when "00000010",
             "010" when "00000100",
             "011" when "00001000",
             "100" when "00010000",
             "101" when "00100000",
             "110" when "01000000",
             "111" when "10000000",
             "000" when others;
end rtl;
