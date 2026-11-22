library ieee;
use ieee.std_logic_1164.all;

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
