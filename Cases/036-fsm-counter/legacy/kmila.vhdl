library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Independent implementation: FSM + integer counters in a single process.
-- Same PWM-like behavior as the reference; uses unsigned counters instead
-- of the reference's `integer range 0 to 15` to dodge any Kmila gaps in
-- range-constrained integer types.
entity fsm_counter is
    port (
        clk : in  std_logic;
        o   : out std_logic
    );
end fsm_counter;

architecture rtl of fsm_counter is
    signal state : std_logic := '0';   -- '0'=S1 (high), '1'=S2 (low)
    signal cnt   : unsigned(3 downto 0) := (others => '0');
    signal trgt  : unsigned(3 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if state = '0' then  -- S1
                o <= '1';
                if cnt = trgt then
                    state <= '1';
                    if trgt = "1111" then
                        trgt <= (others => '0');
                    else
                        trgt <= trgt + 1;
                    end if;
                else
                    cnt <= cnt + 1;
                end if;
            else  -- S2
                o <= '0';
                if cnt = "1111" then
                    cnt   <= (others => '0');
                    state <= '0';
                else
                    cnt <= cnt + 1;
                end if;
            end if;
        end if;
    end process;
end rtl;
