library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rom_array_lookup is
    port (
        clk  : in  std_logic;
        addr : in  std_logic_vector(2 downto 0);
        data : out std_logic_vector(7 downto 0)
    );
end entity;

architecture behaviour of rom_array_lookup is
    type rom_t is array (0 to 7) of std_logic_vector(7 downto 0);
    constant rom_init : rom_t := (
        "10101010", "10111011", "11001100", "11011101",
        "00010001", "00100010", "00110011", "01000100"
    );
    signal data_reg : std_logic_vector(7 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            data_reg <= rom_init(to_integer(unsigned(addr)));
        end if;
    end process;

    data <= data_reg;
end architecture;
