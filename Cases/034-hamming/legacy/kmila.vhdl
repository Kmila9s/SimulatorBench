library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Independent implementation: fixed 16-bit version (the TB sets generic
-- M=16). Counts set bits of (i_a XOR i_b) into an 8-bit unsigned output.
entity hamming is
    port (
        i_a, i_b : in  std_logic_vector(15 downto 0);
        o_dist   : out std_logic_vector(7 downto 0)
    );
end hamming;

architecture rtl of hamming is
    signal diff : std_logic_vector(15 downto 0);
begin
    diff <= i_a xor i_b;
    process(diff)
        variable count : integer range 0 to 16;
    begin
        count := 0;
        for i in 0 to 15 loop
            if diff(i) = '1' then
                count := count + 1;
            end if;
        end loop;
        o_dist <= std_logic_vector(to_unsigned(count, 8));
    end process;
end rtl;
