library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    port (
        d    : in  std_logic_vector(9 downto 0);
        clk  : in  std_logic;
        ce   : in  std_logic;
        load : in  std_logic;
        rst  : in  std_logic;
        q    : out std_logic_vector(9 downto 0)
    );
end counter;

architecture rtl of counter is
    signal cnt : unsigned(9 downto 0) := (others => '0');
begin
    q <= std_logic_vector(cnt);
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '0' then
                cnt <= (others => '0');
            elsif ce = '1' then
                if load = '1' then
                    cnt <= unsigned(d);
                else
                    cnt <= cnt + 1;
                end if;
            end if;
        end if;
    end process;
end rtl;
