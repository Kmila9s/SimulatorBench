library ieee;
use ieee.std_logic_1164.all;

entity jk_flip_flop is
    port (
        j   : in  std_logic;
        k   : in  std_logic;
        clk : in  std_logic;
        q   : out std_logic;
        nq  : out std_logic
    );
end jk_flip_flop;

architecture rtl of jk_flip_flop is
    signal jk    : std_logic_vector(1 downto 0);
    signal state : std_logic := '0';
begin
    -- Independent encoding: pack (j, k) into a 2-bit vector so the
    -- transition table is a clean `case` (mirrors the reference's
    -- j_k(0) <= k; j_k(1) <= j; … pattern but stays in one process).
    jk(1) <= j;
    jk(0) <= k;
    q     <= state;
    nq    <= not state;

    process(clk)
    begin
        if rising_edge(clk) then
            case jk is
                when "00" => null;
                when "01" => state <= '0';
                when "10" => state <= '1';
                when "11" => state <= not state;
                when others => null;
            end case;
        end if;
    end process;
end rtl;
