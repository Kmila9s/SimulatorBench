library ieee;
use ieee.std_logic_1164.all;

entity fn_two_callsites is
    port (
        a  : in  std_logic;
        b  : in  std_logic;
        y1 : out std_logic;
        y2 : out std_logic
    );
end fn_two_callsites;

architecture rtl of fn_two_callsites is
    -- Same user function invoked from two concurrent-assign sites.
    -- Regression fence for Tier 4.3 pass-13: verifies that both callsites
    -- compute independently against their own arguments (a for y1, b for y2).
    -- Runtime path shares function.CachedScope across the two calls;
    -- RefreshScopeArgs rebinds parameter values in-place before each body
    -- execution, and DeltaCycleEngine runs Operations serially within a
    -- delta cycle — so the two writes don't cross-contaminate.
    function invert(x : std_logic) return std_logic is
    begin
        return not x;
    end invert;
begin
    y1 <= invert(a);
    y2 <= invert(b);
end rtl;
