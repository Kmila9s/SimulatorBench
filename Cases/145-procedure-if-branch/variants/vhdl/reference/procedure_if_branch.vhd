library ieee;
use ieee.std_logic_1164.all;

entity procedure_if_branch is
    port (
        q : out std_logic_vector(3 downto 0)
    );
end procedure_if_branch;

architecture rtl of procedure_if_branch is
    signal state : std_logic := '0';
begin
    q <= "1010" when state = '1' else "0101";

    process
        procedure branch_wait (
            signal s : inout std_logic
        ) is
        begin
            if s = '0' then
                wait for 20 ns;
                s <= '1';
            else
                wait for 10 ns;
                s <= '0';
            end if;
        end procedure;
    begin
        for i in 0 to 5 loop
            branch_wait(state);
        end loop;
        wait;
    end process;
end rtl;
