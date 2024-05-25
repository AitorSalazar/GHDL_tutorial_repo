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
library vunit_lib;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.fixed_float_types.all;
use ieee.fixed_pkg.all;
context vunit_lib.vunit_context;

entity tb_pwm is
    generic(runner_cfg : string);
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
constant C_trg_res      : integer := 19;
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
    test_runner_setup(runner, runner_cfg);
    rst <= '0';
    uk <= to_sfixed(0.0, C_uk_high, -C_uk_low);
    wait for 100 ms;
    
    uk <= to_sfixed(150.0, C_uk_high, -C_uk_low);
    wait for 40 ns;
    uk <= to_sfixed(120.0, C_uk_high, -C_uk_low);
    wait for 50 ns;
    uk <= to_sfixed(90.0, C_uk_high, -C_uk_low);
    wait for 60 ns;
    uk <= to_sfixed(60.0, C_uk_high, -C_uk_low);
    wait for 70 ns;
    uk <= to_sfixed(30.0, C_uk_high, -C_uk_low);
    wait for 80 ns;
    uk <= to_sfixed(10.0, C_uk_high, -C_uk_low);

    wait;
    test_runner_cleanup(runner);
end process;

end Behavioral;
