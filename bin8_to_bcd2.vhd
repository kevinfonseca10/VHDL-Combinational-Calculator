library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bin8_to_bcd2 is
  port (
    bin  : in  std_logic_vector(7 downto 0);
    tens : out std_logic_vector(3 downto 0);
    ones : out std_logic_vector(3 downto 0)
  );
end entity;

architecture behavioral of bin8_to_bcd2 is
begin

  process(bin)
    -- Variables para los dígitos BCD y el registro de desplazamiento
    variable huns     : std_logic_vector(3 downto 0); -- Centenas (necesario para cálculos intermedios)
    variable tens_v   : std_logic_vector(3 downto 0); -- Decenas
    variable ones_v   : std_logic_vector(3 downto 0); -- Unidades
    variable bin_v    : std_logic_vector(7 downto 0); -- Copia del binario a desplazar
  begin
    -- 1. Inicializar todas las variables
    huns   := (others => '0');
    tens_v := (others => '0');
    ones_v := (others => '0');
    bin_v  := bin;

    -- 2. Repetir 8 veces (una por cada bit de entrada)
    for i in 0 to 7 loop
      -- 3. ANTES de desplazar, verificar si algún dígito es 5 o mayor.
      -- Si lo es, se le suma 3. Se usa un 'case' como tabla de consulta
      -- para evitar usar el operador '+' que requiere otras librerías.

      -- Revisar y corregir dígito de las UNIDADES
      case ones_v is
        when "0101" => ones_v := "1000"; -- 5+3=8
        when "0110" => ones_v := "1001"; -- 6+3=9
        when "0111" => ones_v := "1010"; -- 7+3=10
        when "1000" => ones_v := "1011"; -- 8+3=11
        when "1001" => ones_v := "1100"; -- 9+3=12
        when others => null;
      end case;

      -- Revisar y corregir dígito de las DECENAS
      case tens_v is
        when "0101" => tens_v := "1000"; -- 5+3=8
        when "0110" => tens_v := "1001"; -- 6+3=9
        when "0111" => tens_v := "1010"; -- 7+3=10
        when "1000" => tens_v := "1011"; -- 8+3=11
        when "1001" => tens_v := "1100"; -- 9+3=12
        when others => null;
      end case;

      -- 4. Desplazar todo el conjunto un bit a la izquierda
      huns   := huns(2 downto 0) & tens_v(3);
      tens_v := tens_v(2 downto 0) & ones_v(3);
      ones_v := ones_v(2 downto 0) & bin_v(7);
      bin_v  := bin_v(6 downto 0) & '0';

    end loop;

    -- 5. Asignar los resultados finales a las salidas
    tens <= tens_v;
    ones <= ones_v;
  end process;

end architecture;