library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.NUMERIC_STD.all;
--use ieee.std_logic_arith.all;

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

constant    max_limit   : integer := 4194302;

--signal  cont    : integer   range 0 to max_limit;
signal  cont    : unsigned (bit_size - 1 downto 0) := (others => '0');
signal  max     : STD_LOGIC;
--signal  s_clk   : STD_LOGIC;

begin

MAX_OUT <= max;

CONTADOR: process (CLK)
begin
    --if rising_edge(s_clk) then    -----> HACE LO MISMO
    if CLK'event AND CLK = '1' then
        if cont > to_unsigned(max_limit, cont'length) then
            cont <= (others => '0');
            max <= '1';
        else
            cont <= cont + 1;
            max <= '0';
        end if;
    end if;
end process;

OUTPUT <= std_logic_vector(cont);

end Behavioral;
