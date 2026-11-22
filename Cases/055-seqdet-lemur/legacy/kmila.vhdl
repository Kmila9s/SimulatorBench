library ieee;
use ieee.std_logic_1164.all;

entity seq_det is
    port (
        clk   : in  std_logic;
        reset : in  std_logic;
        seq   : in  std_logic;
        det   : out std_logic
    );
end seq_det;

architecture rtl of seq_det is
    type state_t is (sA, sB, sC, sD);
    signal state : state_t := sA;
begin
    process(clk)
    begin
        if reset = '1' then
            det   <= '0';
            state <= sA;
        elsif rising_edge(clk) then
            case state is
                when sA =>
                    det <= '0';
                    if seq = '0' then
                        state <= sA;
                    else
                        state <= sB;
                    end if;
                when sB =>
                    if seq = '0' then
                        state <= sC;
                    else
                        state <= sB;
                    end if;
                when sC =>
                    if seq = '0' then
                        state <= sA;
                    else
                        state <= sD;
                    end if;
                when sD =>
                    if seq = '0' then
                        state <= sC;
                    else
                        state <= sA;
                        det   <= '1';
                    end if;
            end case;
        end if;
    end process;
end rtl;
