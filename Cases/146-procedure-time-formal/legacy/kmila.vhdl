library ieee;
use ieee.std_logic_1164.all;

-- 2026-07-23 — regression fence for `type time` as a procedure formal
-- (Session 27 follow-up). Case 144 had to simplify away the
-- `constant delay_ns : in time` formal because a null-Variable check
-- inside `ProcedureCallStatement.ResolveBoundBody` used `!= null`
-- against a Variable that has an overloaded `operator ==` comparing
-- Names — so a literal actual (no caller-scope match) triggered a
-- silent NRE and short-circuited every subsequent procedure call.
-- Fix: `is not null` at the reference check. This case exercises the
-- shape 144 originally wanted: signal + constant formal, with the
-- constant used as the wait delay inside the procedure body.
entity procedure_time_formal is
    port (
        q : out std_logic_vector(3 downto 0)
    );
end procedure_time_formal;

architecture rtl of procedure_time_formal is
    signal state : std_logic := '0';
begin
    q <= "1010" when state = '1' else "0101";

    process
        procedure step_state (
            signal s : inout std_logic;
            constant delay_ns : in time
        ) is
        begin
            wait for delay_ns;
            if s = '0' then
                s <= '1';
            else
                s <= '0';
            end if;
        end procedure;
    begin
        for i in 0 to 5 loop
            step_state(state, 20 ns);
        end loop;
        wait;
    end process;
end rtl;
