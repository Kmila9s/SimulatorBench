library ieee;
use ieee.std_logic_1164.all;

-- Independent implementation: gate-level ripple-carry adder. Each carry
-- comes from `c = (a AND b) OR (cin AND (a XOR b))`. Overflow `v` is the
-- standard signed-overflow detect = XOR of the carry into the sign bit
-- and the carry out of the sign bit.
entity adder4 is
    port (
        a, b    : in  std_logic_vector(3 downto 0);
        cin     : in  std_logic;
        s       : out std_logic_vector(3 downto 0);
        v, cout : out std_logic
    );
end adder4;

architecture rtl of adder4 is
    signal c0, c1, c2, c3 : std_logic;
begin
    -- bit 0
    s(0) <= a(0) xor b(0) xor cin;
    c0   <= (a(0) and b(0)) or (cin and (a(0) xor b(0)));
    -- bit 1
    s(1) <= a(1) xor b(1) xor c0;
    c1   <= (a(1) and b(1)) or (c0  and (a(1) xor b(1)));
    -- bit 2
    s(2) <= a(2) xor b(2) xor c1;
    c2   <= (a(2) and b(2)) or (c1  and (a(2) xor b(2)));
    -- bit 3 (sign)
    s(3) <= a(3) xor b(3) xor c2;
    c3   <= (a(3) and b(3)) or (c2  and (a(3) xor b(3)));

    cout <= c3;
    -- overflow = carry into MSB XOR carry out of MSB
    v    <= c2 xor c3;
end rtl;
