library ieee;
use ieee.std_logic_1164.all;

-- F-G-13d (Phase 2, 2026-07-22) — regression fence for waits inside
-- a `case when` arm body. Same defect class as case 141 but for
-- CaseStructure. Pre-fix, the arm's wait was silently dropped.
entity case_wait is
    port (
        q : out std_logic_vector(1 downto 0)
    );
end case_wait;

architecture rtl of case_wait is
    signal state : std_logic_vector(1 downto 0) := "00";
begin
    q <= state;

    process
    begin
        case state is
            when "00" =>
                wait for 10 ns;
                state <= "01";
            when "01" =>
                wait for 20 ns;
                state <= "10";
            when "10" =>
                wait for 30 ns;
                state <= "11";
            when others =>
                wait for 40 ns;
                state <= "00";
        end case;
    end process;
end rtl;
