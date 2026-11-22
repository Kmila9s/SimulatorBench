library ieee;
use ieee.std_logic_1164.all;

entity RegSinc is
    port (
        clk_i : in  std_logic;
        rst_i : in  std_logic;
        d_i   : in  std_logic_vector(3 downto 0);
        q_o   : out std_logic_vector(3 downto 0)
    );
end RegSinc;

architecture rtl of RegSinc is
begin
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = '1' then
                q_o <= (others => '0');
            else
                q_o <= d_i;
            end if;
        end if;
    end process;
end rtl;
