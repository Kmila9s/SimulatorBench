library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity process_local_ram is
    port (
        clk  : in  std_logic;
        we   : in  std_logic;
        addr : in  std_logic_vector(2 downto 0);
        din  : in  std_logic_vector(7 downto 0);
        dout : out std_logic_vector(7 downto 0)
    );
end process_local_ram;

architecture rtl of process_local_ram is
begin
    process(clk)
        type mem_t is array (0 to 7) of std_logic_vector(7 downto 0);
        variable mem : mem_t := (others => (others => '0'));
    begin
        if rising_edge(clk) then
            if we = '1' then
                mem(to_integer(unsigned(addr))) := din;
            end if;
            dout <= mem(to_integer(unsigned(addr)));
        end if;
    end process;
end rtl;
