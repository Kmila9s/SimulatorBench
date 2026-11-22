library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    port (
        clk_i  : in  std_logic;
        arst_i : in  std_logic;
        en_i   : in  std_logic;
        q_o    : out std_logic_vector(7 downto 0)
    );
end counter;

architecture rtl of counter is
    signal q : unsigned(7 downto 0) := (others => '0');
begin
    process(clk_i, arst_i)
    begin
        if arst_i = '1' then
            q <= (others => '0');
        elsif rising_edge(clk_i) then
            if en_i = '1' then
                q <= q + 1;
            end if;
        end if;
    end process;

    q_o <= std_logic_vector(q);
end rtl;
