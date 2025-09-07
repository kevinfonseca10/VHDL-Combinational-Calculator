library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_calc_top is
end entity;

architecture sim of tb_calc_top is
  -- === Señales visibles en la simulación (solo estas 3) ===
  signal A_tb  : std_logic_vector(3 downto 0) := (others => '0');
  signal B_tb  : std_logic_vector(3 downto 0) := (others => '0');
  signal OP_tb : std_logic_vector(1 downto 0) := (others => '0');

  -- === Señales del DUT (no las agregaremos a la onda) ===
  signal SW   : std_logic_vector(9 downto 0);
  signal HEX0 : std_logic_vector(6 downto 0);
  signal HEX1 : std_logic_vector(6 downto 0);
  signal HEX2 : std_logic_vector(6 downto 0);
  signal HEX3 : std_logic_vector(6 downto 0);
begin
  -- Empaque hacia el tope real (calc_top espera SW)
  SW(3 downto 0) <= A_tb;
  SW(7 downto 4) <= B_tb;
  SW(9 downto 8) <= OP_tb;

  -- Instancia del DUT
  UUT: entity work.calc_top
    port map (
      SW   => SW,
      HEX0 => HEX0,
      HEX1 => HEX1,
      HEX2 => HEX2,
      HEX3 => HEX3
    );

  -- Estímulos: SOLO movemos A_tb, B_tb y OP_tb
  stim: process
    procedure apply(a_i : natural; b_i : natural; op_i : std_logic_vector(1 downto 0); lbl : string) is
    begin
      assert a_i <= 15 and b_i <= 15 report "A o B fuera de 4 bits" severity failure;
      A_tb  <= std_logic_vector(to_unsigned(a_i, 4));
      B_tb  <= std_logic_vector(to_unsigned(b_i, 4));
      OP_tb <= op_i;
      report lbl severity note;
      wait for 40 ns;
    end procedure;
  begin
    wait for 20 ns;

    -- Suma
    apply(0, 0, "00", "ADD 0+0");
    apply(5, 4, "00", "ADD 5+4");
    apply(9, 9, "00", "ADD 9+9");

    -- Resta
    apply(7, 2, "01", "SUB 7-2");
    apply(2, 7, "01", "SUB 2-7 (negativo)");

    -- Multiplicación
    apply(3, 4, "10", "MUL 3*4");
    apply(9, 9, "10", "MUL 9*9");

    -- Casos inválidos (>9)
    apply(10, 5, "00", "INVALID A=10");
    apply(5, 12, "10", "INVALID B=12");

    -- OP reservado
    apply(4, 3, "11", "OP=11");

    report "Fin TB" severity note;
    wait;
  end process;

end architecture;
