library ieee;
use ieee.std_logic_1164.all;

entity fn_case_mux is
    port (
        sel : in  std_logic_vector(1 downto 0);
        y   : out std_logic_vector(3 downto 0)
    );
end fn_case_mux;

architecture rtl of fn_case_mux is
    -- Function body with a top-level case whose arms return literals.
    -- Exercises Tier 4.3 pass-4 item B: the synth-time inliner emits a
    -- MUX cascade (one MUX per non-others arm, seeded by the others
    -- literal) instead of a black-box UserFunction constant.
    function decode(s : std_logic_vector(1 downto 0)) return std_logic_vector is
    begin
        case s is
            when "00"   => return "0001";
            when "01"   => return "0010";
            when "10"   => return "0100";
            when others => return "1000";
        end case;
    end decode;
begin
    y <= decode(sel);
end rtl;
