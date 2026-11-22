library ieee;
use ieee.std_logic_1164.all;

entity full_adder is
    port (
        a, b : in  std_logic;
        cin  : in  std_logic;
        s    : out std_logic;
        cout : out std_logic
    );
end full_adder;

architecture rtl of full_adder is
    signal m : std_logic;
begin
    m    <= a xor b;
    s    <= m xor cin;
    cout <= (a and b) or (cin and m);
end rtl;
