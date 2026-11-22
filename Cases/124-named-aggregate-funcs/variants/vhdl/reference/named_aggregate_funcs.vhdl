library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity named_aggregate_funcs is
    port (
        clk  : in  std_logic;
        addr : in  std_logic_vector(2 downto 0);
        data : out std_logic_vector(7 downto 0)
    );
end entity;

architecture behaviour of named_aggregate_funcs is
    type rom_t is array (0 to 7) of std_logic_vector(7 downto 0);

    function pack(v : natural) return std_logic_vector is
    begin
        return std_logic_vector(to_unsigned(v, 8));
    end function;

    constant rom_init : rom_t := (
        0 => pack(170),
        1 => pack(187),
        2 => pack(204),
        3 => pack(221),
        4 => pack(17),
        5 => pack(34),
        6 => pack(51),
        7 => pack(68)
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
