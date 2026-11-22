library ieee;
use ieee.std_logic_1164.all;

-- 2026-07-20 — regression fence for the user-fn reactivity gap
-- (memory `project_user_fn_reactivity_gap`). Pre-fix, the interpreter
-- baked the return value of a user-declared function into a static
-- Variable at parse time; subsequent process re-fires kept re-pushing
-- that frozen value. Symptom: an LFSR routed through a `function`
-- would transition ONCE (init → first step) and then stay frozen.
-- Fix (Interpreter/Models/DeferredUserFunction.cs): wrap user-fn
-- calls at parse time; Evaluate() re-parses arg expressions against
-- the live scope and re-runs FunctionExecutor on each fire.
--
-- Same LFSR shape as case 029-lfsr but routed through step_r() —
-- if the fix regresses, this case would freeze at 00000010 (the
-- first step from init 00000001) instead of cycling.
entity lfsr_fn is
    port (
        rst : in  std_logic;
        clk : in  std_logic;
        q   : out std_logic_vector(7 downto 0)
    );
end lfsr_fn;

architecture rtl of lfsr_fn is
    signal state : std_logic_vector(7 downto 0) := "00000001";

    function step(v : std_logic_vector(7 downto 0))
        return std_logic_vector is
    begin
        return v(6 downto 0) & (v(7) xor v(5) xor v(4) xor v(3));
    end function;
begin
    q <= state;
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '0' then
                state <= "00000001";
            else
                state <= step(state);
            end if;
        end if;
    end process;
end rtl;
