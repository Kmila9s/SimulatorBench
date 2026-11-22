library ieee;
use ieee.std_logic_1164.all;

entity abs_1 is
    port (
        si  : in  std_logic_vector(4 downto 0);
        smo : out std_logic_vector(4 downto 0);
        se  : in  std_logic_vector(0 downto 0);
        s   : in  std_logic_vector(0 downto 0)
    );
end abs_1;

architecture rtl of abs_1 is
begin
    process(si, se, s)
    begin
        if se(0) = '1' then
            smo(0) <= si(0) xor s(0);
            smo(1) <= si(1) xor s(0);
            smo(2) <= si(2) xor s(0);
            smo(3) <= si(3) xor s(0);
            smo(4) <= si(4) xor s(0);
        else
            smo(0) <= si(0);
            smo(1) <= (not si(1)) xor (not si(0));
            smo(2) <= (not si(2)) xor ((not si(0)) and (not si(1)));
            smo(3) <= (not si(3)) xor ((not si(0)) and (not si(1)) and (not si(2)));
            smo(4) <= (not si(4)) xor ((not si(0)) and (not si(1)) and (not si(2)) and (not si(3)));
        end if;
    end process;
end rtl;
