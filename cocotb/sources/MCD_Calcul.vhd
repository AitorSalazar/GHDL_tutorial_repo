library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
--use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mcd_calcul is
    Generic ( n             : integer :=8);

    Port ( A_IN, B_IN       : in STD_LOGIC_VECTOR (n - 1 downto 0);
           MCD_OUT          : out STD_LOGIC_VECTOR (n - 1 downto 0);
           CLK_IN           : in STD_LOGIC;
           RST_IN           : in STD_LOGIC;
           SEL_IN           : in STD_LOGIC;
           WR_A_IN          : in STD_LOGIC;
           WR_B_IN          : in STD_LOGIC;
           RESTA_IN         : in STD_LOGIC_VECTOR (n - 1 downto 0);
           RESTA_OUT        : out STD_LOGIC_VECTOR (n - 1 downto 0);
           CERO_OUT         : out STD_LOGIC;
           SIGNO_OUT        : out STD_LOGIC);
           
end mcd_calcul;

architecture Behavioral of mcd_calcul is

component bloq_register is
    generic ( n : integer := 8);
    
    port ( CLK_IN   : in STD_LOGIC;
           D_IN     : in STD_LOGIC_VECTOR (n - 1 downto 0);
           CE_IN    : in STD_LOGIC;
           RESET_IN : in STD_LOGIC;
           Q_OUT    : out STD_LOGIC_VECTOR (n - 1 downto 0));
end component;

constant vec_size   : integer :=8;

signal s_multiplex_b, s_multiplex_a           : STD_LOGIC_VECTOR (vec_size - 1 downto 0);
signal s_bb, s_aa                           : STD_LOGIC_VECTOR (vec_size - 1 downto 0):=(others=>'0');
signal s_sign                               : STD_LOGIC:= '0';

begin

Inst_Register_B: bloq_register port map(
    CLK_IN      => CLK_IN,
    D_IN        => s_multiplex_b,
    CE_IN       => WR_B_IN,
    RESET_IN    => RST_IN,
    Q_OUT       => s_bb );

Inst_Register_A: bloq_register port map(
    CLK_IN      => CLK_IN,
    D_IN        => s_multiplex_a,
    CE_IN       => WR_A_IN,
    RESET_IN    => RST_IN,
    Q_OUT       => s_aa );

Multiplex_b: process (B_IN, RESTA_IN, SEL_IN)
begin
    if SEL_IN = '0' then
        s_multiplex_b <= B_IN;
    else
        s_multiplex_b <= RESTA_IN;
    end if;
end process;

Multiplex_a: process (A_IN, RESTA_IN, SEL_IN)
begin
    if SEL_IN = '0' then
        s_multiplex_a <= A_IN;
    else
        s_multiplex_a <= RESTA_IN;
    end if;
end process;

Comparation: process (s_bb, s_aa)
begin

        if s_bb > s_aa then
            CERO_OUT <= '0';
            s_sign <= '0';
        
        elsif s_bb < s_aa then
            CERO_OUT <= '0';
            s_sign <= '1';
        elsif s_bb = s_aa then
            CERO_OUT <= '1';
            
         else
            report "Error comparing s_aa and s_bb";
        end if;
end process;

Subtraction: process (s_bb, s_aa, s_sign)
begin
    if s_sign = '0' then
        RESTA_OUT <= std_logic_vector(unsigned(s_bb) - unsigned(s_aa));
    else
        RESTA_OUT <= std_logic_vector(unsigned(s_aa) - unsigned(s_bb));
    end if;
end process;

SIGNO_OUT <= s_sign;
MCD_OUT <= s_aa;

end Behavioral;
