library ieee;
use ieee.std_logic_1164.all;

entity proc_in_fn is
    port (
        a : in  std_logic;
        b : in  std_logic;
        y : out std_logic
    );
end proc_in_fn;

architecture rtl of proc_in_fn is
    -- Procedure called from inside a function body. The procedure writes
    -- to an out-mode variable parameter, which is bound to a caller-side
    -- function-local variable. Exercises Tier 4.3 pass-8 runtime fix:
    -- FunctionExecutor.ExecuteFunctionBody dispatches ProcedureCallStatement
    -- through pcall.ResolveBoundBodyAgainstScope(localScope) so the bound
    -- body's Operations write into the runtime's fresh Variable instances,
    -- not the parse-time snapshot. Complements pass-5's synth-side scaffold.
    procedure xor_p (src1, src2 : in  std_logic;
                     dst        : out std_logic) is
    begin
        dst := src1 xor src2;
    end xor_p;

    function invoke_xor(x : std_logic; z : std_logic) return std_logic is
        variable t : std_logic;
    begin
        xor_p(x, z, t);
        return not t;
    end invoke_xor;
begin
    y <= invoke_xor(a, b);
end rtl;
