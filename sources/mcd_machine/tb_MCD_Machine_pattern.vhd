library IEEE;
--library vunit_lib;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
--context vunit_lib.vunit_context;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_MCD_Machine is
    --generic(runner_cfg : string);
end tb_MCD_Machine;

architecture Behavioral of tb_MCD_Machine is

component MCD_Machine is
    Generic ( n     : integer := 8);

    Port ( A_IN         : in STD_LOGIC_VECTOR (n - 1 downto 0);
           B_IN         : in STD_LOGIC_VECTOR (n - 1 downto 0);
           ENTER_IN     : in STD_LOGIC;
           RESET_IN     : in STD_LOGIC;
           CLK          : in STD_LOGIC;
           MCD_OUT      : out STD_LOGIC_VECTOR (n - 1 downto 0);
           FIN_OUT      : out STD_LOGIC);
end component;

constant    mcd_n   : integer := 8;
constant    test_numbs : integer := 5;
constant    clk_period : time := 10 ns;

type T_PATTERN is array (test_numbs - 1 downto 0) of STD_LOGIC_VECTOR (mcd_n - 1 downto 0);
constant pattern_a : T_PATTERN := (x"69", x"38", x"4b", x"70", x"54");
constant pattern_b : T_PATTERN := (x"3f", x"0e", x"34", x"2c", x"6a");
constant pattern_res : T_PATTERN := (x"15", x"0e", x"01", x"04", x"02");

signal      a, b, mcd           : STD_LOGIC_VECTOR (mcd_n - 1 downto 0) := x"00";
signal      enter, reset, clkk  : STD_LOGIC;
signal      fin                 : STD_LOGIC;

begin

UUT: MCD_Machine port map (
    A_IN         => a,
    B_IN         => b,
    ENTER_IN     => enter,
    RESET_IN     => reset,
    CLK          => clkk,
    MCD_OUT      => mcd,
    FIN_OUT      => fin);

sim_clk: process
begin
    while true loop
        clkk <= '0';
        wait for clk_period/2;
        clkk <= '1';
        wait for clk_period/2;
    end loop;
end process;

TestBench: process
begin
    --test_runner_setup(runner, runner_cfg);

    -- Initial values
    a <= x"00";
    b <= x"00";
    enter <= '0';
    reset <= '0';
    wait for 100 ms;

    for i in test_numbs - 1 downto 0 loop
        -- Enter a
        a <= pattern_a(i);
        enter <= '1';
        wait for 10 ms;
        enter <= '0';
        wait for 10 ms;
        -- Enter b
        b <= pattern_b(i);
        enter <= '1';
        wait for 10 ms;
        enter <= '0';
        wait for 10 ms;

        -- Check results
        assert mcd = pattern_res(i)
            report "wrong mcd value" severity warning;
    end loop;

    wait;
    --test_runner_cleanup(runner);
end process;

end Behavioral;
