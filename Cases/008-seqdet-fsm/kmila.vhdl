library ieee;
use ieee.std_logic_1164.all;

-- Independent implementation of an overlapping detector for `1001` and
-- `1111`. State is held in a 3-bit std_logic_vector with explicit binary
-- encodings rather than the reference's enumerated `state_type` — same
-- transition graph, derived from the problem spec.
--
-- State encoding (after the indicated input prefix):
--   S0 "000" = idle / just saw '0'
--   S1 "001" = saw "1"
--   S2 "010" = saw "10"
--   S3 "011" = saw "100"
--   S4 "100" = saw "11"
--   S5 "101" = saw "111"
-- det_vld pulses high for one cycle when "1001" (S3 + '1') or
-- "1111" (S5 + '1') is observed.
entity fsm is
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        seq     : in  std_logic;
        det_vld : out std_logic
    );
end fsm;

architecture rtl of fsm is
    signal state : std_logic_vector(2 downto 0) := "000";
begin
    process(clk)
    begin
        if reset = '1' then
            state   <= "000";
            det_vld <= '0';
        elsif rising_edge(clk) then
            det_vld <= '0';
            case state is
                when "000" => -- idle / saw '0'
                    if seq = '1' then state <= "001"; end if;
                when "001" => -- saw "1"
                    if seq = '0' then state <= "010";
                    else              state <= "100"; end if;
                when "010" => -- saw "10"
                    if seq = '0' then state <= "011";
                    else              state <= "001"; end if;
                when "011" => -- saw "100"
                    if seq = '0' then state <= "000";
                    else
                        state   <= "001";
                        det_vld <= '1';   -- matched "1001"
                    end if;
                when "100" => -- saw "11"
                    if seq = '0' then state <= "010";
                    else              state <= "101"; end if;
                when "101" => -- saw "111"
                    if seq = '0' then state <= "010";
                    else
                        state   <= "101";
                        det_vld <= '1';   -- matched "1111"
                    end if;
                when others =>
                    state <= "000";
            end case;
        end if;
    end process;
end rtl;
