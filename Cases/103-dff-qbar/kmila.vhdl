library ieee;
use ieee.std_logic_1164.all;

entity d_ff is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        d     : in  std_logic;
        q     : out std_logic;
        q_bar : out std_logic
    );
end d_ff;

architecture rtl of d_ff is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                q     <= '0';
                q_bar <= '1';
            else
                q     <= d;
                q_bar <= not d;
            end if;
        end if;
    end process;
end rtl;
