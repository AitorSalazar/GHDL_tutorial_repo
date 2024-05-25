library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_MCD_Machine is
--  Port ( );
end tb_MCD_Machine;

architecture Behavioral of tb_MCD_Machine is

component MCD_Machine is
    Generic ( n     : integer := 8);

    Port ( A_IN         : in STD_LOGIC_VECTOR (n - 1 downto 0);
           B_IN         : in STD_LOGIC_VECTOR (n - 1 downto 0);
           ENTER_IN     : in STD_LOGIC;
           RESET_IN     : in STD_LOGIC;
           CLK          : in STD_LOGIC;
           MCD_OUT      : out STD_LOGIC_VECTOR (n - 1 downto 0));
end component;

constant    mcd_n   : integer := 8;
constant    clk_period : time := 10 ns;

signal      a, b, mcd           : STD_LOGIC_VECTOR (mcd_n - 1 downto 0);
signal      enter, reset, clkk  : STD_LOGIC;


begin

UUT: MCD_Machine port map (
    A_IN         => a,
    B_IN         => b,
    ENTER_IN     => enter,
    RESET_IN     => reset,
    CLK          => clkk,
    MCD_OUT      => mcd);

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

    -- Initial values
    a <= x"00";
    enter <= '0';
    reset <= '0';
    wait for 100 ms;
    -- Enter values
    a <= x"69"; -- 105
    enter <= '1';
    wait for 10 ms;
    enter <= '0';
    wait for 10 ms;
    --a <= "00000000";

    b <= x"3f"; -- 63
    wait for 20 ms;
    enter <= '1';
    wait for 10 ms;
    enter <= '0';
    wait for 10 ms;
    --b <= "00000000";
    wait;














end process;

end Behavioral;
