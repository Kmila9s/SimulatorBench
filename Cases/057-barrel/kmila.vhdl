library ieee;
use ieee.std_logic_1164.all;

entity barrel is
    port (
        clk : in  std_logic;
        se  : in  std_logic_vector(1 downto 0);
        I   : in  std_logic_vector(3 downto 0);
        Q   : out std_logic_vector(3 downto 0);
        Q2  : out std_logic_vector(3 downto 0)
    );
end barrel;

architecture rtl of barrel is
    signal q_r  : std_logic_vector(3 downto 0) := "0000";
    signal q2_r : std_logic_vector(3 downto 0) := "0000";
begin
    process(clk)
    begin
        if rising_edge(clk) then
            case se is
                when "00" =>
                    q_r  <= I;
                    q2_r <= I;
                when "01" =>
                    q_r  <= I(3 downto 1) & "0";
                    q2_r <= I(3) & I(3 downto 1);
                when "10" =>
                    q_r  <= I(3 downto 2) & "00";
                    q2_r <= I(3) & I(3) & I(3 downto 2);
                when others =>
                    q_r  <= I(3) & "000";
                    q2_r <= I(3) & I(3) & I(3) & I(3);
            end case;
        end if;
    end process;

    Q  <= q_r;
    Q2 <= q2_r;
end rtl;
