library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity adder4bit is
    Port (
        A    : in  STD_LOGIC_VECTOR(3 downto 0);
        B    : in  STD_LOGIC_VECTOR(3 downto 0);
        Cin  : in  STD_LOGIC;
        Sum  : out STD_LOGIC_VECTOR(3 downto 0);
        Cout : out STD_LOGIC
    );
end entity adder4bit;

architecture Structural of adder4bit is
    signal C : STD_LOGIC_VECTOR(3 downto 0);
begin
    FA0: entity work.full_adder
        port map( a => A(0), b => B(0), cin => Cin,  sum => Sum(0), cout => C(0) );

    FA1: entity work.full_adder
        port map( a => A(1), b => B(1), cin => C(0), sum => Sum(1), cout => C(1) );

    FA2: entity work.full_adder
        port map( a => A(2), b => B(2), cin => C(1), sum => Sum(2), cout => C(2) );

    FA3: entity work.full_adder
        port map( a => A(3), b => B(3), cin => C(2), sum => Sum(3), cout => Cout );
end architecture Structural;