library ieee;
use ieee.std_logic_1164.all;

entity FFD_cl_en is
    port (
        d_i   : in  std_logic;
        clk_i : in  std_logic;
        cl_i  : in  std_logic;
        en_i  : in  std_logic;
        q_o   : out std_logic
    );
end FFD_cl_en;

architecture rtl of FFD_cl_en is
begin
    process(clk_i, cl_i)
    begin
        if cl_i = '1' then
            q_o <= '0';
        elsif rising_edge(clk_i) then
            if en_i = '1' then
                q_o <= d_i;
            end if;
        end if;
    end process;
end rtl;
