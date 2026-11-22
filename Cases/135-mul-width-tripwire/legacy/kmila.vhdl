library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Multiply-width tripwire.
--
-- `unsigned(4..0) * unsigned(4..0)` is a 10-bit product (numeric_std
-- `leftW + rightW`). The product is then `std_logic_vector(...)`-cast to
-- 9 bits, exercising the LHS-side truncation that the host language
-- performs implicitly via the slice expression `prod(8 downto 0)`.
-- If Kmila ever drops back to narrow-multiply (5+5 -> 5) the case fails
-- because 12 * 11 = 132 = "010000100" loses the MSB.

entity mul_width_tripwire is
    port (
        a   : in  std_logic_vector(4 downto 0);
        b   : in  std_logic_vector(4 downto 0);
        out9: out std_logic_vector(8 downto 0)
    );
end mul_width_tripwire;

architecture rtl of mul_width_tripwire is
    signal prod : unsigned(9 downto 0);
begin
    prod <= unsigned(a) * unsigned(b);
    out9 <= std_logic_vector(prod(8 downto 0));
end rtl;
