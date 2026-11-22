library ieee;
use ieee.std_logic_1164.all;

entity tb_multiarg_fn is
end tb_multiarg_fn;

architecture Behavioral of tb_multiarg_fn is
    component multiarg_fn
        port (
            rst : in  std_logic;
            clk : in  std_logic;
            q   : out std_logic_vector(3 downto 0)
        );
    end component;

    signal clk_s : std_logic := '0';
    signal rst_s : std_logic := '0';
    signal q_s   : std_logic_vector(3 downto 0);
    signal done  : std_logic := '0';
begin
    uut : multiarg_fn port map (rst => rst_s, clk => clk_s, q => q_s);

    clk_gen : process
    begin
        while done = '0' loop
            clk_s <= not clk_s;
            wait for 10 ns;
        end loop;
        wait;
    end process;

    stim : process
    begin
        rst_s <= '0';
        wait for 25 ns;
        rst_s <= '1';
        wait for 200 ns;
        done <= '1';
        wait;
    end process;
end Behavioral;
