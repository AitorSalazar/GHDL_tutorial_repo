----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2024 16:06:49
-- Design Name: 
-- Module Name: Test_PWM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Block_PWM is
  Generic (G_RESOLUTION     : integer := 24;
           G_TRG_LENGTH     : integer := 200;
           G_UK_HIGH        : integer := 10;
           G_UK_LOW         : integer := 11
  );
  Port (CLK_IN      : in std_logic;
        RST_IN      : in std_logic;
        SYNC_IN     : in std_logic;
        UK_IN       : in sfixed (G_UK_HIGH downto -G_UK_LOW);
        PWM_OUT     : out std_logic;
        PWM_NOT_OUT : out std_logic
        );
end Block_PWM;

architecture Behavioral of Block_PWM is

--constant C_res : unsigned (4 downto 0) := "10000"; -- en realidad es 24
constant C_res : unsigned (4 downto 0) := to_unsigned(G_RESOLUTION, C_res'length);
--constant C_minus_200    : signed (9 downto 0) := "1100111000"; -- -200
constant C_minus_length    : signed (9 downto 0) := to_signed(-G_TRG_LENGTH, C_minus_length'length);
constant C_plus_length     : signed (9 downto 0) := to_signed(G_TRG_LENGTH - 2, C_plus_length'length);
---------------------------
signal uk           : sfixed (G_UK_HIGH downto -G_UK_LOW) := (others => '0');
signal saw          : sfixed (9 downto -1) := (others => '0');
signal pwm          : std_logic := '0';
---------------------------
signal clk_cont     : unsigned (4 downto 0) := (others => '0');
signal trg_cont     : signed (9 downto 0) := C_minus_200; -- -200
---------------------------
signal sync_reg     : std_logic := '0';

begin

-- Proceso para registrar entrada
process(CLK_IN)
begin
    if rising_edge(CLK_IN) then
        sync_reg <= SYNC_IN;
        if RST_IN = '1' then
            uk <= (others => '0');
        else
            if (SYNC_IN = '1' and sync_reg = '0') then
                uk <= UK_IN;
            end if;
        end if;
    end if;
end process;

-- Generar triangulo
process(CLK_IN)
begin
    if rising_edge(CLK_IN) then
        if RST_IN = '1' then
            saw <= (others => '0');
        else
            if clk_cont >= C_res then -- si es mayor que 25
                clk_cont <= (others => '0');
                if trg_cont > C_plus_length then
                    trg_cont <= C_minus_length;
                else
                    trg_cont <= trg_cont + 1;
                end if;
                --saw <= to_sfixed(trg_cont, 9, -1);
            else
                clk_cont <= clk_cont + 1;
            end if;
            saw <= to_sfixed(trg_cont, 9, -1);
        end if;
    end if;
end process;

pwm <= '1' when UK_IN >= saw else '0';

PWM_OUT <= pwm;
PWM_NOT_OUT <= not(pwm);

end Behavioral;
