library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Internal regression test: a clocked counter whose value reaches the
-- output port through THREE concurrent alias hops. GHDL handles this
-- with standard delta-cycle convergence semantics. Kmila must too.
entity multi_hop_pure is
    port (
        clk   : in  std_logic;
        n_rst : in  std_logic;
        y     : out std_logic_vector(7 downto 0)
    );
end multi_hop_pure;

architecture rtl of multi_hop_pure is
    signal cnt : unsigned(7 downto 0) := (others => '0');
    signal a   : std_logic_vector(7 downto 0);
    signal b   : std_logic_vector(7 downto 0);
    signal c   : std_logic_vector(7 downto 0);
begin
    process(clk, n_rst)
    begin
        if n_rst = '0' then
            cnt <= (others => '0');
        elsif rising_edge(clk) then
            cnt <= cnt + 1;
        end if;
    end process;

    a <= std_logic_vector(cnt);
    b <= a;
    c <= b;
    y <= c;
end rtl;
