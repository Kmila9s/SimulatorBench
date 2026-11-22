library ieee;
use ieee.std_logic_1164.all;

entity demorgan is
    port (
        c      : in  std_logic;
        b      : in  std_logic;
        a      : in  std_logic;
        f_org  : out std_logic;
        f_nand : out std_logic;
        f_nor  : out std_logic
    );
end demorgan;

architecture rtl of demorgan is
begin
    f_org  <= (not (c and b)) or ((not b) and a);
    f_nand <= not ((c and b) and (not ((not b) and a)));
    f_nor  <= ((not c) or (not b)) or (not (b or (not a)));
end rtl;
