library ieee;
use ieee.std_logic_1164.all;

entity ring_counter is
    port (
        clk : in  std_logic;
        Q   : out std_logic_vector(3 downto 0);
        Q2  : out std_logic_vector(3 downto 0)
    );
end ring_counter;

architecture rtl of ring_counter is
    signal r : std_logic_vector(3 downto 0) := "0001";
    signal j : std_logic_vector(3 downto 0) := "0000";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            r <= r(2 downto 0) & r(3);
            j <= j(2 downto 0) & (not j(3));
        end if;
    end process;

    Q  <= r;
    Q2 <= j;
end rtl;
