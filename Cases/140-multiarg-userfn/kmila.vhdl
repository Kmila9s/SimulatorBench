library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 2026-07-20 — sibling of 139-lfsr-through-fn, exercises the same
-- DeferredUserFunction wrapper for user functions with TWO arguments.
-- Mirrors the capstone_calc `q_mul(a, b)` / `q_div(a, b)` pattern
-- (`fixed_point.vhd`) whose reactivity gap was the blocker for Ring 5
-- cases A3 (MUL), A4 (DIV), A5 (POW), A7 (LN). Fix from the same
-- session closes those simultaneously.
--
-- 4-bit "accumulator + step" — each rising edge computes
-- state <= step_add(state, delta) where step_add is a user-defined
-- 2-arg function. Pre-user-fn-fix the function baked its FIRST-fire
-- result and re-emitted it every subsequent fire; post-fix the args
-- are re-parsed against the live signal state per fire.
entity multiarg_fn is
    port (
        rst : in  std_logic;
        clk : in  std_logic;
        q   : out std_logic_vector(3 downto 0)
    );
end multiarg_fn;

architecture rtl of multiarg_fn is
    signal state : std_logic_vector(3 downto 0) := "0000";
    signal delta : std_logic_vector(3 downto 0) := "0011";

    function step_add(a : std_logic_vector(3 downto 0);
                      b : std_logic_vector(3 downto 0))
        return std_logic_vector is
    begin
        return std_logic_vector(unsigned(a) + unsigned(b));
    end function;
begin
    q <= state;
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '0' then
                state <= "0000";
            else
                state <= step_add(state, delta);
            end if;
        end if;
    end process;
end rtl;
