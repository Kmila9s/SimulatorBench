library ieee;
use ieee.std_logic_1164.all;

entity shift_register is
    port (
        d   : in  std_logic;
        clk : in  std_logic;
        q   : out std_logic
    );
end shift_register;

architecture rtl of shift_register is
    signal state : std_logic_vector(4 downto 0) := (others => '0');
begin
    q <= state(4);
    process(clk)
    begin
        if rising_edge(clk) then
            state <= state(3 downto 0) & d;
        end if;
    end process;
end rtl;
