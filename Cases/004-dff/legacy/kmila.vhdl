library ieee;
use ieee.std_logic_1164.all;

-- Independent implementation. Same I/O contract as the reference (clk, D in;
-- Q out). Uses a direct signal assignment inside the rising_edge guard
-- rather than the reference's process-local variable, but the function is
-- identical: Q latches D on each rising clock edge.
entity DFF is
    port (
        clk : in  std_logic;
        D   : in  std_logic;
        Q   : out std_logic
    );
end DFF;

architecture rtl of DFF is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            Q <= D;
        end if;
    end process;
end rtl;
