library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu is
    Port (
        A, B   : in  STD_LOGIC_VECTOR(3 downto 0);
        op     : in  STD_LOGIC_VECTOR(1 downto 0);
        R      : out STD_LOGIC_VECTOR(7 downto 0);
        sign   : out STD_LOGIC;
        error  : out STD_LOGIC
    );
end alu;

architecture Structural of alu is
    -- Componentes
    component sum_sub
        Port (
            A   : in  STD_LOGIC_VECTOR(3 downto 0);
            B   : in  STD_LOGIC_VECTOR(3 downto 0);
            op  : in  STD_LOGIC_VECTOR(1 downto 0);
            R   : out STD_LOGIC_VECTOR(4 downto 0)
        );
    end component;

    component multiplicacion
        Port (
            A : in  STD_LOGIC_VECTOR(3 downto 0);
            B : in  STD_LOGIC_VECTOR(3 downto 0);
            P : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    -- Señales internas
    signal sumsub_res : STD_LOGIC_VECTOR(4 downto 0);
    signal mul_res    : STD_LOGIC_VECTOR(7 downto 0);

begin
    -- Instancias
    Usumsub: entity work.sum_sub port map(A => A, B => B, op => op, R => sumsub_res);
    Umul: entity work.multiplicacion port map(A => A, B => B, P => mul_res);

    -- El signo solo es relevante en la resta
    sign <= sumsub_res(4) when op="01" else '0';

    -- MUX de salida robusto para evitar latches
    with op select
        R <= "000" & sumsub_res when "00",      -- Suma
             "000" & sumsub_res when "01",      -- Resta
             mul_res            when "10",      -- Multiplicación
             (others => '0')    when others;   -- Valor por defecto para op="11"

    -- La señal de error no se usa en esta arquitectura
    error <= '0';

end Structural;