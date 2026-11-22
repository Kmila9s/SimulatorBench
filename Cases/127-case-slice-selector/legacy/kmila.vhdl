library ieee;
use ieee.std_logic_1164.all;

entity case_slice_selector is
    port (
        clk     : in  std_logic;
        word    : in  std_logic_vector(23 downto 0);
        out_reg : out std_logic_vector(7 downto 0)
    );
end case_slice_selector;

architecture rtl of case_slice_selector is
    constant OP_LOAD : std_logic_vector(7 downto 0) := x"0B";
    constant OP_ADDI : std_logic_vector(7 downto 0) := x"07";
    constant OP_MOV  : std_logic_vector(7 downto 0) := x"0C";
    constant OP_HALT : std_logic_vector(7 downto 0) := x"0F";

    signal latched : std_logic_vector(7 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            case word(23 downto 16) is
                when OP_LOAD => latched <= "00010001";
                when OP_ADDI => latched <= "00100010";
                when OP_MOV  => latched <= "00110011";
                when OP_HALT => latched <= "01000100";
                when others  => latched <= "11111111";
            end case;
        end if;
    end process;

    out_reg <= latched;
end rtl;
