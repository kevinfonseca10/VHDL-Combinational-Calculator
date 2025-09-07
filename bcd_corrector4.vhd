library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcd_corrector4 is
  port(
    S_in      : in  STD_LOGIC_VECTOR(3 downto 0);
    C4_in     : in  STD_LOGIC;
    tens_bcd  : out STD_LOGIC_VECTOR(3 downto 0);
    units_bcd : out STD_LOGIC_VECTOR(3 downto 0)
  );
end entity bcd_corrector4;

architecture structural of bcd_corrector4 is
  component adder4bit
    port( A: in STD_LOGIC_VECTOR(3 downto 0); B: in STD_LOGIC_VECTOR(3 downto 0); Cin: in STD_LOGIC; Sum: out STD_LOGIC_VECTOR(3 downto 0); Cout: out STD_LOGIC );
  end component;

  signal need_corr    : STD_LOGIC;
  signal n_need_corr  : STD_LOGIC;
  signal plus6        : STD_LOGIC_VECTOR(3 downto 0);
begin
  need_corr    <= C4_in or ( S_in(3) and ( S_in(2) or S_in(1) ) );
  n_need_corr  <= not need_corr;

  U_ADD6: entity work.adder4bit
    port map ( A => S_in, B => "0110", Cin => '0', Sum => plus6, Cout => open );

  units_bcd <= plus6 when need_corr = '1' else S_in;

  tens_bcd <= "000" & need_corr;
end architecture structural;