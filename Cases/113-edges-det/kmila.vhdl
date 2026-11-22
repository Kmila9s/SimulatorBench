library ieee;
use ieee.std_logic_1164.all;

entity edges_detection is
    port (
        clk                   : in  std_logic;
        reset                 : in  std_logic;
        trig_inv              : in  std_logic;
        triggers_vector       : in  std_logic_vector(1 downto 0);
        triggers_vector_pulse : out std_logic_vector(1 downto 0)
    );
end edges_detection;

architecture rtl of edges_detection is
    signal old : std_logic_vector(1 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '1' then
            triggers_vector_pulse <= (others => '0');
            old                   <= triggers_vector;
        elsif rising_edge(clk) then
            if trig_inv = '1' then
                triggers_vector_pulse <= (old xor triggers_vector) and old;
            else
                triggers_vector_pulse <= (old xor triggers_vector) and triggers_vector;
            end if;
            old <= triggers_vector;
        end if;
    end process;
end rtl;
