library ieee;
use ieee.std_logic_1164.all;

entity others_init_readback is
    port (
        clk    : in  std_logic;
        enable : in  std_logic;
        q      : out std_logic_vector(7 downto 0)
    );
end others_init_readback;

architecture rtl of others_init_readback is
    signal r : std_logic_vector(7 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if enable = '1' then
                r <= "10101010";
            end if;
        end if;
    end process;

    q <= r;
end rtl;
