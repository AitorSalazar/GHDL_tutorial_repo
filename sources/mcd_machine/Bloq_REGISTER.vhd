----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.11.2023 13:24:31
-- Design Name: 
-- Module Name: Bloq_REGISTER - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Bloq_REGISTER is
    Generic ( n    : integer :=8);
    
    Port ( CLK_IN   : in STD_LOGIC;
           D_IN     : in STD_LOGIC_VECTOR (n - 1 downto 0);
           CE_IN    : in STD_LOGIC;
           RESET_IN : in STD_LOGIC;
           Q_OUT    : out STD_LOGIC_VECTOR (n - 1 downto 0));
end Bloq_REGISTER;

architecture Behavioral of Bloq_REGISTER is

constant    n_size : integer := n;
signal  q_reg   : STD_LOGIC_VECTOR (n_size - 1 downto 0):=(others=>'0');

begin

process (CLK_IN, RESET_IN)
begin
    if (CLK_IN'event AND CLK_IN = '1') then
        if RESET_IN = '1' then
            q_reg <= (others => '0');
        else 
            if CE_IN = '1' then
                q_reg <= D_IN;
            end if;
        end if;
    end if;
end process;

Q_OUT <= q_reg;

end Behavioral;
