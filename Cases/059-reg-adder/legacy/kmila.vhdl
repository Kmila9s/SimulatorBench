library ieee;
use ieee.std_logic_1164.all;

entity reg_adder is
    port (
        A    : in  std_logic_vector(3 downto 0);
        B    : in  std_logic_vector(3 downto 0);
        clk  : in  std_logic;
        se   : in  std_logic;
        C    : out std_logic_vector(3 downto 0);
        over : out std_logic
    );
end reg_adder;

architecture rtl of reg_adder is
    signal a1 : std_logic_vector(3 downto 0) := "0000";
    signal b1 : std_logic_vector(3 downto 0) := "0000";
    signal o  : std_logic_vector(3 downto 0) := "0000";
    signal c1 : std_logic := '0';
    signal ci : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if se = '1' then
                a1 <= A;
                b1 <= B;
            else
                c1 <= a1(0) xor b1(0) xor ci;
                ci <= a1(0) and b1(0);
                a1 <= '0' & a1(3 downto 1);
                b1 <= '0' & b1(3 downto 1);
                o  <= c1 & o(3 downto 1);
            end if;
        end if;
    end process;

    over <= ci;
    C    <= o;
end rtl;
