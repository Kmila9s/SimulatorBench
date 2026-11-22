library ieee;
use ieee.std_logic_1164.all;

entity MuxN is
    port (
        i_i   : in  std_logic_vector(3 downto 0);
        sel_i : in  std_logic_vector(1 downto 0);
        ena_i : in  std_logic;
        y_o   : out std_logic
    );
end MuxN;

architecture rtl of MuxN is
    signal sel_y : std_logic;
begin
    process(i_i, sel_i)
    begin
        case sel_i is
            when "00"   => sel_y <= i_i(0);
            when "01"   => sel_y <= i_i(1);
            when "10"   => sel_y <= i_i(2);
            when others => sel_y <= i_i(3);
        end case;
    end process;

    y_o <= sel_y and ena_i;
end rtl;
