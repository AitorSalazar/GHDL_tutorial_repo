library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MCD_Control is
    Port ( CLK_IN                       : in STD_LOGIC;
           RESET                        : in STD_LOGIC;
           ENTER                        : in STD_LOGIC;
           ZERO_IN, SIGN_IN             : in STD_LOGIC;
           WRA_OUT, WRB_OUT, SEL_OUT    : out STD_LOGIC;
           FIN_OUT                      : out STD_LOGIC);
end MCD_Control;

architecture Behavioral of MCD_Control is

type        maq_states is (wr_a, enter_a, wr_b, enter_b, opera, aa, bb, res_show, res_restart);
signal      state               : maq_states;
signal      clk, rst            : STD_LOGIC;

begin

clk <= CLK_IN;
rst <= RESET;

State_navigation: process (rst, clk)

begin
    if rst = '1' then
        state <= wr_a;
    elsif (clk'event AND clk = '1') then
        case state is
            when wr_a =>
                if enter = '1' then
                    state <= enter_a;
                else
                    state <= wr_a;
                end if;
            when enter_a =>
                if enter = '0' then
                    state <= wr_b;
                else
                    state <= enter_a;
                end if;
            when wr_b =>
                if enter = '1' then
                    state <= enter_b;
                else
                    state <= wr_b;
                end if;
            when enter_b =>
                if enter = '0' then
                    state <= opera;
                else
                    state <= enter_b;
                end if;
            when opera =>
                if ZERO_IN = '0' AND SIGN_IN = '1' then
                    state <= aa;
                elsif ZERO_IN = '0' AND SIGN_IN = '0' then
                    state <= bb;
                elsif ZERO_IN = '1' then
                    state <= res_show;
                end if;
            when aa =>
                -- procesos
                state <= opera;
            when bb =>
                -- procesos
                state <= opera;
            when res_show =>
                -- mierda del multiplexor para los leds
                if ENTER = '1' then
                    state <= res_restart;
                else
                    state <= res_show;
                end if;
            when res_restart =>
                if ENTER = '0' then
                    state <= wr_a;
                else
                    state <= res_restart;
                end if;
        end case;
    end if;
end process;

with state select
    WRA_OUT     <= '1' when enter_a,
                   '1' when aa,
                   '0' when others;
with state select
    WRB_OUT     <= '1' when enter_b,
                   '1' when bb,
                   '0' when others;
with state select
    SEL_OUT     <= '1' when bb,
                   '1' when aa,
                   '0' when others;
with state select
    FIN_OUT     <= '1' when res_show,
                   '0' when others;

end Behavioral;
