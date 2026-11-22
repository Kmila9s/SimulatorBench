library ieee;
use ieee.std_logic_1164.all;

entity tb_case_wait is
end tb_case_wait;

architecture Behavioral of tb_case_wait is
    component case_wait
        port (
            q : out std_logic_vector(1 downto 0)
        );
    end component;
    signal q_s : std_logic_vector(1 downto 0);
begin
    uut : case_wait port map (q => q_s);

    stim : process
    begin
        wait for 200 ns;
        wait;
    end process;
end Behavioral;
