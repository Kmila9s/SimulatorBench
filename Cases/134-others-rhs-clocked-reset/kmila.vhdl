library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity others_rhs_clocked_reset is
    port (
        clk   : in  std_logic;
        rst   : in  std_logic;
        d     : in  std_logic_vector(7 downto 0);
        q     : out std_logic_vector(7 downto 0)
    );
end others_rhs_clocked_reset;

architecture rtl of others_rhs_clocked_reset is
    signal r : std_logic_vector(7 downto 0) := "10101010";
begin
    process(clk, rst)
    begin
        if rst = '1' then
            r <= (others => '0');
        elsif rising_edge(clk) then
            r <= d;
        end if;
    end process;

    q <= r;
end rtl;
