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
