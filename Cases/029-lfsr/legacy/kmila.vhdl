library ieee;
use ieee.std_logic_1164.all;

entity lsfr is
    port (
        rst : in  std_logic;
        clk : in  std_logic;
        q   : out std_logic_vector(7 downto 0)
    );
end lsfr;

architecture rtl of lsfr is
    signal state : std_logic_vector(7 downto 0) := "00000001";
    signal feedback : std_logic;
begin
    feedback <= state(7) xor state(5) xor state(4) xor state(3);
    q <= state;
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '0' then
                state <= "00000001";
            else
                state <= state(6 downto 0) & feedback;
            end if;
        end if;
    end process;
end rtl;
