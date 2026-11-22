library ieee;
use ieee.std_logic_1164.all;

entity procedure_wait is
    port (
        q : out std_logic_vector(3 downto 0)
    );
end procedure_wait;

architecture rtl of procedure_wait is
    signal state : std_logic := '0';
begin
    q <= "1010" when state = '1' else "0101";

    process
        procedure toggle_after (signal s : inout std_logic) is
        begin
            wait for 20 ns;
            if s = '0' then
                s <= '1';
            else
                s <= '0';
            end if;
        end procedure;
    begin
        for i in 0 to 5 loop
            toggle_after(state);
        end loop;
        wait;
    end process;
end rtl;
