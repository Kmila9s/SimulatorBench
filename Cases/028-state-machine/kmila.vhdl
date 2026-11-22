library ieee;
use ieee.std_logic_1164.all;

-- Independent implementation: encodes the same Mealy/Moore FSM but uses a
-- 2-bit std_logic_vector state register instead of the reference's
-- enumerated state_type. Async-low reset + i-dependent output + j-dependent
-- next-state mirror the reference's three-process design.
entity state_machine is
    port (
        clk  : in  std_logic;
        arst : in  std_logic;
        i    : in  std_logic;
        j    : in  std_logic;
        q    : out std_logic_vector(2 downto 0)
    );
end state_machine;

architecture rtl of state_machine is
    signal actual_state : std_logic_vector(1 downto 0);
    signal next_state   : std_logic_vector(1 downto 0);
begin
    -- State register
    process(arst, clk)
    begin
        if arst = '0' then
            actual_state <= "00";
        elsif rising_edge(clk) then
            actual_state <= next_state;
        end if;
    end process;

    -- Output logic
    process(actual_state, i)
    begin
        case actual_state is
            when "00" => -- S0
                if i = '1' then q <= "101"; else q <= "001"; end if;
            when "01" => -- S1
                if i = '1' then q <= "010"; else q <= "110"; end if;
            when "10" => -- S2
                if i = '1' then q <= "011"; else q <= "000"; end if;
            when "11" => -- S3
                if i = '1' then q <= "111"; else q <= "100"; end if;
            when others => q <= "000";
        end case;
    end process;

    -- Next-state logic
    process(actual_state, j)
    begin
        case actual_state is
            when "00" => next_state <= "01";                                   -- S0 → S1
            when "01" => if j = '1' then next_state <= "10"; else next_state <= "00"; end if;
            when "10" => if j = '0' then next_state <= "11"; else next_state <= "10"; end if;
            when "11" => next_state <= "11";                                   -- S3 stays
            when others => next_state <= "00";
        end case;
    end process;
end rtl;
