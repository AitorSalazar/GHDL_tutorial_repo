----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.04.2024 15:35:55
-- Design Name: 
-- Module Name: tb_pwm - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;
--use ieee.std_logic_textio.all;  -- hread;
--use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values


-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_pwm is
--  Port ( );
end tb_pwm;

architecture Behavioral of tb_pwm is

component Block_PWM is
    Generic (G_RESOLUTION        : integer := 24;
                G_TRG_LENGTH     : integer := 200;
                G_UK_HIGH        : integer := 10;
                G_UK_LOW         : integer := 11
    );
    Port (CLK_IN        : in std_logic;
            RST_IN      : in std_logic;
            SYNC_IN     : in std_logic;
            UK_IN       : in sfixed (G_UK_HIGH downto -G_UK_LOW);
            PWM_OUT     : out std_logic;
            PWM_NOT_OUT : out std_logic
            );
end component;

constant CLK_IN_PERIOD  : time := 10 ns;
constant C_period_sync  : time := 1 ms;
----------------------------------------
constant C_uk_high      : integer := 10;
constant C_uk_low       : integer := 11;
constant C_trg_length   : integer := 200;
constant C_trg_res      : integer := 16;
----------------------------------------
signal clk, rst, sync   : std_logic := '0';
signal pwm, not_pwm     : std_logic := '0';
signal uk               : sfixed (C_uk_high downto -C_uk_low) := (others => '0');
signal saw              : sfixed (9 downto -1) := (others => '0');

begin

-- INICIO DE ARQUITECTURA 

Inst_PWM: Block_PWM
    generic map (G_RESOLUTION   => C_trg_res,
                 G_TRG_LENGTH   => C_trg_length,
                 G_UK_HIGH      => C_uk_high,
                 G_UK_LOW       => C_uk_low
                 )
    port map (CLK_IN    => clk,
              RST_IN    => rst,
              SYNC_IN   => sync,
              UK_IN     => uk,
              PWM_OUT   => pwm,
              PWM_NOT_OUT => not_pwm,
              SAW_OUT   => saw
              );

CLK_IN_process: process
begin
    while true loop
        clk <= '0';
        wait for CLK_IN_period/2;
        clk <= '1';
        wait for CLK_IN_period/2;
    end loop;
   end process;


Sync_process: process
begin
    while true loop
        sync <= '0';
        wait for C_period_sync/2;
        sync <= '1';
        wait for C_period_sync/2;
    end loop;
end process;
   

Test: process
begin
    rst <= '0';
    --sync <= '0';
    uk <= to_sfixed(0.0, C_uk_high, -C_uk_low);
    wait for 100 ms;
    
    uk <= to_sfixed(52.61, C_uk_high, -C_uk_low);
    --wait for 25 ns;
    --wait for 50 us;
    
    --sync <= '1';
    --wait for 10 us;
    --sync <= '0';
    wait;

end process;









end Behavioral;
