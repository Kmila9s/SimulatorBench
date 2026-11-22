library ieee;
use ieee.std_logic_1164.all;

entity ContAnillo is
    port (
        clk_i : in  std_logic;
        rst_i : in  std_logic;
        q_o   : out std_logic_vector(5 downto 0)
    );
end ContAnillo;

architecture rtl of ContAnillo is
    signal r : std_logic_vector(5 downto 0) := "100000";
    signal feedback : std_logic;
begin
    feedback <= not (r(1) or r(2) or r(3) or r(4) or r(5));

    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = '1' then
                r <= "100000";
            else
                r <= feedback & r(5 downto 1);
            end if;
        end if;
    end process;

    q_o <= r;
end rtl;
