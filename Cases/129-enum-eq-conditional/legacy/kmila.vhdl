library ieee;
use ieee.std_logic_1164.all;

entity enum_eq_conditional is
    port (
        clk  : in  std_logic;
        go   : in  std_logic;
        flag : out std_logic
    );
end enum_eq_conditional;

architecture rtl of enum_eq_conditional is
    type state_t is (S_IDLE, S_RUN, S_DONE);
    signal state : state_t := S_IDLE;
begin
    process(clk)
    begin
        if rising_edge(clk) then
            case state is
                when S_IDLE =>
                    if go = '1' then
                        state <= S_RUN;
                    end if;
                when S_RUN =>
                    state <= S_DONE;
                when S_DONE =>
                    state <= S_DONE;
            end case;
        end if;
    end process;

    flag <= '1' when state = S_DONE else '0';
end rtl;
