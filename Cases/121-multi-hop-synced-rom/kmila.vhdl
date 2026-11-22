library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Single-file mirror of what SourceElaborator emits when flattening
-- top -> { U_ROM, U_CPU } where the parent connects them through a
-- shared signal `rom_data_w`. The ROM is a synchronous-read process
-- (writes U_ROM__data_out conditionally on enable + rising_edge), and
-- the CPU samples its input port through a small fetch FSM that issues
-- the address one cycle and reads the alias-chain'ed value one cycle
-- later. Engineered to hit the §5.4 multi-hop convergence failure mode
-- without requiring the elaborator.
entity multi_hop_synced_rom is
    port (
        clk     : in  std_logic;
        reset   : in  std_logic;
        start   : in  std_logic;
        done    : out std_logic;
        acc_out : out std_logic_vector(7 downto 0)
    );
end multi_hop_synced_rom;

architecture rtl of multi_hop_synced_rom is
    type state_t is (S_FETCH_ADDR, S_FETCH_WAIT, S_FETCH_SAMPLE, S_DONE);
    signal state    : state_t := S_FETCH_ADDR;
    signal acc_reg  : std_logic_vector(7 downto 0) := (others => '0');

    -- ROM control + data path mirroring elaborator-emitted aliases:
    signal rom_addr        : std_logic_vector(7 downto 0) := (others => '0');
    signal rom_enable      : std_logic := '0';
    signal u_rom_data_out  : std_logic_vector(7 downto 0) := (others => '0');
    signal rom_data_w      : std_logic_vector(7 downto 0);
    signal u_cpu_rom_data  : std_logic_vector(7 downto 0);

    type rom_t is array (0 to 7) of std_logic_vector(7 downto 0);
    constant rom_init : rom_t := (
        "10101010", "10111011", "11001100", "11011101",
        "00010001", "00100010", "00110011", "01000100"
    );
begin
    -- ROM: synchronous read, conditional on enable.
    process(clk, reset)
    begin
        if reset = '1' then
            u_rom_data_out <= (others => '0');
        elsif rising_edge(clk) then
            if rom_enable = '1' then
                u_rom_data_out <= rom_init(to_integer(unsigned(rom_addr)));
            end if;
        end if;
    end process;

    -- Two concurrent alias hops (parent wire + CPU input alias).
    rom_data_w     <= u_rom_data_out;
    u_cpu_rom_data <= rom_data_w;

    -- CPU: fetch FSM that issues addr, waits one cycle for sync ROM,
    -- then samples the alias chain into acc_reg.
    process(clk, reset)
    begin
        if reset = '1' then
            state      <= S_FETCH_ADDR;
            acc_reg    <= (others => '0');
            rom_addr   <= (others => '0');
            rom_enable <= '0';
        elsif rising_edge(clk) then
            case state is
                when S_FETCH_ADDR =>
                    if start = '1' then
                        rom_addr   <= "00000011";
                        rom_enable <= '1';
                        state      <= S_FETCH_WAIT;
                    end if;
                when S_FETCH_WAIT =>
                    state <= S_FETCH_SAMPLE;
                when S_FETCH_SAMPLE =>
                    acc_reg    <= u_cpu_rom_data;
                    rom_enable <= '0';
                    state      <= S_DONE;
                when S_DONE =>
                    state <= S_DONE;
            end case;
        end if;
    end process;

    acc_out <= acc_reg;
    done    <= '1' when state = S_DONE else '0';
end rtl;
