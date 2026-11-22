library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_n is
    generic (WIDTH : integer := 4);
    port (
        clk   : in  std_logic;
        n_rst : in  std_logic;
        q     : out std_logic_vector(WIDTH - 1 downto 0)
    );
end counter_n;

architecture rtl of counter_n is
    signal cnt : unsigned(WIDTH - 1 downto 0) := (others => '0');
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
end rtl;

-- Top-level entity that drives counter_n via direct-instantiation with a
-- generic override. Regression target for audit F-G-05 (2026-07-12).
library ieee;
use ieee.std_logic_1164.all;

entity gen_inst_top is
    port (
        clk   : in  std_logic;
        n_rst : in  std_logic;
        cout  : out std_logic_vector(7 downto 0)
    );
end gen_inst_top;

architecture rtl of gen_inst_top is
    signal cnt_q : std_logic_vector(7 downto 0);
begin
    -- `entity work.X generic map (…) port map (…)` — the VHDL-2008
    -- direct-instantiation form with a generic override. The Kmila
    -- interpreter used to reject this exact shape; the fix routes it
    -- through ParseComponentInstantiation like the plain form.
    u_cnt : entity work.counter_n
        generic map (WIDTH => 8)
        port map (
            clk   => clk,
            n_rst => n_rst,
            q     => cnt_q
        );

    cout <= cnt_q;
end rtl;
