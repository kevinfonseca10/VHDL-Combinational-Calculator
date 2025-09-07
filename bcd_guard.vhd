library ieee;
use ieee.std_logic_1164.all;

entity bcd_guard is
  port(
    a, b   : in  std_logic_vector(3 downto 0);
    err    : out std_logic
  );
end;

architecture rtl of bcd_guard is
begin
  err <= '1' when (a(3)='1' and (a(2)='1' or a(1)='1')) or
                 (b(3)='1' and (b(2)='1' or b(1)='1'))
         else '0';
end;