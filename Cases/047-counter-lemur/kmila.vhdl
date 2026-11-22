library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter is
    port (
        clk    : in  std_logic;
        res_as : in  std_logic;
        up     : in  std_logic;
        count  : out std_logic_vector(3 downto 0)
    );
end counter;

architecture rtl of counter is
    signal q : std_logic_vector(3 downto 0) := "0000";
begin
    process(clk, res_as)
    begin
        if res_as = '1' or (q(2) = '1' and q(0) = '1') then
            q <= "0000";
        elsif rising_edge(clk) then
            if up = '1' then
                q <= q + 1;
            else
                q <= q - 1;
            end if;
        end if;
    end process;

    count <= q;
end rtl;
