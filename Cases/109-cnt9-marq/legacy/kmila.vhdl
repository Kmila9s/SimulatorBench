library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Exercici_6 is
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        Q   : out std_logic_vector(8 downto 0)
    );
end Exercici_6;

architecture rtl of Exercici_6 is
    signal counter : unsigned(8 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                counter <= (others => '0');
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    Q <= std_logic_vector(counter);
end rtl;
