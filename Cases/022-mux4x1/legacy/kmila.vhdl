library ieee;
use ieee.std_logic_1164.all;

entity mux4x1 is
    port (
        a   : in  std_logic;
        b   : in  std_logic;
        c   : in  std_logic;
        d   : in  std_logic;
        sel : in  std_logic_vector(1 downto 0);
        o   : out std_logic
    );
end mux4x1;

architecture rtl of mux4x1 is
begin
    with sel select
        o <= a when "00",
             b when "01",
             c when "10",
             d when "11",
             '0' when others;
end rtl;
