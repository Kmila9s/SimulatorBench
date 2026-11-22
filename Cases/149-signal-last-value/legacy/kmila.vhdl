library ieee;
use ieee.std_logic_1164.all;

entity last_value_write is
    port (
        clk    : in  std_logic;
        d      : in  std_logic;
        q      : out std_logic;
        q_prev : out std_logic
    );
end last_value_write;

architecture rtl of last_value_write is
    signal d_reg : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            d_reg  <= d;
            q      <= d_reg;
            q_prev <= d_reg'last_value;
        end if;
    end process;
end rtl;
