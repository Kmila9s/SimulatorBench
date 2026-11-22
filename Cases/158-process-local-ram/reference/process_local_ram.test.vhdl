library ieee;
use ieee.std_logic_1164.all;

entity process_local_ram_tb is
end entity;

architecture testbench of process_local_ram_tb is
    component process_local_ram
        port (
            clk  : in  std_logic;
            we   : in  std_logic;
            addr : in  std_logic_vector(2 downto 0);
            din  : in  std_logic_vector(7 downto 0);
            dout : out std_logic_vector(7 downto 0)
        );
    end component;

    signal clk  : std_logic := '0';
    signal we   : std_logic := '0';
    signal addr : std_logic_vector(2 downto 0) := "000";
    signal din  : std_logic_vector(7 downto 0) := "00000000";
    signal dout : std_logic_vector(7 downto 0);
begin
    dut : process_local_ram port map (clk, we, addr, din, dout);

    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        we   <= '0';
        addr <= "000";
        din  <= "00000000";
        wait for 15 ns;
        addr <= "011";
        din  <= "11011101";
        we   <= '1';
        wait for 10 ns;
        we   <= '0';
        wait for 500 ns;
    end process;
end;
