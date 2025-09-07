library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sum_sub is
    Port (
        A   : in  STD_LOGIC_VECTOR(3 downto 0);
        B   : in  STD_LOGIC_VECTOR(3 downto 0);
        op  : in  STD_LOGIC_VECTOR(1 downto 0);
        R   : out STD_LOGIC_VECTOR(4 downto 0)
    );
end entity;

architecture structural of sum_sub is

    component full_adder
        port( a: in STD_LOGIC; b: in STD_LOGIC; cin: in STD_LOGIC; sum: out STD_LOGIC; cout: out STD_LOGIC );
    end component;

    component adder4bit
        port( A: in STD_LOGIC_VECTOR(3 downto 0); B: in STD_LOGIC_VECTOR(3 downto 0); Cin: in STD_LOGIC; Sum: out STD_LOGIC_VECTOR(3 downto 0); Cout: out STD_LOGIC );
    end component;

    -- Señales internas
    signal B_mod : STD_LOGIC_VECTOR(3 downto 0);
    signal C     : STD_LOGIC_VECTOR(4 downto 0);
    signal S     : STD_LOGIC_VECTOR(3 downto 0);
    signal sel_sum, sel_sub : STD_LOGIC;
    signal gt9, need_corr, need_corr_s : STD_LOGIC;
    signal S_plus6     : STD_LOGIC_VECTOR(3 downto 0);
    signal units_sum   : STD_LOGIC_VECTOR(3 downto 0);
    signal tens_sum    : STD_LOGIC;
    signal neg_sub     : STD_LOGIC;
    signal S_not       : STD_LOGIC_VECTOR(3 downto 0);
    signal absS        : STD_LOGIC_VECTOR(3 downto 0);
    signal units_sub   : STD_LOGIC_VECTOR(3 downto 0);

begin
    -- Selección de operación
    sel_sum <= '1' when op = "00" else '0';
    sel_sub <= '1' when op = "01" else '0';

    -- Sumador/Restador unificado
    B_mod <= B xor (op(0) & op(0) & op(0) & op(0));
    C(0) <= op(0);
    FA0: entity work.full_adder port map(a => A(0), b => B_mod(0), cin => C(0), sum => S(0), cout => C(1));
    FA1: entity work.full_adder port map(a => A(1), b => B_mod(1), cin => C(1), sum => S(1), cout => C(2));
    FA2: entity work.full_adder port map(a => A(2), b => B_mod(2), cin => C(2), sum => S(2), cout => C(3));
    FA3: entity work.full_adder port map(a => A(3), b => B_mod(3), cin => C(3), sum => S(3), cout => C(4));

    -- Lógica de Suma BCD
    gt9 <= S(3) and (S(2) or S(1));
    need_corr <= C(4) or gt9;
    need_corr_s <= sel_sum and need_corr;
    U_ADD6: entity work.adder4bit port map( A => S, B => "0110", Cin => '0', Sum => S_plus6, Cout => open );
    units_sum <= S_plus6 when need_corr_s = '1' else S;
    tens_sum <= need_corr_s;

    -- Lógica de Resta (Valor Absoluto)
    neg_sub <= sel_sub and (not C(4));
    S_not <= not S;
    U_ABS: entity work.adder4bit port map( A => S_not, B => "0000", Cin => '1', Sum => absS, Cout => open );
    units_sub <= absS when neg_sub = '1' else S;

    -- Salida final segura (evita latches)
    R <= (tens_sum & units_sum) when sel_sum = '1' else
         (neg_sub & units_sub) when sel_sub = '1' else
         (others => '0'); -- Valor por defecto para op="10" y "11"

end architecture;