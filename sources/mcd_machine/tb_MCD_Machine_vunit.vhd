library IEEE;
library vunit_lib;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_TEXTIO.ALL;
context vunit_lib.vunit_context;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_MCD_Machine_vunit is
    generic(runner_cfg : string);
end tb_MCD_Machine_vunit;

architecture Behavioral of tb_MCD_Machine_vunit is

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
--constant pattern_a : T_PATTERN := (x"69", x"38", x"4b", x"70", x"54");
constant pattern_a : T_PATTERN := ("01101001", "00111000", "01001011", "01110000", "01010100");
--constant pattern_b : T_PATTERN := (x"3f", x"0e", x"34", x"2c", x"6a");
constant pattern_b : T_PATTERN := ("00111111", "00001110", "00110100", "00101100", "01101010");
constant pattern_res : T_PATTERN := ("00010101", "00001110", "00000001", "00000100", "00000010");

signal      a, b, mcd           : STD_LOGIC_VECTOR (mcd_n - 1 downto 0) := (others => '0');
signal      enter, reset, clkk  : STD_LOGIC := '0';
signal      fin                 : STD_LOGIC := '0';
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
    variable vector_str : string(1 to 8);
begin

    test_runner_setup(runner, runner_cfg);
    -- Initial values
    --a <= x"00";
    a <= "00000000";
    --b <= x"00";
    b <= "00000000";
    enter <= '0';
    reset <= '0';
    wait for 0.5 ms;

    for i in test_numbs - 1 downto 0 loop
        -- Enter a
        a <= pattern_a(i);
        enter <= '1';
        wait for 0.10 ms;
        enter <= '0';
        wait for 0.10 ms;
        -- Enter b
        a <= "00000000";
        b <= pattern_b(i);
        enter <= '1';
        wait for 0.10 ms;
        enter <= '0';
        wait for 0.10 ms;
        b <= "00000000";
        wait for 1 ms;
        
        vector_str := to_string(mcd);
        report "The value of my_vector is: " & vector_str;
        -- Para iniciar la siguiente operacion
        enter <= '1';
        wait for 0.10 ms;
        enter <= '0';
        wait for 0.10 ms;
        -- Check results

        assert mcd = pattern_res(i)
            report "wrong mcd value" severity warning;
           -- report "The value of my_vector is: " & vector_str;
           -- report "slv: " & mcd;
        --    report "" & std_logic_vector'image(pattern_res(i));
    end loop;

    --wait;
    test_runner_cleanup(runner);
end process;

end Behavioral;
