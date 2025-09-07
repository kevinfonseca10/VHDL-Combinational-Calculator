library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplicacion is
    Port (
        A : in  STD_LOGIC_VECTOR(3 downto 0);
        B : in  STD_LOGIC_VECTOR(3 downto 0);
        P : out STD_LOGIC_VECTOR(7 downto 0)
    );
end entity;

architecture Structural of multiplicacion is
    component adder4bit
        Port ( A: in STD_LOGIC_VECTOR(3 downto 0); B: in STD_LOGIC_VECTOR(3 downto 0); Cin: in STD_LOGIC; Sum: out STD_LOGIC_VECTOR(3 downto 0); Cout: out STD_LOGIC );
    end component;

    signal pp0, pp1, pp2, pp3 : STD_LOGIC_VECTOR(7 downto 0);
    signal s1, s2            : STD_LOGIC_VECTOR(7 downto 0);
    signal c1_low, c2_low, c3_low : STD_LOGIC;
begin
    pp0 <= "0000" & (A and (B(0)&B(0)&B(0)&B(0)));
    pp1 <= "000"  & (A and (B(1)&B(1)&B(1)&B(1))) & '0';
    pp2 <= "00"   & (A and (B(2)&B(2)&B(2)&B(2))) & "00";
    pp3 <= "0"    & (A and (B(3)&B(3)&B(3)&B(3))) & "000";

    U1_low:  entity work.adder4bit port map(A => pp0(3 downto 0), B => pp1(3 downto 0), Cin => '0',      Sum => s1(3 downto 0), Cout => c1_low);
    U1_high: entity work.adder4bit port map(A => pp0(7 downto 4), B => pp1(7 downto 4), Cin => c1_low,   Sum => s1(7 downto 4), Cout => open);
    U2_low:  entity work.adder4bit port map(A => s1(3 downto 0),  B => pp2(3 downto 0), Cin => '0',      Sum => s2(3 downto 0), Cout => c2_low);
    U2_high: entity work.adder4bit port map(A => s1(7 downto 4),  B => pp2(7 downto 4), Cin => c2_low,   Sum => s2(7 downto 4), Cout => open);
    U3_low:  entity work.adder4bit port map(A => s2(3 downto 0),  B => pp3(3 downto 0), Cin => '0',      Sum => P(3 downto 0),  Cout => c3_low);
    U3_high: entity work.adder4bit port map(A => s2(7 downto 4),  B => pp3(7 downto 4), Cin => c3_low,   Sum => P(7 downto 4),  Cout => open);
end Structural;