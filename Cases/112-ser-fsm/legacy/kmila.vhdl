library ieee;
use ieee.std_logic_1164.all;

entity Serializador is
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;
        start      : in  std_logic;
        data_in    : in  std_logic_vector(7 downto 0);
        serial_out : out std_logic;
        done       : out std_logic
    );
end Serializador;

architecture rtl of Serializador is
    type   state_t is (sIDLE, S7, S6, S5, S4, S3, S2, S1, S0, sDONE);
    signal state, next_state : state_t;
    signal data_reg : std_logic_vector(7 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                state <= sIDLE;
            else
                state <= next_state;
            end if;
        end if;
    end process;

    process(state, data_reg)
    begin
        serial_out <= '0';
        done       <= '0';
        case state is
            when sIDLE => null;
            when S7    => serial_out <= data_reg(7);
            when S6    => serial_out <= data_reg(6);
            when S5    => serial_out <= data_reg(5);
            when S4    => serial_out <= data_reg(4);
            when S3    => serial_out <= data_reg(3);
            when S2    => serial_out <= data_reg(2);
            when S1    => serial_out <= data_reg(1);
            when S0    => serial_out <= data_reg(0);
            when sDONE => done <= '1';
        end case;
    end process;

    process(state, start)
    begin
        case state is
            when sIDLE => if start = '1' then next_state <= S7; else next_state <= sIDLE; end if;
            when S7    => next_state <= S6;
            when S6    => next_state <= S5;
            when S5    => next_state <= S4;
            when S4    => next_state <= S3;
            when S3    => next_state <= S2;
            when S2    => next_state <= S1;
            when S1    => next_state <= S0;
            when S0    => next_state <= sDONE;
            when sDONE => next_state <= sIDLE;
        end case;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                data_reg <= (others => '0');
            elsif start = '1' then
                data_reg <= data_in;
            end if;
        end if;
    end process;
end rtl;
