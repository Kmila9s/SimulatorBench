library ieee;
use ieee.std_logic_1164.all;

entity event_in_wait_tb is
end entity;

architecture testbench of event_in_wait_tb is
    component event_in_wait
        port (
            clk   : in  std_logic;
            n_rst : in  std_logic;
            count : out std_logic_vector(3 downto 0)
        );
    end component;

    signal clk   : std_logic;
    signal n_rst : std_logic;
    signal count : std_logic_vector(3 downto 0);
begin
    dut : event_in_wait port map (clk, n_rst, count);

    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        n_rst <= '0';
        wait for 10 ns;
        n_rst <= '1';
        wait for 250 ns;
    end process;
end;
