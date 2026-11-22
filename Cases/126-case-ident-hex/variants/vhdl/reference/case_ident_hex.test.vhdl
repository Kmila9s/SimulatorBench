library ieee;
use ieee.std_logic_1164.all;

entity case_ident_hex_tb is
end entity;

architecture testbench of case_ident_hex_tb is
    component case_ident_hex
        port (
            clk     : in  std_logic;
            op      : in  std_logic_vector(7 downto 0);
            out_reg : out std_logic_vector(7 downto 0)
        );
    end component;

    signal clk     : std_logic := '0';
    signal op      : std_logic_vector(7 downto 0) := "00000000";
    signal out_reg : std_logic_vector(7 downto 0);
begin
    dut : case_ident_hex port map (clk, op, out_reg);

    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    process
    begin
        op <= "00001011"; wait for 20 ns;
        op <= "00000111"; wait for 20 ns;
        op <= "00001100"; wait for 20 ns;
        op <= "00001111"; wait for 200 ns;
    end process;
end;
