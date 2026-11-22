library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiarg_fn is
    port (
        rst : in  std_logic;
        clk : in  std_logic;
        q   : out std_logic_vector(3 downto 0)
    );
end multiarg_fn;

architecture rtl of multiarg_fn is
    signal state : std_logic_vector(3 downto 0) := "0000";
    signal delta : std_logic_vector(3 downto 0) := "0011";

    function step_add(a : std_logic_vector(3 downto 0);
                      b : std_logic_vector(3 downto 0))
        return std_logic_vector is
    begin
        return std_logic_vector(unsigned(a) + unsigned(b));
    end function;
begin
    q <= state;
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '0' then
                state <= "0000";
            else
                state <= step_add(state, delta);
            end if;
        end if;
    end process;
end rtl;
