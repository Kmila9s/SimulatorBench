library ieee;
use ieee.std_logic_1164.all;

entity experiment_2_2 is
    port (
        CLK     : in  std_logic;
        DATA_IN : in  std_logic_vector(7 downto 0);
        SEG_SEL : out std_logic_vector(3 downto 0);
        SEG_OUT : out std_logic_vector(7 downto 0)
    );
end experiment_2_2;

architecture rtl of experiment_2_2 is
    signal sel       : std_logic := '0';
    signal digit_out : std_logic_vector(3 downto 0);
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if sel = '0' then
                SEG_SEL   <= "0001";
                digit_out <= DATA_IN(3 downto 0);
                sel       <= '1';
            else
                SEG_SEL   <= "0010";
                digit_out <= DATA_IN(7 downto 4);
                sel       <= '0';
            end if;
        end if;
    end process;

    with digit_out select
        SEG_OUT <= "11000000" when "0000",
                   "11111001" when "0001",
                   "10100100" when "0010",
                   "10110000" when "0011",
                   "10011001" when "0100",
                   "10010010" when "0101",
                   "10000010" when "0110",
                   "11111000" when "0111",
                   "10000000" when "1000",
                   "10010000" when "1001",
                   "10001000" when "1010",
                   "10000011" when "1011",
                   "11100110" when "1100",
                   "10100001" when "1101",
                   "10000110" when "1110",
                   "10001110" when "1111",
                   "00000000" when others;
end rtl;
