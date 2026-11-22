library ieee;
use ieee.std_logic_1164.all;

-- Entity ports match the reference: x (3-bit) → y (8-bit). The reference's
-- TB drives signals named `input`/`output` but binds them positionally to
-- entity ports x/y, so the bench (which references entity ports) uses x/y.
entity dec3x8_conditional is
    port (
        x : in  std_logic_vector(2 downto 0);
        y : out std_logic_vector(7 downto 0)
    );
end dec3x8_conditional;

architecture rtl of dec3x8_conditional is
begin
    process(x)
    begin
        case x is
            when "000" => y <= "00000001";
            when "001" => y <= "00000010";
            when "010" => y <= "00000100";
            when "011" => y <= "00001000";
            when "100" => y <= "00010000";
            when "101" => y <= "00100000";
            when "110" => y <= "01000000";
            when "111" => y <= "10000000";
            when others => y <= "00000000";
        end case;
    end process;
end rtl;
