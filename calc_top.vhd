library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity calc_top is
    Port (
        SW    : in  STD_LOGIC_VECTOR(9 downto 0);
        HEX0  : out STD_LOGIC_VECTOR(6 downto 0);
        HEX1  : out STD_LOGIC_VECTOR(6 downto 0);
        HEX2  : out STD_LOGIC_VECTOR(6 downto 0);
        HEX3  : out STD_LOGIC_VECTOR(6 downto 0)
    );
end calc_top;

architecture Structural of calc_top is
    -- Entradas decodificadas desde los switches
    signal A, B          : STD_LOGIC_VECTOR(3 downto 0);
    signal op            : STD_LOGIC_VECTOR(1 downto 0);

    -- Señales de la ALU
    signal R             : STD_LOGIC_VECTOR(7 downto 0);
    signal sign          : STD_LOGIC;

    -- Protección de entrada (A/B válidos en BCD 0..9)
    signal input_error   : STD_LOGIC;

    -- Señales para 7 segmentos
    signal seg_sum_hi, seg_sum_lo : STD_LOGIC_VECTOR(6 downto 0);
    signal seg_sub_hi, seg_sub_lo : STD_LOGIC_VECTOR(6 downto 0);
    signal seg_mul_hi, seg_mul_lo : STD_LOGIC_VECTOR(6 downto 0);
    signal seg_zero               : STD_LOGIC_VECTOR(6 downto 0);

    signal HEX1_calc, HEX0_calc   : STD_LOGIC_VECTOR(6 downto 0);

    -- Conversión binaria->BCD (multiplicación)
    signal mul_bcd_hi, mul_bcd_lo : STD_LOGIC_VECTOR(3 downto 0);

    -- Evita el error de "globally static" en ModelSim: usa señales/constantes en port map
    signal   sum_hi_bcd : STD_LOGIC_VECTOR(3 downto 0);
    constant BCD_ZERO   : STD_LOGIC_VECTOR(3 downto 0) := "0000";

    -- Constantes de segmentos (activos en bajo, orden a,b,c,d,e,f,g)
    constant SEG_MINUS  : STD_LOGIC_VECTOR(6 downto 0) := "1111110"; -- solo 'g' encendido
    constant SEG_ERROR  : STD_LOGIC_VECTOR(6 downto 0) := "0000110"; -- 'E'
begin
    -- Mapeo de switches
    A  <= SW(3 downto 0);
    B  <= SW(7 downto 4);
    op <= SW(9 downto 8);

    -- Guard de entradas BCD
    UGUARD: entity work.bcd_guard
      port map(a => A, b => B, err => input_error);

    -- Núcleo ALU
    UALU: entity work.alu
      port map(
        A     => A,
        B     => B,
        op    => op,
        R     => R,
        sign  => sign,
        error => open
      );

    -- Suma/Resta -> unidades en R(3..0); decenas de suma = R(4); decenas de resta = signo
    sum_hi_bcd <= "000" & R(4);

    USUM_HI: entity work.bcd_to_7seg port map(bcd => sum_hi_bcd,     seg => seg_sum_hi);
    USUM_LO: entity work.bcd_to_7seg port map(bcd => R(3 downto 0),   seg => seg_sum_lo);

    UZERO:   entity work.bcd_to_7seg port map(bcd => BCD_ZERO,        seg => seg_zero);
    USUB_LO: entity work.bcd_to_7seg port map(bcd => R(3 downto 0),   seg => seg_sub_lo);
    seg_sub_hi <= SEG_MINUS when sign = '1' else seg_zero;

    -- Multiplicación -> bin8_to_bcd2 y a 7 segmentos
    U_B2BCD: entity work.bin8_to_bcd2
      port map( bin => R, tens => mul_bcd_hi, ones => mul_bcd_lo );
    UMUL_HI: entity work.bcd_to_7seg port map( bcd => mul_bcd_hi, seg => seg_mul_hi );
    UMUL_LO: entity work.bcd_to_7seg port map( bcd => mul_bcd_lo, seg => seg_mul_lo );

    -- MUX de resultado
    with op select
      HEX1_calc <= seg_sum_hi when "00",
                   seg_sub_hi when "01",
                   seg_mul_hi when "10",
                   (others => '1') when others;

    with op select
      HEX0_calc <= seg_sum_lo when "00",
                   seg_sub_lo when "01",
                   seg_mul_lo when "10",
                   (others => '1') when others;

    -- Si entradas inválidas, mostrar 'EE'
    HEX1 <= SEG_ERROR when input_error = '1' else HEX1_calc;
    HEX0 <= SEG_ERROR when input_error = '1' else HEX0_calc;

    -- Mostrar operandos
    UHEX_A: entity work.bcd_to_7seg port map(bcd => A, seg => HEX3);
    UHEX_B: entity work.bcd_to_7seg port map(bcd => B, seg => HEX2);
end Structural;
