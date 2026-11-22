library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ContMpot2TcQ_rs_en is
    port (
        clk_i : in  std_logic;
        rst_i : in  std_logic;
        ena_i : in  std_logic;
        q_o   : out std_logic_vector(2 downto 0);
        tc_o  : out std_logic
    );
end ContMpot2TcQ_rs_en;

architecture rtl of ContMpot2TcQ_rs_en is
    signal q : unsigned(2 downto 0) := "000";
begin
    process(clk_i)
    begin
        if rising_edge(clk_i) then
            if rst_i = '1' then
                q <= (others => '0');
            elsif ena_i = '1' then
                q <= q + 1;
            end if;
        end if;
    end process;

    q_o  <= std_logic_vector(q);
    tc_o <= '1' when q = "111" else '0';
end rtl;
