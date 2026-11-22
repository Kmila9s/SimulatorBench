library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Independent implementation. Computes sum into a 9-bit signal and slices
-- it into o (low 8 bits) and cout (bit 8) using separate signal
-- assignments rather than a nested slice inside the type cast.
entity adder is
    port (
        a, b : in  std_logic_vector(7 downto 0);
        cin  : in  std_logic_vector(0 downto 0);
        o    : out std_logic_vector(7 downto 0);
        cout : out std_logic_vector(0 downto 0)
    );
end adder;

architecture rtl of adder is
    signal sum9    : unsigned(8 downto 0);
    signal sum9sv  : std_logic_vector(8 downto 0);
begin
    sum9   <= resize(unsigned(a), 9) + resize(unsigned(b), 9) + resize(unsigned(cin), 9);
    sum9sv <= std_logic_vector(sum9);
    o(7)   <= sum9sv(7);
    o(6)   <= sum9sv(6);
    o(5)   <= sum9sv(5);
    o(4)   <= sum9sv(4);
    o(3)   <= sum9sv(3);
    o(2)   <= sum9sv(2);
    o(1)   <= sum9sv(1);
    o(0)   <= sum9sv(0);
    cout(0) <= sum9sv(8);
end rtl;
