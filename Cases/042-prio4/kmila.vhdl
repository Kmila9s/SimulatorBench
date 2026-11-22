library ieee;
use ieee.std_logic_1164.all;

entity priority_encoder_4in is
    port (
        inputs : in  std_logic_vector(3 downto 0);
        valid  : out std_logic;
        result : out std_logic_vector(1 downto 0)
    );
end priority_encoder_4in;

architecture rtl of priority_encoder_4in is
begin
    process(inputs)
    begin
        if inputs(3) = '1' then
            result <= "11";
            valid  <= '1';
        elsif inputs(2) = '1' then
            result <= "10";
            valid  <= '1';
        elsif inputs(1) = '1' then
            result <= "01";
            valid  <= '1';
        elsif inputs(0) = '1' then
            result <= "00";
            valid  <= '1';
        else
            result <= "00";
            valid  <= '0';
        end if;
    end process;
end rtl;
