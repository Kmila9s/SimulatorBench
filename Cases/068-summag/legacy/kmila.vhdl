library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SumMagN is
    port (
        a_i   : in  std_logic_vector(2 downto 0);
        b_i   : in  std_logic_vector(2 downto 0);
        ci_i  : in  std_logic_vector(0 downto 0);
        sum_o : out std_logic_vector(2 downto 0);
        co_o  : out std_logic
    );
end SumMagN;

architecture rtl of SumMagN is
    signal a_ext, b_ext, ci_ext, total : unsigned(3 downto 0);
    signal total_sv : std_logic_vector(3 downto 0);
begin
    a_ext   <= '0' & unsigned(a_i);
    b_ext   <= '0' & unsigned(b_i);
    ci_ext  <= "000" & ci_i(0);
    total   <= a_ext + b_ext + ci_ext;
    total_sv <= std_logic_vector(total);

    sum_o <= total_sv(2 downto 0);
    co_o  <= total_sv(3);
end rtl;
