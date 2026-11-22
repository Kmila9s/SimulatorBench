library ieee;
use ieee.std_logic_1164.all;

entity case_matching is
    port (
        clk : in  std_logic;
        op  : in  std_logic_vector(3 downto 0);
        y   : out std_logic_vector(1 downto 0)
    );
end case_matching;

architecture rtl of case_matching is
    signal reg : std_logic_vector(1 downto 0) := "00";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            case? op is
                when "10--" => reg <= "01";
                when "0-01" => reg <= "10";
                when "1111" => reg <= "11";
                when others => reg <= "00";
            end case?;
        end if;
    end process;

    y <= reg;
end rtl;
