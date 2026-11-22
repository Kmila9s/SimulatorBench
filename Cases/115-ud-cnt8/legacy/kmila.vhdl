library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity experiment_2_3 is
    port (
        CLK         : in  std_logic;
        ENABLE      : in  std_logic;
        UP_DOWN     : in  std_logic;
        COUNTER_OUT : out std_logic_vector(7 downto 0)
    );
end experiment_2_3;

architecture rtl of experiment_2_3 is
    signal q : std_logic_vector(7 downto 0) := "00000000";
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if ENABLE = '1' then
                if UP_DOWN = '1' then
                    q <= q + 1;
                else
                    q <= q - 1;
                end if;
            end if;
        end if;
    end process;

    COUNTER_OUT <= q;
end rtl;
