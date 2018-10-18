library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity add is
port(  a:   in std_logic_vector(31 downto 0);
       b:   in std_logic_vector(31 downto 0);
       y:   out std_logic_vector(31 downto 0)
      );
end add;

architecture behavioral of add is
begin
  y<=a+b;
end behavioral;