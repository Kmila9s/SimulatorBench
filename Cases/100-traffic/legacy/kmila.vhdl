library ieee;
use ieee.std_logic_1164.all;

entity traffic_light_system_moore is
    port (
        clk    : in  std_logic;
        reset  : in  std_logic;
        enable : in  std_logic;
        red    : out std_logic;
        yellow : out std_logic;
        green  : out std_logic
    );
end traffic_light_system_moore;

architecture rtl of traffic_light_system_moore is
    type   state_t is (sRed, sYellow, sGreen);
    signal current_s, next_s : state_t;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            current_s <= sRed;
        elsif rising_edge(clk) then
            current_s <= next_s;
        end if;
    end process;

    process(current_s, enable)
    begin
        case current_s is
            when sRed =>
                if enable = '1' then next_s <= sYellow;
                else                 next_s <= sRed;
                end if;
                red <= '1'; yellow <= '0'; green <= '0';
            when sYellow =>
                if enable = '1' then next_s <= sGreen;
                else                 next_s <= sYellow;
                end if;
                red <= '0'; yellow <= '1'; green <= '0';
            when sGreen =>
                if enable = '1' then next_s <= sRed;
                else                 next_s <= sGreen;
                end if;
                red <= '0'; yellow <= '0'; green <= '1';
        end case;
    end process;
end rtl;
