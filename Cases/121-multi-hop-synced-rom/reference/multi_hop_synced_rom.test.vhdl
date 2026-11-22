library ieee;
use ieee.std_logic_1164.all;

entity multi_hop_synced_rom_tb is
end entity;

architecture testbench of multi_hop_synced_rom_tb is
    component multi_hop_synced_rom
        port (
            clk     : in  std_logic;
            reset   : in  std_logic;
            start   : in  std_logic;
            done    : out std_logic;
            acc_out : out std_logic_vector(7 downto 0)
        );
    end component;

    signal clk     : std_logic := '0';
    signal reset   : std_logic := '1';
    signal start   : std_logic := '0';
    signal done    : std_logic;
    signal acc_out : std_logic_vector(7 downto 0);
begin
    dut : multi_hop_synced_rom port map (clk, reset, start, done, acc_out);

    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        reset <= '1';
        wait for 15 ns;
        reset <= '0';
        wait for 10 ns;
        start <= '1';
        wait for 500 ns;
    end process;
end;
