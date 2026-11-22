library ieee;
use ieee.std_logic_1164.all;

entity Johnson is
    port (
        clk_i : in  std_logic;
        rst_i : in  std_logic;
        q_o   : out std_logic_vector(3 downto 0)
    );
end Johnson;

architecture rtl of Johnson is
    signal q : std_logic_vector(3 downto 0) := "0000";
begin
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = '1' or (q(1) = '0' and q(0) = '1') then
                q <= "0000";
            else
                q <= (not q(0)) & q(3 downto 1);
            end if;
        end if;
    end process;

    q_o <= q;
end rtl;
