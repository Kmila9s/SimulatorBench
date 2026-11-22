library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Tripwire for function-body caller-scope binding.
--
-- `sub` declares an architecture-scope signal `k_sig` driven from input
-- port `kin`, and a function `add_off` that reads that signal directly
-- from its caller scope. Two instances of `sub` are inlined in top with
-- different `kin` values (3 and 7), so each instance has its own
-- `k_sig` after elaborator renaming (U_u1__k_sig vs U_u2__k_sig).
--
-- If the function-body cache binds Operations to the FIRST instance's
-- `k_sig` Variable and reuses them for the second instance (the
-- stale-binding bug from handoff §6 item 6), both outputs would read
-- the same k_sig.
--
-- Stimulus: a1=5,kin1=3; a2=10,kin2=7. Expected: o1=8, o2=17.

entity sub is
    port (
        a    : in  std_logic_vector(7 downto 0);
        kin  : in  std_logic_vector(3 downto 0);
        out8 : out std_logic_vector(7 downto 0)
    );
end sub;

architecture rtl of sub is
    signal k_sig : std_logic_vector(3 downto 0);
    function add_off(x : std_logic_vector(7 downto 0))
        return std_logic_vector is
    begin
        return std_logic_vector(unsigned(x) + unsigned("0000" & k_sig));
    end function;
begin
    k_sig <= kin;
    out8 <= add_off(a);
end rtl;

library ieee;
use ieee.std_logic_1164.all;

entity multi_caller_top is
    port (
        a1, a2 : in  std_logic_vector(7 downto 0);
        kin1   : in  std_logic_vector(3 downto 0);
        kin2   : in  std_logic_vector(3 downto 0);
        o1, o2 : out std_logic_vector(7 downto 0)
    );
end multi_caller_top;

architecture rtl of multi_caller_top is
begin
    u1 : entity work.sub(rtl)
        port map (a => a1, kin => kin1, out8 => o1);

    u2 : entity work.sub(rtl)
        port map (a => a2, kin => kin2, out8 => o2);
end rtl;
