library ieee;
use ieee.std_logic_1164.all;

entity Sec1011MooreCS is
    port (
        clk_i : in  std_logic;
        rst_i : in  std_logic;
        dat_i : in  std_logic;
        sal_o : out std_logic
    );
end Sec1011MooreCS;

architecture rtl of Sec1011MooreCS is
    type   state_t is (sA, sB, sC, sD, sE);
    signal current_s, next_s : state_t;
begin
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = '1' then
                current_s <= sA;
            else
                current_s <= next_s;
            end if;
        end if;
    end process;

    process(current_s, dat_i)
    begin
        case current_s is
            when sA =>
                sal_o <= '0';
                if dat_i = '1' then next_s <= sB;
                else                next_s <= sA;
                end if;
            when sB =>
                sal_o <= '0';
                if dat_i = '0' then next_s <= sC;
                else                next_s <= sB;
                end if;
            when sC =>
                sal_o <= '0';
                if dat_i = '1' then next_s <= sD;
                else                next_s <= sA;
                end if;
            when sD =>
                sal_o <= '0';
                if dat_i = '1' then next_s <= sE;
                else                next_s <= sC;
                end if;
            when sE =>
                sal_o <= '1';
                if dat_i = '0' then next_s <= sC;
                else                next_s <= sB;
                end if;
        end case;
    end process;
end rtl;
