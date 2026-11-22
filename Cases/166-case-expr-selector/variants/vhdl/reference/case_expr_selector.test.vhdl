library ieee;
use ieee.std_logic_1164.all;

entity case_expr_selector_tb is
end entity;

architecture testbench of case_expr_selector_tb is
    component case_expr_selector
        port (
            val : in  std_logic_vector(3 downto 0);
            seg : out std_logic_vector(6 downto 0)
        );
    end component;

    signal val : std_logic_vector(3 downto 0) := "0000";
    signal seg : std_logic_vector(6 downto 0);
begin
    dut : case_expr_selector port map (val, seg);

    -- Walk every decoded arm plus an 'others' value. 30 ns per step so the
    -- bench samples land well inside each stable interval (no edge races).
    process
    begin
        val <= "0000"; wait for 30 ns;
        val <= "0001"; wait for 30 ns;
        val <= "0010"; wait for 30 ns;
        val <= "0011"; wait for 30 ns;
        val <= "0100"; wait for 30 ns;
        val <= "0101"; wait for 30 ns;
        val <= "0110"; wait for 30 ns;
        val <= "0111"; wait for 30 ns;
        val <= "1000"; wait for 30 ns;
        val <= "1001"; wait for 30 ns;
        val <= "1111"; wait for 30 ns;  -- others
        wait;
    end process;
end;
