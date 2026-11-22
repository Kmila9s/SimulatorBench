library ieee;
use ieee.std_logic_1164.all;

entity tb_procedure_time_formal is
end tb_procedure_time_formal;

architecture Behavioral of tb_procedure_time_formal is
    component procedure_time_formal
        port (
            q : out std_logic_vector(3 downto 0)
        );
    end component;
    signal q_s : std_logic_vector(3 downto 0);
    signal done : std_logic := '0';
begin
    uut : procedure_time_formal port map (q => q_s);

    stim : process
    begin
        wait for 200 ns;
        done <= '1';
        wait;
    end process;
end Behavioral;
