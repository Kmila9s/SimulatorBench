library ieee;
use ieee.std_logic_1164.all;

-- GHDL golden. Same behavior as the Kmila-side source; kept here as
-- an independent reference so the bench can produce a golden VCD
-- from an untouched GHDL run.
entity lfsr_fn is
    port (
        rst : in  std_logic;
        clk : in  std_logic;
        q   : out std_logic_vector(7 downto 0)
    );
end lfsr_fn;

architecture rtl of lfsr_fn is
    signal state : std_logic_vector(7 downto 0) := "00000001";

    function step(v : std_logic_vector(7 downto 0))
        return std_logic_vector is
    begin
        return v(6 downto 0) & (v(7) xor v(5) xor v(4) xor v(3));
    end function;
begin
    q <= state;
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '0' then
                state <= "00000001";
            else
                state <= step(state);
            end if;
        end if;
    end process;
end rtl;
