library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MCD_Machine is
    Generic ( n     : integer := 8);

    Port ( A_IN         : in STD_LOGIC_VECTOR (n - 1 downto 0);
           B_IN         : in STD_LOGIC_VECTOR (n - 1 downto 0);
           ENTER_IN     : in STD_LOGIC;
           RESET_IN     : in STD_LOGIC;
           CLK          : in STD_LOGIC;
           MCD_OUT      : out STD_LOGIC_VECTOR (n - 1 downto 0);
           FIN_OUT      : out STD_LOGIC);
end MCD_Machine;

architecture Behavioral of MCD_Machine is

component MCD_Control is
    port ( CLK_IN                       : in STD_LOGIC;
           RESET                        : in STD_LOGIC;
           ENTER                        : in STD_LOGIC;
           ZERO_IN, SIGN_IN             : in STD_LOGIC;
           WRA_OUT, WRB_OUT, SEL_OUT    : out STD_LOGIC;
           FIN_OUT                      : out STD_LOGIC);
end component;

component MCD_Calcul is
    port ( A_IN, B_IN       : in STD_LOGIC_VECTOR (n - 1 downto 0);
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
end component;

component Bloq_REGISTER is
    generic ( n     : integer:=8 );

    port ( CLK_IN   : in STD_LOGIC;
           D_IN     : in STD_LOGIC_VECTOR (n - 1 downto 0);
           CE_IN    : in STD_LOGIC;
           RESET_IN : in STD_LOGIC;
           Q_OUT    : out STD_LOGIC_VECTOR (n - 1 downto 0));
end component;

component Bloq_COUNTER is
    generic ( bit_size  : integer:= 22);
    
    port ( CLK      : in STD_LOGIC;
          -- OUTPUT   : out STD_LOGIC_VECTOR (bit_size - 1 downto 0);
           MAX_OUT  : out STD_LOGIC);
end component;


signal      s_zero, s_sign                  : STD_LOGIC:='0';
signal      wra, wrb, sel                   : STD_LOGIC:='0';
signal      resta                           : STD_LOGIC_VECTOR (n - 1 downto 0):=(others=>'0');
signal      counter                         : STD_LOGIC:='0';
signal      enter_reg, reset_reg            : STD_LOGIC:='0';
signal      enter_inter, reset_inter        : STD_LOGIC:='0';

begin

Inst_Control_Unit: MCD_Control port map(
    CLK_IN      => CLK,
    RESET       => RESET_IN,
    ENTER       => ENTER_IN,
    ZERO_IN     => s_zero,
    SIGN_IN     => s_sign,
    WRA_OUT     => wra,
    WRB_OUT     => wrb,
    SEL_OUT     => sel,
    FIN_OUT     => FIN_OUT);

Inst_Calcul_Unit: MCD_Calcul port map(
    A_IN        => A_IN,
    B_IN        => B_IN,
    MCD_OUT     => MCD_OUT,
    CLK_IN      => CLK,
    RST_IN      => RESET_IN,
    SEL_IN      => sel,
    WR_A_IN     => wra,
    WR_B_IN     => wrb,
    RESTA_IN    => resta,
    RESTA_OUT   => resta,
    CERO_OUT    =>  s_zero,
    SIGNO_OUT   => s_sign);

ENTER_Reg_1: Bloq_REGISTER 
    generic map ( n => 1 )
    port map(
    CLK_IN      => CLK,
    D_IN(0)     => ENTER_IN,
    CE_IN       => counter,
    RESET_IN    => '0',
    Q_OUT(0)    => enter_inter);

ENTER_Reg_2: Bloq_REGISTER 
    generic map ( n => 1 )
    port map(
    CLK_IN      => CLK,
    D_IN(0)     => enter_inter,
    CE_IN       => counter,
    RESET_IN    => '0',
    Q_OUT(0)    => enter_reg);

RESET_Reg_1: Bloq_REGISTER 
    generic map ( n => 1 )
    port map(
    CLK_IN      => CLK,
    D_IN(0)     => RESET_IN,
    CE_IN       => counter,
    RESET_IN    => '0',
    Q_OUT(0)    => reset_inter);

RESET_Reg_2: Bloq_REGISTER 
    generic map ( n => 1 )
    port map(
    CLK_IN      => CLK,
    D_IN(0)     => reset_inter,
    CE_IN       => counter,
    RESET_IN    => '0',
    Q_OUT(0)    => reset_reg);

TC_Counter: Bloq_COUNTER port map(
    CLK         => CLK,
   -- OUTPUT      => open,
    MAX_OUT     => counter);



end Behavioral;
