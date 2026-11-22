library ieee;
use ieee.std_logic_1164.all;

entity fn_local_var is
    port (
        a : in  std_logic;
        b : in  std_logic;
        y : out std_logic
    );
end fn_local_var;

architecture rtl of fn_local_var is
    -- Function body with a local variable write followed by a return that
    -- reads the local. Exercises Tier 4.3 pass-4 item A: the synth-time
    -- inliner registers the local write as a scope-alias so the return
    -- picks up the AND net rather than a black-box constant.
    function nand2(x : std_logic; z : std_logic) return std_logic is
        variable v : std_logic;
    begin
        v := x and z;
        return not v;
    end nand2;
begin
    y <= nand2(a, b);
end rtl;
