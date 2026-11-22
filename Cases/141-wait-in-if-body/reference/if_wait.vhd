library ieee;
use ieee.std_logic_1164.all;

entity if_wait is
    port (
        q : out std_logic_vector(3 downto 0)
    );
end if_wait;

architecture rtl of if_wait is
    signal state : std_logic := '0';
begin
    q <= "1010" when state = '1' else "0101";

    process
    begin
        for i in 0 to 5 loop
            if state = '0' then
                wait for 20 ns;
                state <= '1';
            else
                wait for 10 ns;
                state <= '0';
            end if;
        end loop;
        wait;
    end process;
end rtl;
