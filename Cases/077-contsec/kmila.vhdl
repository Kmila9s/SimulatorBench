library ieee;
use ieee.std_logic_1164.all;

entity ContadorSec is
    port (
        rst_i : in  std_logic;
        clk_i : in  std_logic;
        q_o   : out std_logic_vector(2 downto 0)
    );
end ContadorSec;

architecture rtl of ContadorSec is
    signal q : std_logic_vector(2 downto 0) := "100";
begin
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = '1' then
                q <= "100";
            else
                case q is
                    when "100"  => q <= "011";
                    when "011"  => q <= "111";
                    when "111"  => q <= "001";
                    when "001"  => q <= "000";
                    when "000"  => q <= "100";
                    when others => q <= "100";
                end case;
            end if;
        end if;
    end process;

    q_o <= q;
end rtl;
