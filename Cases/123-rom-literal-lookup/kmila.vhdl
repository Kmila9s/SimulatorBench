library ieee;
use ieee.std_logic_1164.all;

entity rom_literal_lookup is
    port (
        clk : in  std_logic;
        q   : out std_logic_vector(7 downto 0)
    );
end rom_literal_lookup;

architecture rtl of rom_literal_lookup is
    type rom_t is array (0 to 7) of std_logic_vector(7 downto 0);
    constant rom_init : rom_t := (
        "10101010", "10111011", "11001100", "11011101",
        "00010001", "00100010", "00110011", "01000100"
    );
    signal q_reg : std_logic_vector(7 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            q_reg <= rom_init(3);
        end if;
    end process;

    q <= q_reg;
end rtl;
