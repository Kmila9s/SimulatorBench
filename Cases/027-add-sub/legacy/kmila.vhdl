library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Independent implementation: separates the two arithmetic forms behind a
-- process+if so we don't depend on the conditional-concurrent path inside
-- numeric_std slice/cast (which surfaced bug #12 earlier in 021-adder).
entity adder_subtractor is
    port (
        a, b : in  std_logic_vector(7 downto 0);
        cin  : in  std_logic_vector(0 downto 0);
        add  : in  std_logic;
        o    : out std_logic_vector(7 downto 0);
        cout : out std_logic_vector(0 downto 0)
    );
end adder_subtractor;

architecture rtl of adder_subtractor is
    signal sum9   : unsigned(8 downto 0);
    signal sum9sv : std_logic_vector(8 downto 0);
begin
    process(a, b, cin, add)
    begin
        if add = '1' then
            sum9 <= resize(unsigned(a), 9) + resize(unsigned(b), 9) + resize(unsigned(cin), 9);
        else
            sum9 <= resize(unsigned(a), 9) - resize(unsigned(b), 9) - resize(unsigned(cin), 9);
        end if;
    end process;

    sum9sv  <= std_logic_vector(sum9);
    o(7)    <= sum9sv(7);
    o(6)    <= sum9sv(6);
    o(5)    <= sum9sv(5);
    o(4)    <= sum9sv(4);
    o(3)    <= sum9sv(3);
    o(2)    <= sum9sv(2);
    o(1)    <= sum9sv(1);
    o(0)    <= sum9sv(0);
    cout(0) <= sum9sv(8);
end rtl;
