library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ContM is
    port (
        clk_i : in  std_logic;
        rst_i : in  std_logic;
        ena_i : in  std_logic;
        tc_o  : out std_logic;
        q_o   : out std_logic_vector(3 downto 0)
    );
end ContM;

architecture rtl of ContM is
    signal q : unsigned(3 downto 0) := (others => '0');
begin
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = '1' then
                q <= (others => '0');
            elsif ena_i = '1' then
                if q = "1001" then
                    q <= (others => '0');
                else
                    q <= q + 1;
                end if;
            end if;
        end if;
    end process;

    q_o  <= std_logic_vector(q);
    tc_o <= '1' when q = "1001" else '0';
end rtl;
