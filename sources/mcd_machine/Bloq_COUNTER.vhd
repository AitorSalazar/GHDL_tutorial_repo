library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Bloq_COUNTER is
    Generic ( bit_size  : integer:= 22);
    
    Port ( CLK      : in STD_LOGIC;
           OUTPUT   : out STD_LOGIC_VECTOR (bit_size - 1 downto 0);
           MAX_OUT  : out STD_LOGIC);
end Bloq_COUNTER;

architecture Behavioral of Bloq_COUNTER is

constant    max_limit   : integer := 4194304;

signal  cont    : integer   range 0 to max_limit;
signal  max     : STD_LOGIC;
--signal  s_clk   : STD_LOGIC;

begin

--Proceso_CLOCK: process
--begin
--    while true loop
--        s_clk <= '0';
--        wait for 5 ns;
--        s_clk <= '1';
--        wait for 5 ns;
--    end loop;
--end process;

--CLK <= s_clk;
MAX_OUT <= max;

CONTADOR: process (CLK)
begin
    --if rising_edge(s_clk) then    -----> HACE LO MISMO
    if CLK'event AND CLK = '1' then
        if cont = max_limit then
            cont <= 0;      -- Variables NO son señales, van sin comillas
            max <= '1';
        else
            cont <= cont + 1;
            max <= '0';
        end if;
    end if;
end process;

OUTPUT <= conv_std_logic_vector(cont, bit_size);

end Behavioral;
