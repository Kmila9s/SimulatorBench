library ieee;
use ieee.std_logic_1164.all;

-- Independent implementation. Uses a std_logic_vector(1 downto 0) for the
-- state register rather than the reference's enumerated state_type — both
-- encode 4 states; functional behavior derived from the problem spec.
--
-- Transition table (clock-triggered):
--   S0 + 0 → S0, dout=0
--   S0 + 1 → S1, dout=1
--   S1 + 0 → S2, dout=1
--   S1 + 1 → S3, dout=0
--   S2 + 0 → S0, dout=0
--   S2 + 1 → S3, dout=1
--   S3 + 0 → S3, dout=0
--   S3 + 1 → S0, dout=1
entity problem_9_2_3 is
    port (
        clock : in  std_logic;
        din   : in  std_logic;
        reset : in  std_logic;
        dout  : out std_logic
    );
end problem_9_2_3;

architecture rtl of problem_9_2_3 is
    signal state : std_logic_vector(1 downto 0) := "00";
begin
    process(clock, reset)
    begin
        if reset = '1' then
            state <= "00";
        elsif rising_edge(clock) then
            case state is
                when "00" =>
                    if din = '0' then dout <= '0'; state <= "00";
                    else              dout <= '1'; state <= "01"; end if;
                when "01" =>
                    if din = '1' then dout <= '0'; state <= "11";
                    else              dout <= '1'; state <= "10"; end if;
                when "10" =>
                    if din = '0' then dout <= '0'; state <= "00";
                    else              dout <= '1'; state <= "11"; end if;
                when "11" =>
                    if din = '0' then dout <= '0'; state <= "11";
                    else              dout <= '1'; state <= "00"; end if;
                when others =>
                    state <= "00";
            end case;
        end if;
    end process;
end rtl;
