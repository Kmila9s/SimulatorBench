library ieee;
use ieee.std_logic_1164.all;

entity flip_flop is
    port (
        d   : in  std_logic;
        clk : in  std_logic;
        ce  : in  std_logic;
        rst : in  std_logic;
        q   : out std_logic
    );
end flip_flop;

architecture rtl of flip_flop is
    signal state : std_logic := '0';
begin
    q <= state;
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '0' then
                state <= '0';
            elsif ce = '1' then
                state <= d;
            end if;
        end if;
    end process;
end rtl;
