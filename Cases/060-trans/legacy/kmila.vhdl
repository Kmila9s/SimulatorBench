library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity trans is
    port (
        A   : in  std_logic_vector(3 downto 0);
        clk : in  std_logic;
        se  : in  std_logic;
        C   : out std_logic_vector(3 downto 0);
        sum : out std_logic_vector(2 downto 0)
    );
end trans;

architecture rtl of trans is
    signal a1 : std_logic_vector(3 downto 0) := "0000";
    signal o  : std_logic_vector(3 downto 0) := "0000";
    signal ci : std_logic_vector(2 downto 0) := "000";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if se = '1' then
                a1 <= A;
            else
                if a1(0) = '1' then
                    ci <= ci + 1;
                end if;
                a1 <= '0' & a1(3 downto 1);
                o  <= a1(0) & o(3 downto 1);
            end if;
        end if;
    end process;

    sum <= ci;
    C   <= o;
end rtl;
