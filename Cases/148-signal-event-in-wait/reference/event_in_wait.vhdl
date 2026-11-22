library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity event_in_wait is
    port (
        clk   : in  std_logic;
        n_rst : in  std_logic;
        count : out std_logic_vector(3 downto 0)
    );
end event_in_wait;

architecture rtl of event_in_wait is
    signal cnt : unsigned(3 downto 0) := (others => '0');
begin
    process(clk, n_rst)
    begin
        if n_rst = '0' then
            cnt <= (others => '0');
        elsif clk'event and clk = '1' then
            cnt <= cnt + 1;
        end if;
    end process;

    count <= std_logic_vector(cnt);
end rtl;
