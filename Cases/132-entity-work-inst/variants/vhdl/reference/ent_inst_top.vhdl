library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter8 is
    port (
        clk   : in  std_logic;
        n_rst : in  std_logic;
        q     : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of counter8 is
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

entity ent_inst_top is
    port (
        clk   : in  std_logic;
        n_rst : in  std_logic;
        cout  : out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of ent_inst_top is
    signal cnt_q : std_logic_vector(7 downto 0);
begin
    u_cnt : entity work.counter8(rtl) port map (
        clk   => clk,
        n_rst => n_rst,
        q     => cnt_q
    );

    cout <= cnt_q;
end architecture;
