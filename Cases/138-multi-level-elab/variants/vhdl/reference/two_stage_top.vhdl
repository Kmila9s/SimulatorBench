library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_leaf is
    port (
        clk   : in  std_logic;
        n_rst : in  std_logic;
        q     : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of counter_leaf is
    signal cnt : unsigned(7 downto 0) := (others => '0');
begin
    process(clk, n_rst)
    begin
        if n_rst = '0' then
            cnt <= (others => '0');
        elsif rising_edge(clk) then
            cnt <= cnt + 1;
        end if;
    end process;

    q <= std_logic_vector(cnt);
end architecture;


library ieee;
use ieee.std_logic_1164.all;

entity wrapper_mid is
    port (
        clk   : in  std_logic;
        n_rst : in  std_logic;
        q     : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of wrapper_mid is
    signal inner_q : std_logic_vector(7 downto 0);
begin
    u_leaf : entity work.counter_leaf
        port map (
            clk   => clk,
            n_rst => n_rst,
            q     => inner_q
        );

    q <= inner_q;
end architecture;


library ieee;
use ieee.std_logic_1164.all;

entity two_stage_top is
    port (
        clk   : in  std_logic;
        n_rst : in  std_logic;
        cout  : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of two_stage_top is
    signal mid_q : std_logic_vector(7 downto 0);
begin
    u_mid : entity work.wrapper_mid
        port map (
            clk   => clk,
            n_rst => n_rst,
            q     => mid_q
        );

    cout <= mid_q;
end architecture;
