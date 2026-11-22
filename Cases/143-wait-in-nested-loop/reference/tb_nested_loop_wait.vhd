library ieee;
use ieee.std_logic_1164.all;

entity tb_nested_loop_wait is
end tb_nested_loop_wait;

architecture Behavioral of tb_nested_loop_wait is
    component nested_loop_wait
        port (
            q : out std_logic_vector(3 downto 0)
        );
    end component;
    signal q_s : std_logic_vector(3 downto 0);
begin
    uut : nested_loop_wait port map (q => q_s);

    stim : process
    begin
        wait for 100 ns;
        wait;
    end process;
end Behavioral;
