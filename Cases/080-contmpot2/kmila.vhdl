library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ContMpot2Q_rs is
    port (
        clk_i : in  std_logic;
        rst_i : in  std_logic;
        q_o   : out std_logic_vector(2 downto 0)
    );
end ContMpot2Q_rs;

architecture rtl of ContMpot2Q_rs is
    signal q : unsigned(2 downto 0) := "000";
begin
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = '1' then
                q <= (others => '0');
            else
                q <= q + 1;
            end if;
        end if;
    end process;

    q_o <= std_logic_vector(q);
end rtl;
