library ieee;
use ieee.std_logic_1164.all;

entity code_det is
    port (
        clk : in  std_logic;
        I   : in  std_logic_vector(3 downto 0);
        O   : out std_logic
    );
end code_det;

architecture rtl of code_det is
    type state_t is (sA, sB, sC, sD);
    signal state : state_t := sA;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            case state is
                when sA =>
                    O <= '0';
                    if I = "1001" then state <= sB;
                    else              state <= sA; end if;
                when sB =>
                    O <= '0';
                    if I = "0111" then state <= sC;
                    else              state <= sA; end if;
                when sC =>
                    O <= '0';
                    if I = "0010" then state <= sD;
                    else              state <= sC; end if;
                when sD =>
                    O     <= '1';
                    state <= sA;
            end case;
        end if;
    end process;
end rtl;
